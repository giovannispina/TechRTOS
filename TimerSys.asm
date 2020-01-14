
_tech_timerSysInit:

;TimerSys.c,39 :: 		void tech_timerSysInit()
;TimerSys.c,41 :: 		elapsed = incTime = 0;
	CLRF        _incTime+0 
	CLRF        _incTime+1 
	CLRF        _incTime+2 
	CLRF        _incTime+3 
	CLRF        _elapsed+0 
	CLRF        _elapsed+1 
	CLRF        _elapsed+2 
	CLRF        _elapsed+3 
;TimerSys.c,42 :: 		leapyear = 0;
	BCF         _leapyear+0, BitPos(_leapyear+0) 
;TimerSys.c,43 :: 		memset(&tm_current, 0, sizeof(time_t));
	MOVLW       _tm_current+0
	MOVWF       FARG_memset_p1+0 
	MOVLW       hi_addr(_tm_current+0)
	MOVWF       FARG_memset_p1+1 
	CLRF        FARG_memset_character+0 
	MOVLW       8
	MOVWF       FARG_memset_n+0 
	MOVLW       0
	MOVWF       FARG_memset_n+1 
	CALL        _memset+0, 0
;TimerSys.c,44 :: 		tech_gettimeofday(&start);
	MOVLW       _start+0
	MOVWF       FARG_tech_gettimeofday+0 
	MOVLW       hi_addr(_start+0)
	MOVWF       FARG_tech_gettimeofday+1 
	CALL        _tech_gettimeofday+0, 0
;TimerSys.c,45 :: 		}
L_end_tech_timerSysInit:
	RETURN      0
; end of _tech_timerSysInit

_tech_setInc:

;TimerSys.c,47 :: 		void tech_setInc(uint32 inc)
;TimerSys.c,49 :: 		incTime = inc;
	MOVF        FARG_tech_setInc_inc+0, 0 
	MOVWF       _incTime+0 
	MOVF        FARG_tech_setInc_inc+1, 0 
	MOVWF       _incTime+1 
	MOVF        FARG_tech_setInc_inc+2, 0 
	MOVWF       _incTime+2 
	MOVF        FARG_tech_setInc_inc+3, 0 
	MOVWF       _incTime+3 
;TimerSys.c,50 :: 		}
L_end_tech_setInc:
	RETURN      0
; end of _tech_setInc

_tech_incTime:

;TimerSys.c,52 :: 		void tech_incTime()
;TimerSys.c,54 :: 		tm_current.ss -= 60;
	MOVLW       60
	SUBWF       _tm_current+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _tm_current+0 
;TimerSys.c,55 :: 		tm_current.mn++;
	MOVF        _tm_current+1, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _tm_current+1 
;TimerSys.c,57 :: 		if (tm_current.mn >= 60)
	MOVLW       60
	SUBWF       _tm_current+1, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_tech_incTime0
;TimerSys.c,59 :: 		tm_current.mn -= 60;
	MOVLW       60
	SUBWF       _tm_current+1, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _tm_current+1 
;TimerSys.c,60 :: 		tm_current.hh++;
	MOVF        _tm_current+2, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _tm_current+2 
;TimerSys.c,61 :: 		}
L_tech_incTime0:
;TimerSys.c,63 :: 		if (tm_current.hh >= 24)
	MOVLW       24
	SUBWF       _tm_current+2, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_tech_incTime1
;TimerSys.c,65 :: 		tm_current.hh -= 24;
	MOVLW       24
	SUBWF       _tm_current+2, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _tm_current+2 
;TimerSys.c,66 :: 		tm_current.md++;
	MOVF        _tm_current+3, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _tm_current+3 
;TimerSys.c,68 :: 		if (tm_current.wd >= 6)
	MOVLW       6
	SUBWF       _tm_current+4, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_tech_incTime2
;TimerSys.c,69 :: 		tm_current.wd = 0;
	CLRF        _tm_current+4 
	GOTO        L_tech_incTime3
L_tech_incTime2:
;TimerSys.c,71 :: 		tm_current.wd++;
	MOVF        _tm_current+4, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _tm_current+4 
L_tech_incTime3:
;TimerSys.c,73 :: 		switch (tm_current.mo)
	GOTO        L_tech_incTime4
