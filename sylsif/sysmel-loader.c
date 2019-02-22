#include "sylsif.h"
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/mman.h>
#include <malloc.h>

typedef struct sylsif_loading_class_s sylsif_loading_class_t;
static sylsif_loading_class_t *getLoadingObjectClass(sylsif_object_header_t *header);

static size_t alignSizeTo(size_t size, size_t alignment);
static size_t sizeOfImageMetadataSectionFor(size_t numberOfSections);
static sylsif_loaded_image_metadata_t *allocateLoadedImage(size_t numberOfSections);
static void freeLoadedImage(sylsif_loaded_image_metadata_t *loadedImage);
static int loadImageSectionFrom(sylsif_section_descriptor_t *sectionDescriptor, FILE *file);
static void freeImageSection(sylsif_section_descriptor_t *sectionDescriptor);

/* Fake VTable for objects required by the loader. */
typedef struct sylsif_loading_class_s
{
    size_t fixedObjectSize;
    size_t variableElementSize;

    const uintptr_t *filePointerMembers;
    size_t filePointerMemberCount;
} sylsif_loading_class_t;

#define dispatch(self, method, ...) getLoadingObjectClass(&(self)->objectHeader)->method(&(self)->objectHeader, __VA_ARGS__)
#define dispatchIfNotNil(self, ...) if(self != 0) dispatch(self, __VA_ARGS__)
#define convertFilePointer(pointer) if(pointer != 0) printf("TODO: Convert file pointer %p\n", (void*)pointer)

#define expandMacroParents(...) __VA_ARGS__

