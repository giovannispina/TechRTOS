#ifndef __ASSERT_H__
#define __ASSERT_H__

#include "memory.h"

#define disableInt() INTCON.GIEH = 0;
#define enableInt() INTCON.GIEH = 1;

#define sleep() { asm SLEEP; }
#define reset() { STKPTR = 0; tech_freeAll(); asm goto 0x0; }
#define assert(a) { if (!a) {disableInt(); sleep(); reset();} }

#endif /* __ASSERT_H__ */