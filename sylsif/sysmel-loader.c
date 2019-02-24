#define _GNU_SOURCE 1
#include "sylsif.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/mman.h>
#include <malloc.h>
#include <dlfcn.h>

typedef struct sylsif_loading_class_s sylsif_loading_class_t;
static sylsif_loading_class_t *getLoadingObjectClass(sylsif_object_header_t *header);

static size_t alignSizeTo(size_t size, size_t alignment);
static size_t sizeOfImageMetadataSectionFor(size_t numberOfSections);
static sylsif_loaded_image_metadata_t *allocateLoadedImage(size_t numberOfSections);
static void freeLoadedImage(sylsif_loaded_image_metadata_t *loadedImage);
static int loadImageSectionFrom(sylsif_section_descriptor_t *sectionDescriptor, FILE *file);
static void freeImageSection(sylsif_section_descriptor_t *sectionDescriptor);

typedef struct sylsif_loading_class_file_pointer_member_s
{
    const char *name;
    uintptr_t offset;
} sylsif_loading_class_file_pointer_member_t;

/* Fake VTable for objects required by the loader. */
typedef struct sylsif_loading_class_s
{
    const char *name;

    size_t fixedObjectSize;
    size_t variableElementSize;
    int variableDataIsPointers;

    const sylsif_loading_class_file_pointer_member_t *filePointerMembers;
    size_t filePointerMemberCount;

    int (*solveSymbolValue) (sylsif_object_header_t *selfHeader, sylsif_loaded_image_metadata_t *image, uintptr_t *symbolValue);

    int (*applyRelocationsToSection) (sylsif_object_header_t *selfHeader, sylsif_loaded_image_metadata_t *image, sylsif_section_descriptor_t *targetSection);
    int (*applyRelocationToSection) (sylsif_object_header_t *selfHeader, sylsif_loaded_image_metadata_t *image, sylsif_section_descriptor_t *targetSection);
} sylsif_loading_class_t;

#define dispatch(self, method, ...) getLoadingObjectClass((sylsif_object_header_t*)(self))->method((sylsif_object_header_t*)(self), __VA_ARGS__)
#define dispatchIfNotNil(self, ...) if(self != 0) dispatch(self, __VA_ARGS__)
#define convertFilePointer(pointer) if(pointer != 0) printf("TODO: Convert file pointer %p\n", (void*)pointer)

#define expandMacroParents(...) __VA_ARGS__