#define beginClass(typedefName, filePointers) \
static const size_t typedefName ## _filePointers[] = {expandMacroParents filePointers}; \
static sylsif_loading_class_t typedefName ## _ClassDefinition = {\
    .fixedObjectSize = sizeof(typedefName), \
    .filePointerMembers = typedefName ## _filePointers, \
    .filePointerMemberCount = sizeof(typedefName ## _filePointers) / sizeof(typedefName ## _filePointers [0]), \

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
 * sylsif_loaded_image_metadata_t
 */
beginClass(sylsif_loaded_image_metadata_t, ())
endClass();

/**
 * sylsif_section_descriptor_t
 */
beginClass(sylsif_section_descriptor_t, ( \
    offsetof(sylsif_section_descriptor_t, nameSymbol), \
    offsetof(sylsif_section_descriptor_t, relocations), \
))
endClass();

/***
 * This maps a vtable pointer into a loading time only virtual vtable.
 */
static sylsif_loading_class_t *getLoadingObjectClass(sylsif_object_header_t *header)
{
    intptr_t vtableIndex = (intptr_t)header->vtable;
    if(vtableIndex >= 0)
        return classFor(sylsif_image_memory_object_t);

    if(vtableIndex)
    switch(header->vtable)
    {
    case SYLSIF_SPECIAL_VTABLE_ARRAY: return classFor(sylsif_unsupported_object_t);
    case SYLSIF_SPECIAL_VTABLE_SYMBOL: return classFor(sylsif_unsupported_object_t);
    case SYLSIF_SPECIAL_VTABLE_STRING: return classFor(sylsif_unsupported_object_t);

    case SYLSIF_SPECIAL_VTABLE_SECTION_DESCRIPTOR: return classFor(sylsif_section_descriptor_t);
    case SYLSIF_SPECIAL_VTABLE_SYMBOL_TABLE: return classFor(sylsif_unsupported_object_t);
    case SYLSIF_SPECIAL_VTABLE_SYMBOL_TABLE_ENTRY: return classFor(sylsif_unsupported_object_t);
    case SYLSIF_SPECIAL_VTABLE_IMAGE_METADATA: return classFor(sylsif_loaded_image_metadata_t);

    case SYLSIF_SPECIAL_VTABLE_RELA_ABSOLUTE_OFFSET8: return classFor(sylsif_unsupported_object_t);
    case SYLSIF_SPECIAL_VTABLE_RELA_ABSOLUTE_OFFSET16: return classFor(sylsif_unsupported_object_t);
    case SYLSIF_SPECIAL_VTABLE_RELA_ABSOLUTE_OFFSET32: return classFor(sylsif_unsupported_object_t);
    case SYLSIF_SPECIAL_VTABLE_RELA_ABSOLUTE_SIGNED_OFFSET32: return classFor(sylsif_unsupported_object_t);
    case SYLSIF_SPECIAL_VTABLE_RELA_ABSOLUTE_OFFSET64: return classFor(sylsif_unsupported_object_t);

    case SYLSIF_SPECIAL_VTABLE_RELA_SECTION_RELATIVE_OFFSET32: return classFor(sylsif_unsupported_object_t);
    case SYLSIF_SPECIAL_VTABLE_RELA_SECTION_RELATIVE_OFFSET64: return classFor(sylsif_unsupported_object_t);

    case SYLSIF_SPECIAL_VTABLE_RELA_RELATIVE_SIGNED_OFFSET8: return classFor(sylsif_unsupported_object_t);
    case SYLSIF_SPECIAL_VTABLE_RELA_RELATIVE_SIGNED_OFFSET16: return classFor(sylsif_unsupported_object_t);
    case SYLSIF_SPECIAL_VTABLE_RELA_RELATIVE_SIGNED_OFFSET32: return classFor(sylsif_unsupported_object_t);
    case SYLSIF_SPECIAL_VTABLE_RELA_RELATIVE_SIGNED_OFFSET64: return classFor(sylsif_unsupported_object_t);

    case SYLSIF_SPECIAL_VTABLE_RELA_RELATIVE_SIGNED_OFFSET32_AT_GOT: return classFor(sylsif_unsupported_object_t);
    case SYLSIF_SPECIAL_VTABLE_RELA_RELATIVE_SIGNED_OFFSET32_GOT_OFFSET: return classFor(sylsif_unsupported_object_t);
    case SYLSIF_SPECIAL_VTABLE_RELA_RELATIVE_SIGNED_OFFSET32_GLOBAL_OFFSET_TABLE: return classFor(sylsif_unsupported_object_t);
    case SYLSIF_SPECIAL_VTABLE_RELA_RELATIVE_BRANCH_32: return classFor(sylsif_unsupported_object_t);
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
        (1 + numberOfSections) * sizeof(sylsif64_section_descriptor_t),
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

static void freeLoadedImage(sylsif_loaded_image_metadata_t *loadedImage)
{
    if(!loadedImage)
        return;

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
    uintptr_t filePointer = *pointer;
    if(filePointer == 0)
        return 1;

    // TODO: Use a lower bound binary search here
    for(uint32_t i = 0; i < image->numberOfSections; ++i)
    {
        sylsif_section_descriptor_t *section = &image->sectionDescriptors[i];
        if(section->memoryLoadingAddress == 0)
            continue;

        if(section->fileOffset <= filePointer && filePointer <= section->fileOffset + section->memorySize)
        {
            *pointer = filePointer - section->fileOffset + section->memoryLoadingAddress;
            return 1;
        }
    }

    fprintf(stderr, "Cannot convert file pointer %p\n", (void*)filePointer);

    return 0;
}

static int convertImageObjectFilePointers(sylsif_loaded_image_metadata_t *image, sylsif_object_header_t *object)
{
    if(!object)
        return 1;

    /* Get the loading object class. */
    sylsif_loading_class_t *class = getLoadingObjectClass(object);
    uint8_t *basePointer = (uint8_t*)object;

    for(size_t i = 0; i < class->filePointerMemberCount; ++i)
    {
        uintptr_t *memberPointer = (uintptr_t*)(basePointer + class->filePointerMembers[i]);
        if(!mapImageFilePointerToMemoryPointer(image, memberPointer))
            return 0;
    }

    return 1;
}
static int convertImageFilePointers(sylsif_loaded_image_metadata_t *image)
{
    for(uint32_t i = 0; i <= image->numberOfSections; ++i)
    {
        sylsif64_section_descriptor_t *section = &image->sectionDescriptors[i];

        /* Convert the section object descriptor file pointer. */
        if(!convertImageObjectFilePointers(image, &section->objectHeader))
            return 0;

        /* Convert the content of some sections. */
        if(section->memoryFlags & SYLSIF_SECTION_MEMORY_FLAGS_OBJECTS_WITH_FILE_POINTERS)
        {
            printf("TODO: convert content of section %d: [%zu]%p\n", i, section->memorySize, (void*)section->memoryLoadingAddress);
        }
    }

    /* Convert the global symbol table address. */
    mapImageFilePointerToMemoryPointer(image, (uintptr_t*)&image->globalSymbolTable);

    /* Convert the entry point object address. */
    mapImageFilePointerToMemoryPointer(image, (uintptr_t*)&image->entryPointObject);

    return 1;
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

    /* Convert the file pointers. */
    if(!convertImageFilePointers(imageMetadata))
    {
        freeLoadedImage(imageMetadata);
        return 1;
    }

    /* TODO: Apply the relocation. */

    /* TODO: Apply the permissions required to the sections. */

    printf("Image loading succeded.\n");
    return 0;

}
