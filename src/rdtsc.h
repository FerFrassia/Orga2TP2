/* ************************************************************************* */
/* Organizacion del Computador II                                            */
/*                                                                           */
/*   Funciones para obtener el Time Stamp Counter                            */
/*                                                                           */
/* ************************************************************************* */

#ifndef __RDTSC_H__
#define __RDTSC_H__

// uso: 
// unsigned long start, end;
// RDTSC_START(start);
// ... codigo ...
// RDTSC_STOP(end);
// unsigned long delta = end - start;

#define RDTSC(var)                                   \
{                                                    \
    __asm__ __volatile__ (                           \
        "xor %%rdx, %%rdx\n\t"                       \
        "xor %%rax, %%rax\n\t"                       \
        "lfence\n\t"                                 \
        "rdtsc\n\t"                                  \
        "sal $32, %%rdx\n\t"                         \
        "or %%rdx, %%rax\n\t"                        \
        "movq %%rax, %0\n\t"                         \
        : "=r" (var)                                 \
        : /* no input */                             \
        : "%rax", "%rdx"                             \
    );                                               \
}


#define RDTSC_START(start)                           \
{                                                    \
    /* warm up ... */                                \
    RDTSC(start);                                    \
    RDTSC(start);                                    \
    RDTSC(start);                                    \
}

#define RDTSC_STOP(end)                              \
{                                                    \
    RDTSC(end);                                      \
}

#endif /* !__RDTSC_H__ */
