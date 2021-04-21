#include <stdbool.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

bool sysmelUnix_stat_isFile(const char *filename, size_t filenameSize)
{
    char *cfilename = malloc(filenameSize + 1);
    memcpy(cfilename, filename, filenameSize);
    cfilename[filenameSize] = 0;

    struct stat s;
    int error = stat(cfilename, &s);
    free(cfilename);
    if(error < 0)
        return false;

    return S_ISREG(s.st_mode);
}

bool sysmelUnix_stat_isDirectory(const char *filename, size_t filenameSize)
{
    char *cfilename = malloc(filenameSize + 1);
    memcpy(cfilename, filename, filenameSize);
    cfilename[filenameSize] = 0;

    struct stat s;
    int error = stat(cfilename, &s);
    free(cfilename);
    if(error)
        return false;

    return S_ISDIR(s.st_mode);
}


bool sysmelUnix_stat_exists(const char *filename, size_t filenameSize)
{
    char *cfilename = malloc(filenameSize + 1);
    memcpy(cfilename, filename, filenameSize);
    cfilename[filenameSize] = 0;

    struct stat s;
    int error = stat(cfilename, &s);
    free(cfilename);
    return error == 0;
}