;TimerSys.c,75 :: 		case October:
L_tech_incTime6:
;TimerSys.c,76 :: 		if (tm_current.md >= 24)
	MOVLW       24
	SUBWF       _tm_current+3, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_tech_incTime7
;TimerSys.c,78 :: 		if (tm_current.wd = 6 && tm_current.hh == 3)
	MOVF        _tm_current+2, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L_tech_incTime9
	MOVLW       1
	MOVWF       R0 
	GOTO        L_tech_incTime8
L_tech_incTime9:
	CLRF        R0 
L_tech_incTime8:
	MOVF        R0, 0 
	MOVWF       _tm_current+4 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_tech_incTime10
;TimerSys.c,79 :: 		tm_current.hh--;
	DECF        _tm_current+2, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _tm_current+2 
L_tech_incTime10:
;TimerSys.c,80 :: 		if (tm_current.md >= 31)
	MOVLW       31
	SUBWF       _tm_current+3, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_tech_incTime11
;TimerSys.c,82 :: 		tm_current.mo++;
	MOVF        _tm_current+5, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _tm_current+5 
;TimerSys.c,83 :: 		tm_current.md -= 31;
	MOVLW       31
	SUBWF       _tm_current+3, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _tm_current+3 
;TimerSys.c,84 :: 		}
L_tech_incTime11:
;TimerSys.c,85 :: 		}
L_tech_incTime7:
;TimerSys.c,86 :: 		break;
	GOTO        L_tech_incTime5
;TimerSys.c,87 :: 		case March:
L_tech_incTime12:
;TimerSys.c,88 :: 		if (tm_current.md >= 24)
	MOVLW       24
	SUBWF       _tm_current+3, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_tech_incTime13
;TimerSys.c,90 :: 		if (tm_current.wd = 5 && tm_current.hh == 2)
	MOVF        _tm_current+2, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_tech_incTime15
	MOVLW       1
	MOVWF       R0 
	GOTO        L_tech_incTime14
L_tech_incTime15:
	CLRF        R0 
L_tech_incTime14:
	MOVF        R0, 0 
	MOVWF       _tm_current+4 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_tech_incTime16
;TimerSys.c,91 :: 		tm_current.hh++;
	MOVF        _tm_current+2, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _tm_current+2 
L_tech_incTime16:
;TimerSys.c,92 :: 		if (tm_current.md >= 31)
	MOVLW       31
	SUBWF       _tm_current+3, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_tech_incTime17
;TimerSys.c,94 :: 		tm_current.mo++;
	MOVF        _tm_current+5, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _tm_current+5 
;TimerSys.c,95 :: 		tm_current.md -= 31;
	MOVLW       31
	SUBWF       _tm_current+3, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _tm_current+3 
;TimerSys.c,96 :: 		}
L_tech_incTime17:
;TimerSys.c,97 :: 		}
L_tech_incTime13:
;TimerSys.c,98 :: 		break;
	GOTO        L_tech_incTime5
;TimerSys.c,99 :: 		case April:
L_tech_incTime18:
;TimerSys.c,100 :: 		case June:
L_tech_incTime19:
;TimerSys.c,101 :: 		case September:
L_tech_incTime20:
;TimerSys.c,102 :: 		case November:
L_tech_incTime21:
;TimerSys.c,103 :: 		if (tm_current.md >= 30)
	MOVLW       30
	SUBWF       _tm_current+3, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_tech_incTime22
;TimerSys.c,105 :: 		tm_current.mo++;
	MOVF        _tm_current+5, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _tm_current+5 
;TimerSys.c,106 :: 		tm_current.md -= 30;
	MOVLW       30
	SUBWF       _tm_current+3, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _tm_current+3 
;TimerSys.c,107 :: 		}
L_tech_incTime22:
;TimerSys.c,108 :: 		break;
	GOTO        L_tech_incTime5
;TimerSys.c,109 :: 		case February:
L_tech_incTime23:
;TimerSys.c,110 :: 		if (leapyear)
	BTFSS       _leapyear+0, BitPos(_leapyear+0) 
	GOTO        L_tech_incTime24
;TimerSys.c,112 :: 		if (tm_current.md >= 29)
	MOVLW       29
	SUBWF       _tm_current+3, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_tech_incTime25
;TimerSys.c,114 :: 		tm_current.mo++;
	MOVF        _tm_current+5, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _tm_current+5 
