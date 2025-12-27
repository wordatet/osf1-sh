#ifndef OSF_SH_SHIMS_H
#define OSF_SH_SHIMS_H

#include <sys/types.h>
#include <stdint.h>
#include <unistd.h>
#include <limits.h>
#include <nl_types.h>
#include <string.h>
#include <time.h>
#include <wctype.h>
#include <signal.h>
#include <sys/wait.h>
#include <stdlib.h>
#include <stddef.h>
#include <fcntl.h>
#include <stdio.h>

typedef unsigned char uchar_t;
typedef unsigned long ulong;
typedef unsigned char uchar;

#ifndef NOFILE_IN_U
#define NOFILE_IN_U 64
#endif

#ifndef MBMAX
#define MBMAX 4
#endif

#ifndef MBCDMAX
#define MBCDMAX 0xffffffff
#endif

#ifndef BOOL
#define BOOL int
#endif

#ifndef TRUE
#define TRUE 1
#endif

#ifndef FALSE
#define FALSE 0
#endif

#ifndef NSIG
#define NSIG 64
#endif

#ifndef SIGMAX
#define SIGMAX (NSIG-1)
#endif

#ifndef UBSIZE
#define UBSIZE 512
#endif

#ifndef MAX
#define MAX(a,b) ((a)>(b)?(a):(b))
#endif

/* NL_TEXTMAX - maximum message size for NLS. OSF/1 used 8192.
 * Linux defines this as INT_MAX (2GB!) which causes stack overflow.
 * Force a reasonable value. */
#undef NL_TEXTMAX
#define NL_TEXTMAX 8192

/* Loader shims - defined as functions so prototypes don't conflict */
static inline int sh_ldr_install(uchar_t *a) { return 0; }
static inline int sh_ldr_remove(uchar_t *a) { return 0; }

#define ldr_install sh_ldr_install
#define ldr_remove sh_ldr_remove

#ifndef CLK_TCK
#define CLK_TCK sysconf(_SC_CLK_TCK)
#endif

/* Ldup is implemented in main.c - don't define as macro */

#ifndef MF_SH
#define MF_SH "sh.cat"
#endif

#endif /* OSF_SH_SHIMS_H */
