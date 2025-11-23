#include "types.h"
#include "defs.h"


void * memset(void *dst, int c, uint n) {
    char *cdst = (char *) dst;
    int i;
    for(i = 0; i < n; i++){
        cdst[i] = c;
    }
    return dst;
}

void memmove(void *dst, const void *src, uint n) {
    char *cdst = (char *) dst;
    const char *csrc = (const char *) src;
    int i;
    if(cdst < csrc){
        for(i = 0; i < n; i++)
          cdst[i] = csrc[i];
    } else {
        for(i = n-1; i >= 0; i--)
          cdst[i] = csrc[i];
    }
}

// copy string safely with size limit
char * safestrcpy(char *dst, const char *src, int n) {
    if(n <= 0) return dst;
    int i;
    for(i=0; i < n-1 && src[i]; i++) {
        dst[i] = src[i];
    }
    dst[i] = '\0';
    return dst;
}