;TimerSys.c,115 :: 		tm_current.md -= 29;
	MOVLW       29
	SUBWF       _tm_current+3, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _tm_current+3 
;TimerSys.c,116 :: 		}
L_tech_incTime25:
;TimerSys.c,117 :: 		}
	GOTO        L_tech_incTime26
L_tech_incTime24:
;TimerSys.c,118 :: 		else if (tm_current.md >= 28)
	MOVLW       28
	SUBWF       _tm_current+3, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_tech_incTime27
;TimerSys.c,120 :: 		tm_current.mo++;
	MOVF        _tm_current+5, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _tm_current+5 
;TimerSys.c,121 :: 		tm_current.md -= 28;
	MOVLW       28
	SUBWF       _tm_current+3, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _tm_current+3 
;TimerSys.c,122 :: 		}
L_tech_incTime27:
L_tech_incTime26:
;TimerSys.c,123 :: 		break;
	GOTO        L_tech_incTime5
;TimerSys.c,124 :: 		default:
L_tech_incTime28:
;TimerSys.c,125 :: 		if (tm_current.md >= 31)
	MOVLW       31
	SUBWF       _tm_current+3, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_tech_incTime29
;TimerSys.c,127 :: 		tm_current.mo++;
	MOVF        _tm_current+5, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _tm_current+5 
;TimerSys.c,128 :: 		tm_current.md -= 31;
	MOVLW       31
	SUBWF       _tm_current+3, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _tm_current+3 
;TimerSys.c,129 :: 		}
L_tech_incTime29:
;TimerSys.c,130 :: 		break;
	GOTO        L_tech_incTime5
;TimerSys.c,131 :: 		case December:
L_tech_incTime30:
;TimerSys.c,132 :: 		if (tm_current.md >= 31)
	MOVLW       31
	SUBWF       _tm_current+3, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_tech_incTime31
;TimerSys.c,134 :: 		tm_current.yy++;
	MOVLW       1
	ADDWF       _tm_current+6, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _tm_current+7, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _tm_current+6 
	MOVF        R1, 0 
	MOVWF       _tm_current+7 
;TimerSys.c,135 :: 		tm_current.md -= 30;
	MOVLW       30
	SUBWF       _tm_current+3, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _tm_current+3 
;TimerSys.c,136 :: 		tm_current.mo = 0;
	CLRF        _tm_current+5 
;TimerSys.c,138 :: 		if (tech_isLeapYear(tm_current.yy))
	MOVF        _tm_current+6, 0 
	MOVWF       FARG_tech_isLeapYear+0 
	MOVF        _tm_current+7, 0 
	MOVWF       FARG_tech_isLeapYear+1 
	CALL        _tech_isLeapYear+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_tech_incTime32
;TimerSys.c,139 :: 		leapyear = 1;
	BSF         _leapyear+0, BitPos(_leapyear+0) 
	GOTO        L_tech_incTime33
L_tech_incTime32:
;TimerSys.c,141 :: 		leapyear = 0;
	BCF         _leapyear+0, BitPos(_leapyear+0) 
L_tech_incTime33:
;TimerSys.c,142 :: 		}
L_tech_incTime31:
;TimerSys.c,143 :: 		break;
	GOTO        L_tech_incTime5
;TimerSys.c,144 :: 		}
L_tech_incTime4:
	MOVF        _tm_current+5, 0 
	XORLW       9
	BTFSC       STATUS+0, 2 
	GOTO        L_tech_incTime6
	MOVF        _tm_current+5, 0 
	XORLW       2
	BTFSC       STATUS+0, 2 
	GOTO        L_tech_incTime12
	MOVF        _tm_current+5, 0 
	XORLW       3
	BTFSC       STATUS+0, 2 
	GOTO        L_tech_incTime18
	MOVF        _tm_current+5, 0 
	XORLW       5
	BTFSC       STATUS+0, 2 
	GOTO        L_tech_incTime19
	MOVF        _tm_current+5, 0 
	XORLW       8
	BTFSC       STATUS+0, 2 
	GOTO        L_tech_incTime20
	MOVF        _tm_current+5, 0 
	XORLW       10
	BTFSC       STATUS+0, 2 
	GOTO        L_tech_incTime21
	MOVF        _tm_current+5, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_tech_incTime23
	MOVF        _tm_current+5, 0 
	XORLW       11
	BTFSC       STATUS+0, 2 
	GOTO        L_tech_incTime30
	GOTO        L_tech_incTime28
