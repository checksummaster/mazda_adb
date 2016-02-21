#include <stdio.h>
#include <string.h>
#include <unistd.h>
//#define VERBOSE



const char *adbversion()
{
    static char version[100];
    version[0] = '\0';
    FILE *handle = popen("adb version 2>&1", "r");

    if (handle == NULL)
    {
        return 0;
    }
    char buf[64];
    size_t readn;
    int ret = 1;
    while ((readn = fread(buf, 1, sizeof(buf), handle)) > 0)
    {
        buf[readn] = '\0';
        if ( version[0] == '\0')
        {
            strcpy(version, buf);
            if ( version[0]) version[strlen(version)-1] =  '\0';
           // printf ("%s", version);
        }
#ifdef VERBOSE
        printf("%s\n", buf);
#endif
    }
    pclose(handle);

    

    return version;
}

// 0 = no device
// 1 = device without redirection
// 2 = device with redirection
int checkconnect()
{
    FILE *handle = popen("adb reverse --list 2>&1", "r");

    if (handle == NULL)
    {
        return 0;
    }
    char buf[64];
    size_t readn;
    int ret = 1;
    while ((readn = fread(buf, 1, sizeof(buf), handle)) > 0)
    {
        buf[readn] = '\0';
        if (strstr(buf, "tcp:2222 tcp:22") != NULL)
        {
            ret = 2;
        } 
        if (strstr(buf, "device not found") != NULL)
        {
            ret = 0;
        } /*else {
            ret = 2;
        } */


#ifdef VERBOSE
        printf("%s\n", buf);
#endif
    }
    pclose(handle);

    return ret;
}

int redirect(const char *command)
{
    char commandline[1024];
    if ( command ) {
        sprintf (commandline,"adb %s",command);
    } 
    printf ("Start : %s\n",commandline);

    FILE *handle = popen(commandline, "r");

    if (handle == NULL)
    {
        return 0;
    }
    char buf[64];
    size_t readn;
    while ((readn = fread(buf, 1, sizeof(buf), handle)) > 0)
    {
        buf[readn] = '\0';
#ifdef VERBOSE
        printf("%s\n", buf);
#endif
    }
    pclose(handle);

    return 0;
}

int wait()
{
    FILE *handle = popen("adb wait-for-device 2>&1", "r");

    if (handle == NULL)
    {
        return 0;
    }
    char buf[64];
    size_t readn;
    int ret = 1;
    while ((readn = fread(buf, 1, sizeof(buf), handle)) > 0)
    {
        buf[readn] = '\0';

        if (strstr(buf, "not found") != NULL)
        {
            ret = 0;
        }
#ifdef VERBOSE
        printf("%s\n", buf);
#endif
    }
    pclose(handle);

    return ret;
}


int main(int narg, char *arg[])
{
    const char *command = NULL;
    if ( narg > 1 && !strcmp(arg[1], "-v") )
    {
        printf("version 1.1\n");
        return 0;
    } else if ( narg > 1 ) {
        command = arg[1];
    }
    int v2 = -1;

    const char *ver = adbversion();
    if ( strstr(ver,"1.0.32")  == NULL ) {
        printf("adb wrong version (%s)\n",ver);
        return -1;
    }

    while(true)
    {

        int v = 0;
        int i;

        while ( v != 2 )
        {
            v = checkconnect();
            switch (v)
            {
            case 0:
                if ( v2 != v ) printf("no device\n");
                wait();
                break;
            case 1:
                if ( v2 != v ) printf("device without redirection\n");
                redirect("reverse tcp:2222 tcp:22");
                for (i = 1 ; i < narg; i ++) redirect(arg[i]);
                break;
            case 2:
                if ( v2 != v ) printf("device with redirection\n");
                break;

            }
            v2 = v;
        }
        sleep(10);
    }
    return 0;
}
