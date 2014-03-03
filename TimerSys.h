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

#ifndef __TIMERSYS_H__
#define __TIMERSYS_H__

#include <Types.h>
#include <timelib.h>

typedef struct timeval
{
   int32 tv_sec;
   int32 tv_usec;
} timeval_t;

typedef TimeStruct time_t;

void		tech_timerSysInit();
void		tech_setInc(uint32);
void		tech_timer();
bool		tech_isLeapYear(uint16);
void		tech_gettimeofday(timeval_t*);
uint32		tech_getTicks();
uint32		tech_time(time_t*);
uint8		tech_weekday();
const char*	tech_getMonth(uint8);
void		tech_setTime(time_t*);

#endif /* __TIMERSYS_H__ */