L_tech_incTime5:
;TimerSys.c,145 :: 		}
L_tech_incTime1:
;TimerSys.c,146 :: 		}
L_end_tech_incTime:
	RETURN      0
; end of _tech_incTime

_tech_timer:

;TimerSys.c,148 :: 		void tech_timer()
;TimerSys.c,150 :: 		elapsed += incTime;
	MOVF        _incTime+0, 0 
	ADDWF       _elapsed+0, 0 
	MOVWF       R1 
	MOVF        _incTime+1, 0 
	ADDWFC      _elapsed+1, 0 
	MOVWF       R2 
	MOVF        _incTime+2, 0 
	ADDWFC      _elapsed+2, 0 
	MOVWF       R3 
	MOVF        _incTime+3, 0 
	ADDWFC      _elapsed+3, 0 
	MOVWF       R4 
	MOVF        R1, 0 
	MOVWF       _elapsed+0 
	MOVF        R2, 0 
	MOVWF       _elapsed+1 
	MOVF        R3, 0 
	MOVWF       _elapsed+2 
	MOVF        R4, 0 
	MOVWF       _elapsed+3 
;TimerSys.c,152 :: 		if (elapsed < Delay)
	MOVLW       0
	SUBWF       R4, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__tech_timer48
	MOVLW       15
	SUBWF       R3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__tech_timer48
	MOVLW       66
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__tech_timer48
	MOVLW       64
	SUBWF       R1, 0 
L__tech_timer48:
	BTFSC       STATUS+0, 0 
	GOTO        L_tech_timer34
;TimerSys.c,153 :: 		return;
	GOTO        L_end_tech_timer
L_tech_timer34:
;TimerSys.c,155 :: 		elapsed -= Delay;
	MOVLW       64
	SUBWF       _elapsed+0, 1 
	MOVLW       66
	SUBWFB      _elapsed+1, 1 
	MOVLW       15
	SUBWFB      _elapsed+2, 1 
	MOVLW       0
	SUBWFB      _elapsed+3, 1 
;TimerSys.c,156 :: 		tm_current.ss++;
	MOVF        _tm_current+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _tm_current+0 
;TimerSys.c,158 :: 		while (tm_current.ss >= 60)
L_tech_timer35:
	MOVLW       60
	SUBWF       _tm_current+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_tech_timer36
;TimerSys.c,159 :: 		tech_incTime();
	CALL        _tech_incTime+0, 0
	GOTO        L_tech_timer35
L_tech_timer36:
;TimerSys.c,160 :: 		}
L_end_tech_timer:
	RETURN      0
; end of _tech_timer

_tech_isLeapYear:

;TimerSys.c,162 :: 		bool tech_isLeapYear(uint16 yy)
;TimerSys.c,164 :: 		if (yy % 100 == 0)
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FARG_tech_isLeapYear_yy+0, 0 
	MOVWF       R0 
	MOVF        FARG_tech_isLeapYear_yy+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__tech_isLeapYear50
	MOVLW       0
	XORWF       R0, 0 
L__tech_isLeapYear50:
	BTFSS       STATUS+0, 2 
	GOTO        L_tech_isLeapYear37
;TimerSys.c,165 :: 		if (yy % 400 == 0)
	MOVLW       144
	MOVWF       R4 
	MOVLW       1
	MOVWF       R5 
	MOVF        FARG_tech_isLeapYear_yy+0, 0 
	MOVWF       R0 
	MOVF        FARG_tech_isLeapYear_yy+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__tech_isLeapYear51
	MOVLW       0
	XORWF       R0, 0 
L__tech_isLeapYear51:
	BTFSS       STATUS+0, 2 
	GOTO        L_tech_isLeapYear38
;TimerSys.c,166 :: 		return true;
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_tech_isLeapYear
L_tech_isLeapYear38:
;TimerSys.c,167 :: 		else if (yy % 4 == 0)
	MOVLW       3
	ANDWF       FARG_tech_isLeapYear_yy+0, 0 
	MOVWF       R1 
	MOVF        FARG_tech_isLeapYear_yy+1, 0 
	MOVWF       R2 
	MOVLW       0
	ANDWF       R2, 1 
	MOVLW       0
	XORWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__tech_isLeapYear52
	MOVLW       0
	XORWF       R1, 0 