#define beginClass(typedefName, filePointers) \
static const sylsif_loading_class_file_pointer_member_t typedefName ## _filePointers[] = {expandMacroParents filePointers}; \
static sylsif_loading_class_t typedefName ## _ClassDefinition = {\
    .name = #typedefName, \
    .fixedObjectSize = sizeof(typedefName), \
    .filePointerMembers = typedefName ## _filePointers, \
    .filePointerMemberCount = sizeof(typedefName ## _filePointers) / sizeof(typedefName ## _filePointers [0]), \

#define filePointerMemberOf(typedefName, memberName) \
    { .name = #memberName, .offset = offsetof(typedefName, memberName) }

#define endClass() }
#define classFor(typedefName) (&typedefName ## _ClassDefinition)

/**
 * sylsif_image_memory_object_t is any generic object with direct memory pointers.
 * This class is used as a fallback.
 */
typedef sylsif_object_t sylsif_image_memory_object_t;

beginClass(sylsif_image_memory_object_t, ())
endClass();


/**
 * sylsif_unsupported_object_t
 */
typedef sylsif_object_t sylsif_unsupported_object_t;

beginClass(sylsif_unsupported_object_t, ())
endClass();

/**
 * sylsif_array_t
 */

static int array_applyRelocationsToSection (sylsif_object_header_t *selfHeader, sylsif_loaded_image_metadata_t *image, sylsif_section_descriptor_t *targetSection)
{
    sylsif_array_t *self = (sylsif_array_t*)selfHeader;
    size_t numberOfElement = self->objectHeader.variableDataSize;
    for(size_t i = 0; i < numberOfElement; ++i)
    {
        uintptr_t relocation = self->elements[i];
        if(!dispatch(relocation, applyRelocationToSection, image, targetSection))
            return 0;
    }
    return 1;
}

beginClass(sylsif_array_t, ())
    .variableElementSize = sizeof(uintptr_t),
    .variableDataIsPointers = 1,

    .applyRelocationsToSection = array_applyRelocationsToSection,
endClass();

/**
 * sylsif_string_t
 */
beginClass(sylsif_string_t, ())
    .variableElementSize = 1,
endClass();

/**
 * sylsif_symbol_t
 */
beginClass(sylsif_symbol_t, ())
    .variableElementSize = 1,
endClass();

/**
 * sylsif_loaded_image_metadata_t
 */
beginClass(sylsif_loaded_image_metadata_t, ())
endClass();

/**
 * sylsif_section_descriptor_t
 */
beginClass(sylsif_section_descriptor_t, ( \
    filePointerMemberOf(sylsif_section_descriptor_t, nameSymbol), \
    filePointerMemberOf(sylsif_section_descriptor_t, relocations), \
))
endClass();

/**
 * sylsif_symbol_table_t
 */
beginClass(sylsif_symbol_table_t, ( \
    filePointerMemberOf(sylsif_symbol_table_t, symbols), \
))
endClass();

/**
 * sylsif_symbol_table_entry_t
 */
static int symbol_table_entry_solveSymbolValue(sylsif_object_header_t *selfHeader, sylsif_loaded_image_metadata_t *image, uintptr_t *symbolValue)
{
    char nameBuffer[512];
    sylsif_symbol_table_entry_t *self = (sylsif_symbol_table_entry_t*)selfHeader;

    /* If the symbol is already solved, use its value. */
    if(self->flags & SYLSIF_SYMBOL_FLAGS_SOLVED)
    {
        *symbolValue = self->value;
        return 1;
    }

    sylsif_symbol_t *name = (sylsif_symbol_t*)self->name;
    if(!name)
    {
        fprintf(stderr, "Symbol without name.\n");
        return 0;
    }

    /* Make sure that the name is a symbol. */
    if(getLoadingObjectClass((sylsif_object_header_t*)name) != classFor(sylsif_symbol_t))
    {
        fprintf(stderr, "Symbol with invalid name.\n");
        return 1;
    }

    switch(self->visibility)
    {
    case SYLSIF_SYMBOL_VISIBILITY_DLL_IMPORT:
    case SYLSIF_SYMBOL_VISIBILITY_EXTERNAL:
        {
            /* TODO: Use a dynamic buffer for large symbols. */
            if(name->objectHeader.variableDataSize >= sizeof(nameBuffer))
            {
                printf("External symbol name is too large for solving: %.*s\n", name->objectHeader.variableDataSize, name->characters);
                return 1;
            }

            /* Copy the symbol name into a null terminated buffer. */
            memcpy(nameBuffer, name->characters, name->objectHeader.variableDataSize);
            nameBuffer[name->objectHeader.variableDataSize] = 0;

            /* Fetch the symbol value. */
            dlerror(); /* Clear old error. */
            void *externalSymbolValue = dlsym(RTLD_DEFAULT, nameBuffer);
            const char *errorMessage = dlerror();
            if(errorMessage)
            {
                fprintf(stderr, "Failed to solve external symbol %.*s: %s\n", name->objectHeader.variableDataSize, name->characters, errorMessage);
                return 1;
            }

            /* Store the solved symbol. */
            self->value = (uintptr_t)externalSymbolValue;
        }
        break;

    case SYLSIF_SYMBOL_VISIBILITY_WEAK:
    case SYLSIF_SYMBOL_VISIBILITY_PRIVATE:
    case SYLSIF_SYMBOL_VISIBILITY_PUBLIC:
    case SYLSIF_SYMBOL_VISIBILITY_DLL_EXPORT:
        {
            sylsif_section_descriptor_t *section = (sylsif_section_descriptor_t*)self->sectionDescriptor;
            /*printf("Solving internal symbol: %.*s\n", name->objectHeader.variableDataSize, name->characters);*/
            self->value = section->memoryLoadingAddress + self->sectionOffset;
        }
        break;
    default:
        printf("Cannot solve symbol with unsupported visibility of type: %d\n", self->visibility);
        return 0;
    }

    self->flags |= SYLSIF_SYMBOL_FLAGS_SOLVED;
    *symbolValue = self->value;
    return 1;
}

beginClass(sylsif_symbol_table_entry_t, ( \
    filePointerMemberOf(sylsif_symbol_table_entry_t, name), \
    filePointerMemberOf(sylsif_symbol_table_entry_t, sectionDescriptor), \
))
    .solveSymbolValue = symbol_table_entry_solveSymbolValue,
endClass();

/**
 * Relocations with addends.
 */
static int rela_commonValidation(sylsif_rela_t *rela, size_t relocationSize, sylsif_loaded_image_metadata_t *image, sylsif_section_descriptor_t *targetSection, uint8_t **targetPointer, uintptr_t *symbolValue)
{
    /* Check the section offset. */
    if(rela->sectionOffset + relocationSize > targetSection->memorySize)
    {
        fprintf(stderr, "Relocation with addend applied to a place out of bounds.\n");
        return 1;
    }

    *targetPointer = (uint8_t*) (targetSection->memoryLoadingAddress + rela->sectionOffset);

    /* Solve the symbol/section value. */
    if(rela->symbol)
    {
        if(!dispatch(rela->symbol, solveSymbolValue, image, symbolValue))
            return 0;
    }
    else if(rela->section)
    {
        sylsif_section_descriptor_t *valueSection = (sylsif_section_descriptor_t*)rela->section;
        *symbolValue = valueSection->memoryLoadingAddress;
    }
    else
    {
        fprintf(stderr, "Relocation with addend without symbol or section to solve.\n");
        return 0;
    }

    return 1;
}

#define standardRelaRelocation(relocationTypedef, targetPointerType, applicationAction) \
static int relocationTypedef ## _applyRelocationToSection (sylsif_object_header_t *selfHeader, sylsif_loaded_image_metadata_t *image, sylsif_section_descriptor_t *targetSection) { \
    uint8_t *targetPointer; \
    uintptr_t symbolValue; \
    relocationTypedef *rela = (relocationTypedef*)selfHeader; \
    if(!rela_commonValidation(rela, sizeof(targetPointerType), image, targetSection, &targetPointer, &symbolValue)) \
        return 0; \
    targetPointerType *target = (targetPointerType*)targetPointer; \
    uintptr_t targetAddress = (uintptr_t)targetPointer; \
    uintptr_t addend = rela->addend; \
    (void)target; (void)targetAddress; (void)addend; \
    applicationAction; \
    /*printf("Apply " #relocationTypedef " %p to %p\n", rela, targetSection);*/ \
    return 1; \
}\
beginClass(relocationTypedef, ( \
    filePointerMemberOf(relocationTypedef, section), \
    filePointerMemberOf(relocationTypedef, symbol), \
)) \
    .applyRelocationToSection = relocationTypedef ## _applyRelocationToSection, \
endClass();

standardRelaRelocation(sylsif_rela_absolute_offset8_t, uint8_t, (
    *target = (uint8_t)(symbolValue + addend)
));
standardRelaRelocation(sylsif_rela_absolute_offset16_t, uint16_t, (
    *target = (uint16_t)(symbolValue + addend)
));
standardRelaRelocation(sylsif_rela_absolute_offset32_t, uint32_t, (
    *target = (uint32_t)(symbolValue + addend)
));
standardRelaRelocation(sylsif_rela_absolute_signed_offset32_t, int32_t, (
    *target = (int32_t)(symbolValue + addend)
));
standardRelaRelocation(sylsif_rela_absolute_offset64_t, uint64_t, (
    *target = (uint64_t)(symbolValue + addend)
));

standardRelaRelocation(sylsif_rela_section_relative_offset32_t, uint32_t, abort());
standardRelaRelocation(sylsif_rela_section_relative_offset64_t, uint64_t, abort());

standardRelaRelocation(sylsif_rela_relative_signed_offset8_t, int8_t, (
    *target = (int8_t) (symbolValue - targetAddress + addend)
));
standardRelaRelocation(sylsif_rela_relative_signed_offset16_t, int16_t, (
    *target = (int16_t) (symbolValue - targetAddress + addend)
));
standardRelaRelocation(sylsif_rela_relative_signed_offset32_t, int32_t, (
    *target = (int32_t) (symbolValue - targetAddress + addend)
));
standardRelaRelocation(sylsif_rela_relative_signed_offset64_t, int64_t, (
    *target = (int64_t) (symbolValue - targetAddress + addend)
));

standardRelaRelocation(sylsif_rela_relative_signed_offset32_at_got_t, int32_t, abort());
standardRelaRelocation(sylsif_rela_relative_signed_offset32_got_t, int32_t, abort());
standardRelaRelocation(sylsif_rela_relative_signed_offset32_global_offset_table_t, int32_t, abort());

standardRelaRelocation(sylsif_rela_relative_branch32_t, int32_t, (
    *target = (int32_t) (symbolValue - targetAddress + addend)
));

/***
 * This maps a vtable pointer into a loading time only virtual vtable.
 */
static sylsif_loading_class_t *getLoadingObjectClass(sylsif_object_header_t *header)
{
    intptr_t vtableIndex = (intptr_t)header->vtable;
    if(vtableIndex >= 0)
        return classFor(sylsif_image_memory_object_t);

    switch(header->vtable)
    {
    case SYLSIF_SPECIAL_VTABLE_ARRAY: return classFor(sylsif_array_t);
    case SYLSIF_SPECIAL_VTABLE_SYMBOL: return classFor(sylsif_symbol_t);
    case SYLSIF_SPECIAL_VTABLE_STRING: return classFor(sylsif_string_t);

    case SYLSIF_SPECIAL_VTABLE_SECTION_DESCRIPTOR: return classFor(sylsif_section_descriptor_t);
    case SYLSIF_SPECIAL_VTABLE_SYMBOL_TABLE: return classFor(sylsif_symbol_table_t);
    case SYLSIF_SPECIAL_VTABLE_SYMBOL_TABLE_ENTRY: return classFor(sylsif_symbol_table_entry_t);
    case SYLSIF_SPECIAL_VTABLE_IMAGE_METADATA: return classFor(sylsif_loaded_image_metadata_t);

    case SYLSIF_SPECIAL_VTABLE_RELA_ABSOLUTE_OFFSET8: return classFor(sylsif_rela_absolute_offset8_t);
    case SYLSIF_SPECIAL_VTABLE_RELA_ABSOLUTE_OFFSET16: return classFor(sylsif_rela_absolute_offset16_t);
    case SYLSIF_SPECIAL_VTABLE_RELA_ABSOLUTE_OFFSET32: return classFor(sylsif_rela_absolute_offset32_t);
    case SYLSIF_SPECIAL_VTABLE_RELA_ABSOLUTE_SIGNED_OFFSET32: return classFor(sylsif_rela_absolute_signed_offset32_t);
    case SYLSIF_SPECIAL_VTABLE_RELA_ABSOLUTE_OFFSET64: return classFor(sylsif_rela_absolute_offset64_t);

    case SYLSIF_SPECIAL_VTABLE_RELA_SECTION_RELATIVE_OFFSET32: return classFor(sylsif_rela_section_relative_offset32_t);
    case SYLSIF_SPECIAL_VTABLE_RELA_SECTION_RELATIVE_OFFSET64: return classFor(sylsif_rela_section_relative_offset64_t);

    case SYLSIF_SPECIAL_VTABLE_RELA_RELATIVE_SIGNED_OFFSET8: return classFor(sylsif_rela_relative_signed_offset8_t);
    case SYLSIF_SPECIAL_VTABLE_RELA_RELATIVE_SIGNED_OFFSET16: return classFor(sylsif_rela_relative_signed_offset16_t);
    case SYLSIF_SPECIAL_VTABLE_RELA_RELATIVE_SIGNED_OFFSET32: return classFor(sylsif_rela_relative_signed_offset32_t);
    case SYLSIF_SPECIAL_VTABLE_RELA_RELATIVE_SIGNED_OFFSET64: return classFor(sylsif_rela_relative_signed_offset64_t);

    case SYLSIF_SPECIAL_VTABLE_RELA_RELATIVE_SIGNED_OFFSET32_AT_GOT: return classFor(sylsif_rela_relative_signed_offset32_at_got_t);
    case SYLSIF_SPECIAL_VTABLE_RELA_RELATIVE_SIGNED_OFFSET32_GOT_OFFSET: return classFor(sylsif_rela_relative_signed_offset32_got_t);
    case SYLSIF_SPECIAL_VTABLE_RELA_RELATIVE_SIGNED_OFFSET32_GLOBAL_OFFSET_TABLE: return classFor(sylsif_rela_relative_signed_offset32_global_offset_table_t);
    case SYLSIF_SPECIAL_VTABLE_RELA_RELATIVE_BRANCH_32: return classFor(sylsif_rela_relative_branch32_t);
    default: return classFor(sylsif_unsupported_object_t);
    }
}

static size_t alignSizeTo(size_t size, size_t alignment)
{
    return (size + alignment - 1) & (-alignment);
}

static size_t sizeOfImageMetadataSectionFor(size_t numberOfSections)
{
    return alignSizeTo(
        sizeof(sylsif_loaded_image_metadata_t) +
        (1 + numberOfSections) * sizeof(sylsif_section_descriptor_t),
        4096);
}

static sylsif_loaded_image_metadata_t *allocateLoadedImage(size_t numberOfSections)
{
    /* Lets put the image metadata in an unnamed section too. */
    size_t allocationSize = sizeOfImageMetadataSectionFor(numberOfSections);
    uint8_t *metadataMemory = mmap(NULL, allocationSize, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if(metadataMemory == MAP_FAILED)
        return NULL;

    sylsif_loaded_image_metadata_t *imageMetadata = (sylsif_loaded_image_metadata_t*)metadataMemory;
    imageMetadata->objectHeader.vtable = SYLSIF_SPECIAL_VTABLE_IMAGE_METADATA;
    imageMetadata->numberOfSections = numberOfSections;
    imageMetadata->sectionDescriptors = (sylsif_section_descriptor_t*)&imageMetadata[1];

    /* Add an additional section to represent the image metadata itself. */
    sylsif_section_descriptor_t *imageSection = &imageMetadata->sectionDescriptors[numberOfSections];
    imageSection->memoryLoadingAddress = (uintptr_t)metadataMemory;
    imageSection->memorySize = allocationSize;
    imageSection->memoryAlignment = 4096;
    imageSection->memoryFlags = SYLSIF_SECTION_MEMORY_FLAGS_READABLE | SYLSIF_SECTION_MEMORY_FLAGS_WRITEABLE;

    return imageMetadata;
}

static int mapPointerWithMappingTable(sylsif_address_mapping_table_t *mappingTable, uintptr_t *pointer)
{
    uintptr_t sourceAddress = *pointer;
    sylsif_address_mapping_range_t *addressRange = sylsif_address_mapping_table_find(mappingTable, sourceAddress);
    if(!addressRange)
        return 0;

    *pointer = sourceAddress - addressRange->sourceStartAddress + addressRange->targetStartAddress;
    return 1;
}

static void freeLoadedImage(sylsif_loaded_image_metadata_t *loadedImage)
{
    if(!loadedImage)
        return;

    /* Free the address mapping table. */
    sylsif_address_mapping_table_free(&loadedImage->fileOffsetToLoadingAddressMappingTable);

    /* Unmap the loaded image sections. */
    for(size_t i = 0; i < loadedImage->numberOfSections; ++i)
    {
        freeImageSection(&loadedImage->sectionDescriptors[i]);
    }

    /* Unmap the loaded image. */
    munmap(loadedImage, loadedImage->sectionDescriptors[loadedImage->numberOfSections].memorySize);
}

static int loadImageSectionFrom(sylsif_section_descriptor_t *sectionDescriptor, FILE *file)
{
    /* By default clear the memory pointer. */
    sectionDescriptor->memoryLoadingAddress = 0;

    /* Only allocate sections that have the readable flag. */
    uintptr_t flags = sectionDescriptor->memoryFlags;
    if(!(flags & SYLSIF_SECTION_MEMORY_FLAGS_READABLE) || sectionDescriptor->memorySize == 0)
        return 1;

    /* The file size cannot be bigger than the memory size. */
    if(sectionDescriptor->fileSize > sectionDescriptor->memorySize)
    {
        fprintf(stderr, "Image section file size[%zu] is bigger than loaded size [%zu]\n", sectionDescriptor->fileSize, sectionDescriptor->memorySize);
        return 0;
    }

    /* Compute the actual section size, and allocate the section memory. */
    size_t allocationSize = alignSizeTo(sectionDescriptor->memorySize, 4096);
    uint8_t *memoryPointer = mmap(NULL, allocationSize, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if(memoryPointer == MAP_FAILED)
        return 0;

    /* Load the section data from disk. */
    if(flags & SYLSIF_SECTION_MEMORY_FLAGS_LOADED)
    {
        if(fseek(file, sectionDescriptor->fileOffset, SEEK_SET) != 0 ||
           fread(memoryPointer, sectionDescriptor->fileSize, 1, file) != 1)
        {
            munmap(memoryPointer, allocationSize);
            return 0;
        }
    }

    /* Store the memory loading address. */
    sectionDescriptor->memoryLoadingAddress = (uintptr_t)memoryPointer;
    return 1;
}

static void freeImageSection(sylsif_section_descriptor_t *sectionDescriptor)
{
    if(!sectionDescriptor->memoryLoadingAddress)
        return;

    size_t actualMemorySize = alignSizeTo(sectionDescriptor->memorySize, 4096);
    munmap((void*)sectionDescriptor->memoryLoadingAddress, actualMemorySize);
}

static int mapImageFilePointerToMemoryPointer(sylsif_loaded_image_metadata_t *image, uintptr_t *pointer)
{
    if(*pointer == 0)
        return 1;

    return mapPointerWithMappingTable(&image->fileOffsetToLoadingAddressMappingTable, pointer);
}

static int convertImageObjectFilePointers(sylsif_loaded_image_metadata_t *image, sylsif_object_header_t *object)
{
    if(!object)
        return 1;

    /* Create the mapping table */

    /* Get the loading object class. */
    sylsif_loading_class_t *class = getLoadingObjectClass(object);
    /*printf("Coverting file pointers of [%p]%s\n", object, class->name);*/
    uint8_t *basePointer = (uint8_t*)object;

    for(size_t i = 0; i < class->filePointerMemberCount; ++i)
    {
        const sylsif_loading_class_file_pointer_member_t *memberDescription = &class->filePointerMembers[i];

        uintptr_t *memberPointer = (uintptr_t*)(basePointer + memberDescription->offset);
        if(!mapImageFilePointerToMemoryPointer(image, memberPointer))
        {
            fprintf(stderr, "Cannot convert file pointer [%s.%s]%p\n", class->name, memberDescription->name, (void*)*memberPointer);
            return 0;
        }
    }

    if(class->variableDataIsPointers)
    {
        size_t variableDataSize = object->variableDataSize;
        uintptr_t *variablePointers = (uintptr_t*) (basePointer + class->fixedObjectSize);
        for(size_t i = 0; i < variableDataSize; ++i)
        {
            uintptr_t *elementPointer = &variablePointers[i];
            if(!mapImageFilePointerToMemoryPointer(image, elementPointer))
            {
                fprintf(stderr, "Cannot convert file pointer [%s[%zu]]%p\n", class->name, i, (void*)*elementPointer);
                return 0;
            }
        }
    }

    return 1;
}

static size_t sizeOfObjectWithLoadingClass(sylsif_object_header_t *object, sylsif_loading_class_t *class)
{
    return alignSizeTo(class->fixedObjectSize + class->variableElementSize*object->variableDataSize, 16);
}
static int convertFilePointersOfSection(sylsif_loaded_image_metadata_t *image, sylsif_section_descriptor_t *section)
{
    uint8_t *currentAddress = (uint8_t*)section->memoryLoadingAddress;
    uint8_t *endAddress = currentAddress + section->memorySize;

    /* Process all the objects in the section, in a sequential order. */
    while(currentAddress < endAddress)
    {
        sylsif_object_header_t *currentObjectHeader = (sylsif_object_header_t*)currentAddress;

        /* Perform a sanity check on the class. */
        sylsif_loading_class_t *objectClass = getLoadingObjectClass(currentObjectHeader);
        if(objectClass == classFor(sylsif_image_memory_object_t))
        {
            fprintf(stderr, "Object %p with invalid non-loading class in section with file pointers.\n", currentObjectHeader);
            return 0;

        }
        if(objectClass == classFor(sylsif_unsupported_object_t))
        {
            fprintf(stderr, "Object %p with unsupported loading class: %d\n", currentObjectHeader, (int)currentObjectHeader->vtable);
            return 0;
        }

        /* Compute the object size. */
        size_t objectSize = sizeOfObjectWithLoadingClass(currentObjectHeader, objectClass);
        uint8_t *nextAddress = currentAddress + objectSize;
        if(nextAddress > endAddress)
        {
            fprintf(stderr, "Object %p with loading class %d has invalid size.\n", currentObjectHeader, (int)currentObjectHeader->vtable);
            return 0;
        }

        /* Convert the object file pointers. */
        if(!convertImageObjectFilePointers(image, currentObjectHeader))
        {
            return 0;
        }

        /* Advance according to the object size. */
        currentAddress += objectSize;
    }

    if(currentAddress != endAddress)
    {
        fprintf(stderr, "Failed to process section with file pointer. Mismatching sizes of processed objects.\n");
        return 0;
    }

    return 1;
}

static int convertImageFilePointers(sylsif_loaded_image_metadata_t *image)
{
    /* Construct the convertion table. */
    sylsif_address_mapping_table_allocate(&image->fileOffsetToLoadingAddressMappingTable, image->numberOfSections + 1);

    /* Add a mapping for the section descriptor themselves. */
    {
        sylsif_address_mapping_range_t range = {
            .sourceStartAddress = sizeof(sylsif_header_t),
            .sourceEndAddress = sizeof(sylsif_header_t) + image->numberOfSections * sizeof(sylsif_section_descriptor_t),
            .targetStartAddress = ((uintptr_t)image->sectionDescriptors),
            .targetEndAddress = ((uintptr_t)image->sectionDescriptors) + image->numberOfSections * sizeof(sylsif_section_descriptor_t)
        };

        sylsif_address_mapping_table_add(&image->fileOffsetToLoadingAddressMappingTable, range);
    }

    /* Add mappings for the content of the sections. */
    for(uint32_t i = 0; i <= image->numberOfSections; ++i)
    {
        sylsif_section_descriptor_t *section = &image->sectionDescriptors[i];
        if(section->memoryLoadingAddress == 0)
            continue;

        sylsif_address_mapping_range_t range = {
            .sourceStartAddress = section->fileOffset,
            .sourceEndAddress = section->fileOffset + section->fileSize,
            .targetStartAddress = section->memoryLoadingAddress,
            .targetEndAddress = section->memoryLoadingAddress + section->memorySize
        };

        sylsif_address_mapping_table_add(&image->fileOffsetToLoadingAddressMappingTable, range);
    }

    /* Convert the image sections. */
    for(uint32_t i = 0; i <= image->numberOfSections; ++i)
    {
        sylsif_section_descriptor_t *section = &image->sectionDescriptors[i];

        /* Convert the section object descriptor file pointer. */
        if(!convertImageObjectFilePointers(image, &section->objectHeader))
            return 0;

        /* Convert the content of some sections. */
        if((section->memoryFlags & SYLSIF_SECTION_MEMORY_FLAGS_OBJECTS_WITH_FILE_POINTERS) != 0)
        {
            if(!convertFilePointersOfSection(image, section))
                return 0;
        }
    }

    /* Convert the global symbol table address. */
    return
        mapImageFilePointerToMemoryPointer(image, (uintptr_t*)&image->globalSymbolTable) &&
        mapImageFilePointerToMemoryPointer(image, (uintptr_t*)&image->entryPointSymbol);
}

int applyImageRelocations(sylsif_loaded_image_metadata_t *image)
{
    for(uint32_t i = 0; i <= image->numberOfSections; ++i)
    {
        sylsif_section_descriptor_t *section = &image->sectionDescriptors[i];
        if(!section->memoryLoadingAddress)
            continue;

        if(!section->relocations)
            continue;

        if(!dispatch(section->relocations, applyRelocationsToSection, image, section))
            return 0;
    }

    return 1;
}

int applySectionFinalPermissions(sylsif_section_descriptor_t *section)
{
    if(!section->memoryLoadingAddress)
        return 1;

    int protectionMode = 0;
    if(section->memoryFlags & SYLSIF_SECTION_MEMORY_FLAGS_READABLE)
        protectionMode |= PROT_READ;
    if(section->memoryFlags & SYLSIF_SECTION_MEMORY_FLAGS_WRITEABLE)
        protectionMode |= PROT_WRITE;
    if(section->memoryFlags & SYLSIF_SECTION_MEMORY_FLAGS_EXECUTABLE)
        protectionMode |= PROT_EXEC;

    void *sectionAddress = (void*)section->memoryLoadingAddress;
    size_t sectionSize = alignSizeTo(section->memorySize, 4096);
    if(mprotect(sectionAddress, sectionSize, protectionMode) != 0)
    {
        perror("Failed to set section final memory protection flags");
        return 0;
    }

    return 1;
}

int applyImageFinalPermissions(sylsif_loaded_image_metadata_t *image)
{
    for(uint32_t i = 0; i <= image->numberOfSections; ++i)
    {
        sylsif_section_descriptor_t *section = &image->sectionDescriptors[i];
        if(!applySectionFinalPermissions(section))
            return 0;
    }

    return 1;
}

void sylsif_address_mapping_table_allocate(sylsif_address_mapping_table_t *mappingTable, size_t initialCapacity)
{
    mappingTable->ranges = calloc(initialCapacity, sizeof(sylsif_address_mapping_table_t));
    mappingTable->tableCapacity = initialCapacity;
}

void sylsif_address_mapping_table_free(sylsif_address_mapping_table_t *mappingTable)
{
    if(mappingTable->ranges)
        free(mappingTable->ranges);

    memset(mappingTable, 0, sizeof(sylsif_address_mapping_table_t));
}

void sylsif_address_mapping_table_add(sylsif_address_mapping_table_t *mappingTable, sylsif_address_mapping_range_t range)
{
    if(mappingTable->numberOfRanges == mappingTable->tableCapacity)
    {
        // TODO: Implement this.
        abort();
    }

    mappingTable->ranges[mappingTable->numberOfRanges++] = range;
}

sylsif_address_mapping_range_t *sylsif_address_mapping_table_find(sylsif_address_mapping_table_t *mappingTable, uintptr_t sourceAddress)
{
    if(!mappingTable || !mappingTable->ranges)
        return NULL;

    /* TODO: Use a binary search here. */
    for(size_t i = 0; i < mappingTable->numberOfRanges; ++i)
    {
        sylsif_address_mapping_range_t *range = &mappingTable->ranges[i];
        if(range->sourceStartAddress <= sourceAddress && sourceAddress < range->sourceEndAddress)
            return range;
    }

    return NULL;
}

int main(int argc, const char *argv[])
{
    /* Make sure that we at least have the image file name. */
    if(argc < 2)
    {
        fprintf(stderr, "An image file is required to be passed.\n");
        return 1;
    }

    /* Open the image file. */
    const char *imageFileName = argv[1];
    FILE *imageFile = fopen(imageFileName, "rb");
    if(!imageFile)
    {
        perror("Failed to open image file");
        return 1;
    }

    /* Read the image file header. */
    sylsif_header_t header;
    if(fread(&header, sizeof(header), 1, imageFile) != 1)
    {
        perror("Failed to read image file");
        fclose(imageFile);
        return 1;
    }

    /* Check the signature */
    if(memcmp(header.signature.magic, SYLSIF_SIGNATURE_MAGIC, 4))
    {
        fprintf(stderr, "Image file with invalid signature.\n");
        fclose(imageFile);
        return 1;
    }

    /* Check the platform */
    if((!memcmp(header.signature.pointerSize, "32", 2) && sizeof(void*) != 4) ||
        (!memcmp(header.signature.pointerSize, "64", 2) && sizeof(void*) != 8))
    {
        fprintf(stderr, "Using image[%.2s] with the wrong pointer size[%d].\n", header.signature.pointerSize, (int)sizeof(void*));
        fclose(imageFile);
        return 1;
    }

    /* Allocate the loaded loaded image. */
    sylsif_loaded_image_metadata_t *imageMetadata = allocateLoadedImage(header.numberOfSections);
    imageMetadata->globalSymbolTable = (sylsif_symbol_table_t*)(uintptr_t)header.globalSymbolTable;
    imageMetadata->entryPointSymbol = (sylsif_symbol_table_entry_t*)(uintptr_t)header.entryPointSymbol;

    /* Read the section descriptors. */
    if(fread(imageMetadata->sectionDescriptors, sizeof(sylsif_section_descriptor_t), header.numberOfSections, imageFile) != header.numberOfSections)
    {
        fprintf(stderr, "Failed to read section descriptors.\n");
        freeLoadedImage(imageMetadata);
        fclose(imageFile);
        return 1;
    }

    /* Load the sections. */
    for(size_t i = 0; i < header.numberOfSections; ++i)
    {
        if(!loadImageSectionFrom(&imageMetadata->sectionDescriptors[i], imageFile))
        {
            freeLoadedImage(imageMetadata);
            fclose(imageFile);
            return 1;
        }
    }

    /* Close the image file. */
    fclose(imageFile);

    /* Convert the file pointers, apply the relocations, and set the final
       permissions of the loaded sections */
    if(!convertImageFilePointers(imageMetadata) ||
       !applyImageRelocations(imageMetadata) ||
       !applyImageFinalPermissions(imageMetadata))
    {
        freeLoadedImage(imageMetadata);
        return 1;
    }

    if(imageMetadata->entryPointSymbol)
    {
        uintptr_t entryPointAddress = 0;
        if(!dispatch(imageMetadata->entryPointSymbol, solveSymbolValue, imageMetadata, &entryPointAddress))
            return 1;

        sylsif_entry_point_function_t entryPoint = (sylsif_entry_point_function_t)entryPointAddress;
        return entryPoint(imageMetadata, argc, argv);
    }

    freeLoadedImage(imageMetadata);
    return 0;
}
