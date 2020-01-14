#ifndef __TIMERSYS_H__
#define __TIMERSYS_H__

#include "Types.h"
#include "timelib.h"

typedef struct timeval
{
    int32 tv_sec;
    int32 tv_usec;
} timeval_t;

typedef TimeStruct time_t;

void tech_timerSysInit();
void tech_setInc(uint32);
void tech_timer();
bool tech_isLeapYear(uint16);
void tech_gettimeofday(timeval_t *);
uint32 tech_getTicks();
uint32 tech_time(time_t *);
uint8 tech_weekday();
const char *tech_getMonth(uint8);
void tech_setTime(time_t *);

#endif /* __TIMERSYS_H__ */