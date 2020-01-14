#ifndef __TECHRTOS_H__
#define __TECHRTOS_H__

#include "TimerSys.h"
#include "assert.h"

typedef struct context
{
    volatile void *stack_ptr;
    volatile void *top_of_stack;
    unsigned stack_size;
    void (*func)(void *);
    void *params;
    uint32 ticks;
} context;

typedef struct context *pcontext_t;

#define yield_until(s) \
    {                  \
        while (s)      \
            yield();   \
    }

void yield();
void tech_init();
void tech_drop();
void tech_run();
pcontext_t tech_cxt(void (*)(void *), void *, unsigned);
void tech_cxt_destroy(pcontext_t);
void tech_set_cxt(pcontext_t);
void tech_cxtof_hook(void (*)(pcontext_t));

#endif /* __TECHRTOS_H__ */