L__tech_isLeapYear52:
	BTFSS       STATUS+0, 2 
	GOTO        L_tech_isLeapYear40
;TimerSys.c,168 :: 		return true;
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_tech_isLeapYear
L_tech_isLeapYear40:
L_tech_isLeapYear37:
;TimerSys.c,170 :: 		return false;
	CLRF        R0 
;TimerSys.c,171 :: 		}
L_end_tech_isLeapYear:
	RETURN      0
; end of _tech_isLeapYear

_tech_gettimeofday:

;TimerSys.c,173 :: 		void tech_gettimeofday(timeval_t *tv)
;TimerSys.c,175 :: 		int32 epoch = Time_dateToEpoch(&tm_current);
	MOVLW       _tm_current+0
	MOVWF       FARG_Time_dateToEpoch_ts+0 
	MOVLW       hi_addr(_tm_current+0)
	MOVWF       FARG_Time_dateToEpoch_ts+1 
	CALL        _Time_dateToEpoch+0, 0
;TimerSys.c,176 :: 		tv->tv_sec = epoch;
	MOVFF       FARG_tech_gettimeofday_tv+0, FSR1L+0
	MOVFF       FARG_tech_gettimeofday_tv+1, FSR1H+0
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
	MOVF        R2, 0 
	MOVWF       POSTINC1+0 
	MOVF        R3, 0 
	MOVWF       POSTINC1+0 
;TimerSys.c,177 :: 		tv->tv_usec = elapsed;
	MOVLW       4
	ADDWF       FARG_tech_gettimeofday_tv+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_tech_gettimeofday_tv+1, 0 
	MOVWF       FSR1L+1 
	MOVF        _elapsed+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        _elapsed+1, 0 
	MOVWF       POSTINC1+0 
	MOVF        _elapsed+2, 0 
	MOVWF       POSTINC1+0 
	MOVF        _elapsed+3, 0 
	MOVWF       POSTINC1+0 
;TimerSys.c,178 :: 		}
L_end_tech_gettimeofday:
	RETURN      0
; end of _tech_gettimeofday

_tech_getTicks:

;TimerSys.c,180 :: 		uint32 tech_getTicks()
;TimerSys.c,184 :: 		tech_gettimeofday(&ret);
	MOVLW       tech_getTicks_ret_L0+0
	MOVWF       FARG_tech_gettimeofday_tv+0 
	MOVLW       hi_addr(tech_getTicks_ret_L0+0)
	MOVWF       FARG_tech_gettimeofday_tv+1 
	CALL        _tech_gettimeofday+0, 0
;TimerSys.c,185 :: 		ticks = (ret.tv_sec - start.tv_sec) * 1000;
	MOVF        tech_getTicks_ret_L0+0, 0 
	MOVWF       R0 
	MOVF        tech_getTicks_ret_L0+1, 0 
	MOVWF       R1 
	MOVF        tech_getTicks_ret_L0+2, 0 
	MOVWF       R2 
	MOVF        tech_getTicks_ret_L0+3, 0 
	MOVWF       R3 
	MOVF        _start+0, 0 
	SUBWF       R0, 1 
	MOVF        _start+1, 0 
	SUBWFB      R1, 1 
	MOVF        _start+2, 0 
	SUBWFB      R2, 1 
	MOVF        _start+3, 0 
	SUBWFB      R3, 1 
	MOVLW       232
	MOVWF       R4 
	MOVLW       3
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__tech_getTicks+0 
	MOVF        R1, 0 
	MOVWF       FLOC__tech_getTicks+1 
	MOVF        R2, 0 
	MOVWF       FLOC__tech_getTicks+2 
	MOVF        R3, 0 
	MOVWF       FLOC__tech_getTicks+3 
	MOVF        tech_getTicks_ret_L0+4, 0 
	MOVWF       R0 
	MOVF        tech_getTicks_ret_L0+5, 0 
	MOVWF       R1 
	MOVF        tech_getTicks_ret_L0+6, 0 
	MOVWF       R2 
	MOVF        tech_getTicks_ret_L0+7, 0 
	MOVWF       R3 
	MOVF        _start+4, 0 
	SUBWF       R0, 1 
	MOVF        _start+5, 0 
	SUBWFB      R1, 1 
	MOVF        _start+6, 0 
	SUBWFB      R2, 1 
	MOVF        _start+7, 0 
	SUBWFB      R3, 1 
