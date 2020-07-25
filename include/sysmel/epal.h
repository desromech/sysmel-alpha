#ifndef SYSMEL_EPAL_H
#define SYSMEL_EPAL_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#ifdef __cplusplus
#define SYSMEL_EPAL_EXPORT extern "C"
#else
#define SYSMEL_EPAL_EXPORT
#endif

typedef struct SysmelArgList_s
{
    const char *elements;
    size_t size;
} SysmelArgList;

/* Sysmel IO interface. */

#define SYSMEL_EPAL_O_RDONLY 0x00000000
#define SYSMEL_EPAL_O_WRONLY 0x00000001
#define SYSMEL_EPAL_O_RDWR 0x00000002
#define SYSMEL_EPAL_O_CREAT 0x00000040
#define SYSMEL_EPAL_O_TRUNC 0x00000200
#define SYSMEL_EPAL_O_APPEND 0x00000400

#define SYSMEL_EPAL_SEEK_SET 0
#define SYSMEL_EPAL_SEEK_CUR 1
#define SYSMEL_EPAL_SEEK_END 2

#define SYSMEL_EPAL_STDIN_FILENO 0
#define SYSMEL_EPAL_STDOUT_FILENO 1
#define SYSMEL_EPAL_STDERR_FILENO 2

SYSMEL_EPAL_EXPORT int sysmel_epal_close(int fd);
SYSMEL_EPAL_EXPORT int64_t sysmel_epal_lseek64(int fd, int64_t offset, int whence);
SYSMEL_EPAL_EXPORT int sysmel_epal_isatty(int fd);
SYSMEL_EPAL_EXPORT int sysmel_epal_open(const char *path, int flags, int creationPermissions);
SYSMEL_EPAL_EXPORT intptr_t sysmel_epal_read(int fd, void *buffer, size_t count);
SYSMEL_EPAL_EXPORT intptr_t sysmel_epal_write(int fd, const void *buffer, size_t count);

/* Sysmel native virtual memory interface. */
SYSMEL_EPAL_EXPORT void* sysmel_epal_reserveAndCommitAddressSpaceWithAlignment(size_t size, size_t alignment);
SYSMEL_EPAL_EXPORT void* sysmel_epal_reserveAndCommitAddressSpace(size_t size);
SYSMEL_EPAL_EXPORT void* sysmel_epal_reserveAddressSpace(size_t size);
SYSMEL_EPAL_EXPORT bool sysmel_epal_commitAddressSpace(void* addressSpace, size_t offset, size_t size);
SYSMEL_EPAL_EXPORT bool sysmel_epal_releaseAddressSpace(void* addressSpace, size_t offset, size_t size);
SYSMEL_EPAL_EXPORT bool sysmel_epal_freeAddressSpace(void* addressSpace, size_t size);

/* Sysmel time interface */
typedef int64_t sysmel_epal_ticks_t;
#define SYSMEL_TICKS_PER_MICROSECOND 1
#define SYSMEL_TICKS_PER_MILLISECOND (SYSMEL_TICKS_PER_MICROSECOND*1000)
#define SYSMEL_TICKS_PER_SECOND (SYSMEL_TICKS_PER_MILLISECOND*1000)

SYSMEL_EPAL_EXPORT sysmel_epal_ticks_t sysmel_epal_microsecondClockValue();
SYSMEL_EPAL_EXPORT sysmel_epal_ticks_t sysmel_epal_monotonicClockValue();
SYSMEL_EPAL_EXPORT sysmel_epal_ticks_t sysmel_epal_processClockValue();
SYSMEL_EPAL_EXPORT sysmel_epal_ticks_t sysmel_epal_threadClockValue();
SYSMEL_EPAL_EXPORT void sysmel_epal_sleepFor(sysmel_epal_ticks_t time);
SYSMEL_EPAL_EXPORT void sysmel_epal_sleepUntil(sysmel_epal_ticks_t time);

/* Sysmel main program entry point. */
SYSMEL_EPAL_EXPORT int sysmel_main(SysmelArgList argList);

#endif /* SYSMEL_EPAL_H */
