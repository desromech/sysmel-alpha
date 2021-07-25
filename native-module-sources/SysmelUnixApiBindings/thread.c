#define _GNU_SOURCE

#include <stdint.h>
#include <unistd.h>
#include <pthread.h>


#if defined(__linux__)
#include <sched.h>

int sysmelUnix_thread_setThreadAffinityToProcessor(pthread_t thread, uint32_t targetCore)
{
    cpu_set_t set;
    CPU_ZERO(&set);
    CPU_SET(targetCore, &set);
    if(!CPU_ISSET(targetCore, &set))
        return 0;

    return pthread_setaffinity_np(thread, sizeof(set), &set) == 0;
}

#else
int sysmelUnix_thread_setThreadAffinityToProcessor(pthread_t thread, uint32_t targetCore)
{
    (void)thread;
    (void)targetCore;
    return 0;
}
#endif

#if defined(__linux__) || defined(__APPLE__)

uint32_t sysmelUnix_thread_getAvailableProcessorCount()
{
    return (uint32_t)sysconf(_SC_NPROCESSORS_ONLN);
}

#else

uint32_t sysmelUnix_thread_getAvailableProcessorCount()
{
    return 1;
}

#endif