;TimerSys.c,186 :: 		ticks += (ret.tv_usec - start.tv_usec) / 1000;
	MOVLW       232
	MOVWF       R4 
	MOVLW       3
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Div_32x32_S+0, 0
	MOVF        FLOC__tech_getTicks+0, 0 
	ADDWF       R0, 1 
	MOVF        FLOC__tech_getTicks+1, 0 
	ADDWFC      R1, 1 
	MOVF        FLOC__tech_getTicks+2, 0 
	ADDWFC      R2, 1 
	MOVF        FLOC__tech_getTicks+3, 0 
	ADDWFC      R3, 1 
;TimerSys.c,187 :: 		return ticks;
;TimerSys.c,188 :: 		}
L_end_tech_getTicks:
	RETURN      0
; end of _tech_getTicks

_tech_time:

;TimerSys.c,190 :: 		uint32 tech_time(time_t *t)
;TimerSys.c,195 :: 		if (t)
	MOVF        FARG_tech_time_t+0, 0 
	IORWF       FARG_tech_time_t+1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_tech_time41
;TimerSys.c,196 :: 		memcpy(&ts, t, sizeof(time_t));
	MOVLW       tech_time_ts_L0+0
	MOVWF       FARG_memcpy_d1+0 
	MOVLW       hi_addr(tech_time_ts_L0+0)
	MOVWF       FARG_memcpy_d1+1 
	MOVF        FARG_tech_time_t+0, 0 
	MOVWF       FARG_memcpy_s1+0 
	MOVF        FARG_tech_time_t+1, 0 
	MOVWF       FARG_memcpy_s1+1 
	MOVLW       8
	MOVWF       FARG_memcpy_n+0 
	MOVLW       0
	MOVWF       FARG_memcpy_n+1 
	CALL        _memcpy+0, 0
	GOTO        L_tech_time42
L_tech_time41:
;TimerSys.c,198 :: 		memcpy(&ts, &tm_current, sizeof(time_t));
	MOVLW       tech_time_ts_L0+0
	MOVWF       FARG_memcpy_d1+0 
	MOVLW       hi_addr(tech_time_ts_L0+0)
	MOVWF       FARG_memcpy_d1+1 
	MOVLW       _tm_current+0
	MOVWF       FARG_memcpy_s1+0 
	MOVLW       hi_addr(_tm_current+0)
	MOVWF       FARG_memcpy_s1+1 
	MOVLW       8
	MOVWF       FARG_memcpy_n+0 
	MOVLW       0
	MOVWF       FARG_memcpy_n+1 
	CALL        _memcpy+0, 0
L_tech_time42:
;TimerSys.c,200 :: 		epoch = Time_dateToEpoch(&ts);
	MOVLW       tech_time_ts_L0+0
	MOVWF       FARG_Time_dateToEpoch_ts+0 
	MOVLW       hi_addr(tech_time_ts_L0+0)
	MOVWF       FARG_Time_dateToEpoch_ts+1 
	CALL        _Time_dateToEpoch+0, 0
;TimerSys.c,202 :: 		return epoch;
;TimerSys.c,203 :: 		}
L_end_tech_time:
	RETURN      0
; end of _tech_time

_tech_weekday:

;TimerSys.c,205 :: 		uint8 tech_weekday()
;TimerSys.c,213 :: 		y -= m < 3;
	MOVLW       3
	SUBWF       _tm_current+5, 0 
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 0 
	SUBWF       _tm_current+6, 0 
	MOVWF       FLOC__tech_weekday+2 
	MOVLW       0
	SUBWFB      _tm_current+7, 0 
	MOVWF       FLOC__tech_weekday+3 
