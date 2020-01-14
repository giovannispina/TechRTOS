#line 1 "X:/TechRTOS/TimerSys.c"
#line 1 "x:/techrtos/timersys.h"
#line 1 "x:/techrtos/types.h"
#line 1 "x:/techrtos/timelib.h"
#line 30 "x:/techrtos/timelib.h"
typedef struct
 {
 unsigned char ss ;
 unsigned char mn ;
 unsigned char hh ;
 unsigned char md ;
 unsigned char wd ;
 unsigned char mo ;
 unsigned int yy ;
 } TimeStruct ;
#line 44 "x:/techrtos/timelib.h"
extern long Time_jd1970 ;
#line 49 "x:/techrtos/timelib.h"
long Time_dateToEpoch(TimeStruct *ts) ;
void Time_epochToDate(long e, TimeStruct *ts) ;
#line 32 "x:/techrtos/timersys.h"
typedef struct timeval
{
  signed long  tv_sec;
  signed long  tv_usec;
} timeval_t;

typedef TimeStruct time_t;

void tech_timerSysInit();
void tech_setInc( unsigned long );
void tech_timer();
 unsigned char  tech_isLeapYear( unsigned int );
void tech_gettimeofday(timeval_t*);
 unsigned long  tech_getTicks();
 unsigned long  tech_time(time_t*);
 unsigned char  tech_weekday();
const char* tech_getMonth( unsigned char );
void tech_setTime(time_t*);
#line 30 "X:/TechRTOS/TimerSys.c"
enum Month
{
 January,
 February,
 March,
 April,
 May,
 June,
 July,
 August,
 September,
 October,
 November,
 December
};

enum Day
{
 Monday,
 Tuesday,
 Wednesday,
 Thursday,
 Friday,
 Saturday,
 Sunday
};

timeval_t start;
time_t tm_current;

 unsigned long  elapsed;
 unsigned long  incTime;
bit leapyear;

void tech_timerSysInit()
{
 elapsed = incTime = 0;
 leapyear = 0;
 memset(&tm_current, 0, sizeof(time_t));
 tech_gettimeofday(&start);
}

void tech_setInc( unsigned long  inc)
{
 incTime = inc;
}

void tech_incTime()
{
 tm_current.ss -= 60;
 tm_current.mn++;

 if (tm_current.mn >= 60)
 {
 tm_current.mn -= 60;
 tm_current.hh++;
 }

 if (tm_current.hh >= 24)
 {
 tm_current.hh -= 24;
 tm_current.md++;

 if (tm_current.wd >= 6)
 tm_current.wd = 0;
 else tm_current.wd++;

 switch (tm_current.mo)
 {
 case October:
 if (tm_current.md >= 24)
 {
 if (tm_current.wd = 6 && tm_current.hh == 3)
 tm_current.hh--;
 if (tm_current.md >= 31)
 {
 tm_current.mo++;
 tm_current.md -= 31;
 }
 }
 break;
 case March:
 if (tm_current.md >= 24)
 {
 if (tm_current.wd = 5 && tm_current.hh == 2)
 tm_current.hh++;
 if (tm_current.md >= 31)
 {
 tm_current.mo++;
 tm_current.md -= 31;
 }
 }
 break;
 case April:
 case June:
 case September:
 case November:
 if (tm_current.md >= 30)
 {
 tm_current.mo++;
 tm_current.md -= 30;
 }
 break;
 case February:
 if (leapyear)
 {
 if (tm_current.md >= 29)
 {
 tm_current.mo++;
 tm_current.md -= 29;
 }
 } else if (tm_current.md >= 28)
 {
 tm_current.mo++;
 tm_current.md -= 28;
 }
 break;
 default:
 if (tm_current.md >= 31)
 {
 tm_current.mo++;
 tm_current.md -= 31;
 }
 break;
 case December:
 if (tm_current.md >= 31)
 {
 tm_current.yy++;
 tm_current.md -= 30;
 tm_current.mo = 0;

 if (tech_isLeapYear(tm_current.yy))
 leapyear = 1;
 else leapyear = 0;
 }
 break;
 }
 }
}

void tech_timer()
{
 elapsed += incTime;

 if (elapsed <  1000000 )
 return;

 elapsed -=  1000000 ;
 tm_current.ss++;

 while (tm_current.ss >= 60)
 tech_incTime();
}

 unsigned char  tech_isLeapYear( unsigned int  yy)
{
 if (yy % 100 == 0)
 if (yy % 400 == 0)
 return  1 ;
 else if (yy % 4 == 0)
 return  1 ;

 return  0 ;
}

void tech_gettimeofday(timeval_t *tv)
{
  signed long  epoch = Time_dateToEpoch(&tm_current);
 tv->tv_sec = epoch;
 tv->tv_usec = elapsed;
}

 unsigned long  tech_getTicks()
{
 timeval_t ret;
  unsigned long  ticks;
 tech_gettimeofday(&ret);
 ticks = (ret.tv_sec - start.tv_sec) * 1000;
 ticks += (ret.tv_usec - start.tv_usec) / 1000;
 return ticks;
}

 unsigned long  tech_time(time_t *t)
{
  signed long  epoch;
 time_t ts;

 if (t)
 memcpy(&ts, t, sizeof(time_t));
 else memcpy(&ts, &tm_current, sizeof(time_t));

 epoch = Time_dateToEpoch(&ts);

 return epoch;
}

 unsigned char  tech_weekday()
{

 const int t[] = { 0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4 };
  unsigned int  y;
  unsigned char  m;
 y = tm_current.yy;
 m = tm_current.mo;
 y -= m < 3;
 return (y + y/4 - y/100 + y/400 + t[m-1] + tm_current.wd) % 7;
}

const char *tech_getMonth( unsigned char  month)
{
 const char __MONTHS[][12] =
 {
 {"January"},
 {"February"},
 {"March"},
 {"April"},
 {"May"},
 {"June"},
 {"July"},
 {"August"},
 {"September"},
 {"October"},
 {"November"},
 {"December"}
 };

 if (month >= 12) return  0 ;

 return __MONTHS[month];
}

void tech_setTime(time_t *time)
{
 memcpy(&tm_current, time, sizeof(time_t));
}
