#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <dlfcn.h>

static FILE * (*next_fopen)(const char *path, const char *mode);
FILE * fopen (const char *path, const char *mode)
{
    char *msg;
    char *newpath = (char *)path;
    FILE *ret = NULL;
    int hackedPath = 0;

    if (next_fopen == NULL)
    {
        next_fopen = dlsym (RTLD_NEXT, "fopen");
        if ((msg = dlerror ()) != NULL)
        {
            printf ("open dlopen failed : %s\n", msg);
            return NULL;
        }
    }

    /* Modifying path */
    if (!strncmp ("/etc/turboprint", path, 14)
        || !strncmp ("/usr/share/turboprint", path, 20)
        || !strncmp ("/var/log/turboprint", path, 19)
        || !strncmp ("/etc/cups/lpoptions", path, 19))
    {
        newpath = (char *)malloc (strlen (getenv ("RBR")) + strlen (path) + 1);
        newpath = strcpy (newpath, getenv ("RBR"));
        newpath = strcat (newpath, path);
        //printf ("using hacked path %s for fopen\n", newpath);
        hackedPath = 1;
    }

    ret = next_fopen (newpath, mode);
    if (hackedPath)
        free (newpath);
    return ret;
}

static int (*next_unlink)(const char *path);
int unlink (const char *path)
{
    char *msg;
    char *newpath = (char *)path;
    int ret = 0;
    int hackedPath = 0;

    if (next_unlink == NULL)
    {
        next_unlink = dlsym (RTLD_NEXT, "unlink");
        if ((msg = dlerror ()) != NULL)
        {
            printf ("open dlopen failed : %s\n", msg);
            return -1;
        }
    }

    /* Modifying path */
    if (!strncmp ("/etc/turboprint/tp_testfile.tst", path, 29))
    {
        newpath = (char *)malloc (strlen (getenv ("RBR")) + strlen (path) + 1);
        newpath = strcpy (newpath, getenv ("RBR"));
        newpath = strcat (newpath, path);
        //printf ("using hacked path %s for unlink\n", newpath);
        hackedPath = 1;
    }

    ret = next_unlink (newpath);
    if (hackedPath)
        free (newpath);
    return ret;
}