;TimerSys.c,214 :: 		return (y + y / 4 - y / 100 + y / 400 + t[m - 1] + tm_current.wd) % 7;
	MOVF        FLOC__tech_weekday+2, 0 
	MOVWF       R0 
	MOVF        FLOC__tech_weekday+3, 0 
	MOVWF       R1 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	MOVF        R0, 0 
	ADDWF       FLOC__tech_weekday+2, 0 
	MOVWF       FLOC__tech_weekday+0 
	MOVF        R1, 0 
	ADDWFC      FLOC__tech_weekday+3, 0 
	MOVWF       FLOC__tech_weekday+1 
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FLOC__tech_weekday+2, 0 
	MOVWF       R0 
	MOVF        FLOC__tech_weekday+3, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVF        R0, 0 
	SUBWF       FLOC__tech_weekday+0, 1 
	MOVF        R1, 0 
	SUBWFB      FLOC__tech_weekday+1, 1 
	MOVLW       144
	MOVWF       R4 
	MOVLW       1
	MOVWF       R5 
	MOVF        FLOC__tech_weekday+2, 0 
	MOVWF       R0 
	MOVF        FLOC__tech_weekday+3, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVF        R0, 0 
	ADDWF       FLOC__tech_weekday+0, 0 
	MOVWF       R7 
	MOVF        R1, 0 
	ADDWFC      FLOC__tech_weekday+1, 0 
	MOVWF       R8 
	DECF        _tm_current+5, 0 
	MOVWF       R5 
	CLRF        R6 
	MOVLW       0
	SUBWFB      R6, 1 
	MOVF        R5, 0 
	MOVWF       R0 
	MOVF        R6, 0 
	MOVWF       R1 
	MOVLW       0
	BTFSC       R6, 7 
	MOVLW       255
	MOVWF       R2 
	MOVWF       R3 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	RLCF        R2, 1 
	RLCF        R3, 1 
	MOVLW       tech_weekday_t_L0+0
	ADDWF       R0, 0 
	MOVWF       TBLPTR+0 
	MOVLW       hi_addr(tech_weekday_t_L0+0)
	ADDWFC      R1, 0 
	MOVWF       TBLPTR+1 
	MOVLW       higher_addr(tech_weekday_t_L0+0)
	ADDWFC      R2, 0 
	MOVWF       TBLPTR+2 
	TBLRD*+
	MOVFF       TABLAT+0, R0
	TBLRD*+
	MOVFF       TABLAT+0, R1
	MOVF        R7, 0 
	ADDWF       R0, 1 
	MOVF        R8, 0 
	ADDWFC      R1, 1 
	MOVF        _tm_current+4, 0 
	ADDWF       R0, 1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       7
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
;TimerSys.c,215 :: 		}
L_end_tech_weekday:
	RETURN      0
; end of _tech_weekday

_tech_getMonth:

;TimerSys.c,217 :: 		const char *tech_getMonth(uint8 month)
;TimerSys.c,234 :: 		if (month >= 12)
	MOVLW       12
	SUBWF       FARG_tech_getMonth_month+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_tech_getMonth43
;TimerSys.c,235 :: 		return NULL;
	CLRF        R0 
	CLRF        R1 
	CLRF        R2 
	GOTO        L_end_tech_getMonth
L_tech_getMonth43:
;TimerSys.c,237 :: 		return __MONTHS[month];
	MOVLW       12
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVWF       R2 
	MOVWF       R3 
	MOVF        FARG_tech_getMonth_month+0, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVLW       tech_getMonth___MONTHS_L0+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(tech_getMonth___MONTHS_L0+0)
	ADDWFC      R1, 1 
	MOVLW       higher_addr(tech_getMonth___MONTHS_L0+0)
	ADDWFC      R2, 1 
;TimerSys.c,238 :: 		}
L_end_tech_getMonth:
	RETURN      0
; end of _tech_getMonth

_tech_setTime:

;TimerSys.c,240 :: 		void tech_setTime(time_t *time)
;TimerSys.c,242 :: 		memcpy(&tm_current, time, sizeof(time_t));
	MOVLW       _tm_current+0
	MOVWF       FARG_memcpy_d1+0 
	MOVLW       hi_addr(_tm_current+0)
	MOVWF       FARG_memcpy_d1+1 
	MOVF        FARG_tech_setTime_time+0, 0 
	MOVWF       FARG_memcpy_s1+0 
	MOVF        FARG_tech_setTime_time+1, 0 
	MOVWF       FARG_memcpy_s1+1 
	MOVLW       8
	MOVWF       FARG_memcpy_n+0 
	MOVLW       0
	MOVWF       FARG_memcpy_n+1 
	CALL        _memcpy+0, 0
;TimerSys.c,243 :: 		}
L_end_tech_setTime:
	RETURN      0
; end of _tech_setTime
