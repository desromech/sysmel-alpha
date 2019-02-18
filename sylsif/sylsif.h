#ifndef SYLSIF_H_
#define SYLSIF_H_

#include <limits.h>
#include <stdint.h>

/**
 * Detect the pointer size of the current platform.
 */
#if UINTPTR_MAX <= UINT32_MAX
#   define SYLSIF_CURRENT_PLATFORM_32_BITS 1
#elif UINTPTR_MAX <= UINT64_MAX
#   define SYLSIF_CURRENT_PLATFORM_64_BITS 1
#else
#   error Unsupported pointer size
#endif

#define SYLSIF_SIGNATURE_MAGIC "SYIF"

#define SYLSIF_PLATFORM_NONE "none"
#define SYLSIF_PLATFORM_WIN32 "ws32"
#define SYLSIF_PLATFORM_LINUX "lnux"
#define SYLSIF_PLATFORM_MAC_OSX "mosx"

#define SYLSIF_VERSION "0000"

typedef enum sylsif_section_memory_flags_e
{
    SYLSIF_SECTION_MEMORY_FLAGS_READABLE = 1<<0, /* Can the section be readed? */
    SYLSIF_SECTION_MEMORY_FLAGS_WRITEABLE = 1<<1, /* Can the section be written? */
    SYLSIF_SECTION_MEMORY_FLAGS_EXECUTABLE = 1<<2, /* Can the section be executed? */

    SYLSIF_SECTION_MEMORY_FLAGS_LOADED = 1<<3, /* Is the section loaded from disk? */
    SYLSIF_SECTION_MEMORY_FLAGS_DEBUGGING = 1<<4, /*Is the section used for debugging? */
    SYLSIF_SECTION_MEMORY_FLAGS_OBJECTS_WITH_FILE_POINTERS = 1<<5, /*This section holds object with file offset based pointers*/
} sylsif_section_memory_flags_t;

typedef enum sylsif_special_vtable_e
{
    SYLSIF_SPECIAL_VTABLE_ARRAY = -1,
    SYLSIF_SPECIAL_VTABLE_SYMBOL = -2,
    SYLSIF_SPECIAL_VTABLE_STRING = -3,

    SYLSIF_SPECIAL_VTABLE_SECTION_DESCRIPTOR = -4,
    SYLSIF_SPECIAL_VTABLE_SYMBOL_TABLE = -5,
    SYLSIF_SPECIAL_VTABLE_SYMBOL_TABLE_ENTRY = -6,
    SYLSIF_SPECIAL_VTABLE_IMAGE_METADATA = -7,

    SYLSIF_SPECIAL_VTABLE_RELA_ABSOLUTE_OFFSET8 = -100,
    SYLSIF_SPECIAL_VTABLE_RELA_ABSOLUTE_OFFSET16 = -101,
    SYLSIF_SPECIAL_VTABLE_RELA_ABSOLUTE_OFFSET32 = -102,
    SYLSIF_SPECIAL_VTABLE_RELA_ABSOLUTE_SIGNED_OFFSET32 = -103,
    SYLSIF_SPECIAL_VTABLE_RELA_ABSOLUTE_OFFSET64 = -104,

    SYLSIF_SPECIAL_VTABLE_RELA_SECTION_RELATIVE_OFFSET32 = -105,
    SYLSIF_SPECIAL_VTABLE_RELA_SECTION_RELATIVE_OFFSET64 = -106,

    SYLSIF_SPECIAL_VTABLE_RELA_RELATIVE_SIGNED_OFFSET8 = -107,
    SYLSIF_SPECIAL_VTABLE_RELA_RELATIVE_SIGNED_OFFSET16 = -108,
    SYLSIF_SPECIAL_VTABLE_RELA_RELATIVE_SIGNED_OFFSET32 = -109,
    SYLSIF_SPECIAL_VTABLE_RELA_RELATIVE_SIGNED_OFFSET64 = -110,

    SYLSIF_SPECIAL_VTABLE_RELA_RELATIVE_SIGNED_OFFSET32_AT_GOT = -111,
    SYLSIF_SPECIAL_VTABLE_RELA_RELATIVE_SIGNED_OFFSET32_GOT_OFFSET = -112,
    SYLSIF_SPECIAL_VTABLE_RELA_RELATIVE_SIGNED_OFFSET32_GLOBAL_OFFSET_TABLE = -113,
    SYLSIF_SPECIAL_VTABLE_RELA_RELATIVE_BRANCH_32 = -114,
} sylsif_special_vtable_t;

/**
 * SYsmel Loadable and Storable Image File
 * This is an executable file format designed for Sysmel images, that
 * can have full disk persistence of managed data and executable code.
 */
typedef struct sylsif_header_s
{
    /**
     * The signature is a 16 bytes ASCII string that identifies the image file,
     * the pointer size, the endianess, the platform, and the platform variant.
     */
    struct
    {
        uint8_t magic[4]; /* SYIF */
        uint8_t pointerSize[2]; /* '32' or '64' */
        uint8_t endianness[2]; /* 'LE' or 'BE' */
        uint8_t platform[4];
        uint8_t version[4];
    } signature;

    uint64_t globalSymbolTable;
    uint64_t entryPointObject;
    uint32_t numberOfSections;
    uint32_t reserved;
} sylsif_header_t;

/**
* SYLSIF64 Object header.
* This is the same as the Sysmel definition for: Smalltalk ProtoObject
 */
