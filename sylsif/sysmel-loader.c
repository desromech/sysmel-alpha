#include "sylsif.h"
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/mman.h>
#include <malloc.h>

static size_t alignSizeTo(size_t size, size_t alignment);
static size_t sizeOfImageMetadataSectionFor(size_t numberOfSections);
static sylsif_loaded_image_metadata_t *allocateLoadedImage(size_t numberOfSections);
static void freeLoadedImage(sylsif_loaded_image_metadata_t *loadedImage);
static int loadImageSectionFrom(sylsif_section_descriptor_t *sectionDescriptor, FILE *file);
static void freeImageSection(sylsif_section_descriptor_t *sectionDescriptor);

/* Fake VTable for objects required by the loader. */
typedef struct sylsif_loading_vtable_s
{
    void (*convertFilePointers) (sylsif_object_header_t *self);
} sylsif_loading_vtable_t;


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

    /* TODO: Convert file pointers, into direct pointers. */

    /* TODO: Apply the relocation. */

    /* TODO: Apply the permissions required to the sections. */

    printf("Image loading succeded\n.");
    return 0;

}
