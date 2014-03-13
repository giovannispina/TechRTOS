/* Copyright (c) 2014, Giovanni Spina <giovanni@codeforfun.it>
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*     * Redistributions of source code must retain the above copyright
*       notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above copyright
*       notice, this list of conditions and the following disclaimer in the
*       documentation and/or other materials provided with the distribution.
*     * Neither the name of the uploader nor the
*       names of its contributors may be used to endorse or promote products
*       derived from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY GIOVANNI SPINA ``AS IS'' AND ANY
* EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL GIOVANNI SPINA BE LIABLE FOR ANY
* DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
* ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.*/

#include <TimerSys.h>

#define Delay 1000000

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

uint32 elapsed;
uint32 incTime;
bit leapyear;

void tech_timerSysInit()
{
	elapsed = incTime = 0;
	leapyear = 0;
	memset(&tm_current, 0, sizeof(time_t));
	tech_gettimeofday(&start);
}

void tech_setInc(uint32 inc)
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

				if (Tech_isLeapYear(tm_current.yy))
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

	if (elapsed < Delay)
		return;

	elapsed -= Delay;
	tm_current.ss++;
	
	while (tm_current.ss >= 60)
		tech_incTime();
}

bool tech_isLeapYear(uint16 yy)
{
	if (yy % 100 == 0)
		if (yy % 400 == 0)
			return true;
		else if (yy % 4 == 0)
			return true;

	return false;
}

void tech_gettimeofday(timeval_t *tv)
{
	int32 epoch = Time_dateToEpoch(&tm_current);
	tv->tv_sec = epoch;
	tv->tv_usec = elapsed;
}

uint32 tech_getTicks()
{
	timeval_t ret;
	uint32 ticks;
	tech_gettimeofday(&ret);
	ticks = (ret.tv_sec - start.tv_sec) * 1000;
	ticks += (ret.tv_usec - start.tv_usec) / 1000;
	return ticks;
}

uint32 tech_time(time_t *t)
{
	int32 epoch;
	time_t ts;

	if (t)
		memcpy(&ts, t, sizeof(time_t));
	else memcpy(&ts, &tm_current, sizeof(time_t));
        
	epoch = Time_dateToEpoch(&ts);

	return epoch;
}

uint8 tech_weekday()
{
	// Day-of-week algorithm by Tomohiko Sakamoto
	const int t[] = { 0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4 };
	uint16 y;
	uint8 m;
	y = tm_current.yy;
	m = tm_current.mo;
	y -= m < 3;
	return (y + y/4 - y/100 + y/400 + t[m-1] + tm_current.wd) % 7;
}

const char *tech_getMonth(uint8 month)
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

	if (month >= 12) return NULL;

	return __MONTHS[month];
}

void tech_setTime(time_t *time)
{
	memcpy(&tm_current, time, sizeof(time_t));
}