typedef struct sylsif32_object_header_s
{
    uint32_t vtable;
    uint32_t padding;
    uint32_t objectAttributes;
    uint32_t variableDataSize;
} sylsif32_object_header_t;

/**
 * SYLSIF32 Object header.
 * This is the same as the Sysmel definition for: Smalltalk ProtoObject
 */
typedef struct sylsif64_object_header_t
{
    uint64_t vtable;
    uint32_t objectAttributes;
    uint32_t variableDataSize;
} sylsif64_object_header_t;

/**
 * SYLSIF32 Section Descriptor
 */
typedef struct sylsif32_section_descriptor_s
{
    sylsif32_object_header_t objectHeader;

    uint32_t nameSymbol;
    uint32_t relocations; /* Array of relocations. */

    uint32_t fileOffset;
    uint32_t fileSize;
    uint32_t fileBaseAddress;

    uint32_t memoryLoadingAddress;
    uint32_t memorySize;
    uint32_t memoryAlignment;
    uint32_t memoryFlags;
} sylsif32_section_descriptor_t;

/**
 * SYLSIF64 Section Descriptor
 */
typedef struct sylsif64_section_descriptor_s
{
    sylsif64_object_header_t objectHeader;

    uint64_t nameSymbol;
    uint64_t relocations; /* Array of relocations. */

    uint64_t fileOffset;
    uint64_t fileSize;
    uint64_t fileBaseAddress;

    uint64_t memoryLoadingAddress;
    uint64_t memorySize;
    uint64_t memoryAlignment;
    uint64_t memoryFlags;
} sylsif64_section_descriptor_t;

/**
 * SYLSIF32 Symbol Table
 */
typedef struct sylsif32_symbol_table_s
{
    sylsif32_object_header_t objectHeader;

    uint32_t symbols; /* Pointer to array of symbol table entry */
} sylsif32_symbol_table_t;

/**
 * SYLSIF64 Symbol Table
 */
typedef struct sylsif64_symbol_table_s
{
    sylsif64_object_header_t objectHeader;

    uint64_t symbols; /* Pointer to array of symbol table entry */
} sylsif64_symbol_table_t;

/**
 * SYLSIF32 Symbol Table Entry
 */
typedef struct sylsif32_symbol_table_entry_s
{
    sylsif32_object_header_t objectHeader;

    uint32_t name; /* Pointer to symbol object. */
    uint32_t sectionDescriptor; /* Pointer to the section descriptor object. */
    uint32_t sectionOffset;
    uint32_t size; /* In memory value of the symbol. */
    uint32_t value; /* In memory value of the symbol. */

    uint32_t type;
    uint32_t flags;

} sylsif32_symbol_table_entry_t;

/**
 * SYLSIF64 Symbol Table Entry
 */
typedef struct sylsif64_symbol_table_entry_s
{
    sylsif64_object_header_t objectHeader;

    uint64_t name; /* Pointer to symbol object. */
    uint64_t sectionDescriptor; /* Pointer to the section descriptor object. */
    uint64_t sectionOffset;
    uint64_t size; /* The size of the symbol*/
    uint64_t value; /* In memory value of the symbol. */

    uint32_t type;
    uint32_t flags;
} sylsif64_symbol_table_entry_t;

/**
 * SYLSIF32 Relocation with addend type
 */
typedef struct sylsif32_relocation_with_addend_s
{
    sylsif64_object_header_t objectHeader;

    uint32_t section;
    uint32_t symbol;
    uint32_t sectionOffset;
    uint32_t addend;
} sylsif32_relocation_with_addend_t;

/**
 * SYLSIF32 Relocation with addend type
 */
typedef struct sylsif64_relocation_with_addend_s
{
    sylsif64_object_header_t objectHeader;

    uint64_t section;
    uint64_t symbol;
    uint64_t sectionOffset;
    uint64_t addend;
} sylsif64_relocation_with_addend_t;

/***
 * These are type definitions that are needed by the glue between the loader,
 * and the in image binary interface.
 */
#if defined(SYLSIF_CURRENT_PLATFORM_32_BITS)

typedef sylsif32_object_header_t sylsif_object_header_t;
typedef sylsif32_section_descriptor_t sylsif_section_descriptor_t;
typedef sylsif32_symbol_table_t sylsif_symbol_table_t;
typedef sylsif32_symbol_table_entry_t sylsif_symbol_table_entry_t;
typedef sylsif32_relocation_with_addend_t sylsif_relocation_with_addend_t;

#elif defined(SYLSIF_CURRENT_PLATFORM_64_BITS)

typedef sylsif64_object_header_t sylsif_object_header_t;
typedef sylsif64_section_descriptor_t sylsif_section_descriptor_t;
typedef sylsif64_symbol_table_t sylsif_symbol_table_t;
typedef sylsif64_symbol_table_entry_t sylsif_symbol_table_entry_t;
typedef sylsif64_relocation_with_addend_t sylsif_relocation_with_addend_t;

#endif

typedef struct sylsif_loaded_image_metadata_s
{
    sylsif_object_header_t objectHeader;

    uintptr_t numberOfSections;
    sylsif_section_descriptor_t *sectionDescriptors;
    sylsif_symbol_table_t *globalSymbolTable;
    sylsif_object_header_t *entryPointObject;
} sylsif_loaded_image_metadata_t;

#endif /* SYLSIF_H_ */
