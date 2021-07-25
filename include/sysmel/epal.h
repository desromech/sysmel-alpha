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

typedef struct SysmelChar8ConstArraySlice_s
{
    const char **elements;
    size_t size;
} SysmelChar8ConstArraySlice;

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

/* Sysmel filesystem */
SYSMEL_EPAL_EXPORT bool sysmel_epal_path_exists(const char *path);
SYSMEL_EPAL_EXPORT bool sysmel_epal_path_isFile(const char *path);
SYSMEL_EPAL_EXPORT bool sysmel_epal_path_isDirectory(const char *path);
SYSMEL_EPAL_EXPORT const char * sysmel_epal_path_getWorkingDirectory();
SYSMEL_EPAL_EXPORT const char * sysmel_epal_path_getResourcesDirectory();

/* Threads */
typedef uint32_t sysmel_epal_mutex_t[4];
typedef uint32_t sysmel_epal_condition_t[4];
typedef uint32_t sysmel_epal_thread_t[4];
typedef intptr_t (*sysmel_epal_thread_entry_point_t) (void *arg);

SYSMEL_EPAL_EXPORT void sysmel_epal_mutex_initialize(sysmel_epal_mutex_t *mutex);
SYSMEL_EPAL_EXPORT void sysmel_epal_mutex_finalize(sysmel_epal_mutex_t *mutex);
SYSMEL_EPAL_EXPORT void sysmel_epal_mutex_lock(sysmel_epal_mutex_t *mutex);
SYSMEL_EPAL_EXPORT void sysmel_epal_mutex_unlock(sysmel_epal_mutex_t *mutex);

SYSMEL_EPAL_EXPORT void sysmel_epal_condition_initialize(sysmel_epal_condition_t *condition);
SYSMEL_EPAL_EXPORT void sysmel_epal_condition_finalize(sysmel_epal_condition_t *condition);
SYSMEL_EPAL_EXPORT void sysmel_epal_condition_wait(sysmel_epal_condition_t *condition, sysmel_epal_mutex_t *mutex);
SYSMEL_EPAL_EXPORT void sysmel_epal_condition_signalOne(sysmel_epal_condition_t *condition);
SYSMEL_EPAL_EXPORT void sysmel_epal_condition_signalAll(sysmel_epal_condition_t *condition);

SYSMEL_EPAL_EXPORT int sysmel_epal_thread_create(sysmel_epal_thread_t *thread, int processorIndex, sysmel_epal_thread_entry_point_t entryPoint, void *argument);
SYSMEL_EPAL_EXPORT int sysmel_epal_thread_join(sysmel_epal_thread_t *thread);
SYSMEL_EPAL_EXPORT int sysmel_epal_thread_detach(sysmel_epal_thread_t *thread);

SYSMEL_EPAL_EXPORT uint32_t sysmel_epal_thread_getAvailableProcessorCount();

SYSMEL_EPAL_EXPORT void** sysmel_epal_tls_lastExceptionContext();

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
SYSMEL_EPAL_EXPORT int sysmel_main(SysmelChar8ConstArraySlice *argList);

#endif /* SYSMEL_EPAL_H */
