#include <dirent.h>

const char *sysmelUnix_dirent64_d_name(struct dirent *entry)
{
    return entry->d_name;
}
