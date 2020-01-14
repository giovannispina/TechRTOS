
_context_equal:

;TechRTOS.c,38 :: 		int context_equal(void* cxt1, void* cxt2)
;TechRTOS.c,40 :: 		if (cxt1 == cxt2)
	MOVF        FARG_context_equal_cxt1+1, 0 
	XORWF       FARG_context_equal_cxt2+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__context_equal28
	MOVF        FARG_context_equal_cxt2+0, 0 
	XORWF       FARG_context_equal_cxt1+0, 0 
L__context_equal28:
	BTFSS       STATUS+0, 2 
	GOTO        L_context_equal0
;TechRTOS.c,41 :: 		return 0;
	CLRF        R0 
	CLRF        R1 
	GOTO        L_end_context_equal
L_context_equal0:
;TechRTOS.c,42 :: 		else return 1;
	MOVLW       1
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
;TechRTOS.c,43 :: 		}
L_end_context_equal:
	RETURN      0
; end of _context_equal

_yield:

;TechRTOS.c,45 :: 		void yield()
;TechRTOS.c,48 :: 		save_context();
	MOVFF       FSR0L+0, _tmp_data+0
	MOVFF       FSR0H+0, _tmp_data+1
	MOVFF       FSR1L+0, _tmp_data+2
	MOVFF       FSR1H+0, _tmp_data+3
	MOVFF       FSR2L+0, _tmp_data+4
	MOVFF       FSR2H+0, _tmp_data+5
	MOVFF       _current_cxt+0, FSR1L+0
	MOVFF       _current_cxt+1, FSR1H+0
	MOVFF       POSTINC1+0, FSR0L+0
	MOVFF       INDF1+0, FSR0H+0
	MOVFF       _tmp_data+0, POSTINC0+0
	MOVFF       _tmp_data+1, POSTINC0+0
	MOVFF       _tmp_data+2, POSTINC0+0
	MOVFF       _tmp_data+3, POSTINC0+0
	MOVFF       _tmp_data+4, POSTINC0+0
	MOVFF       _tmp_data+5, POSTINC0+0
	MOVFF       WREG+0, POSTINC0+0
	MOVFF       STATUS+0, POSTINC0+0
	BCF         INTCON+0, 7 
	MOVFF       BSR+0, POSTINC0+0
	MOVFF       TABLAT+0, POSTINC0+0
	MOVFF       TBLPTRU+0, POSTINC0+0
	MOVFF       TBLPTRH+0, POSTINC0+0
	MOVFF       TBLPTRL+0, POSTINC0+0
	MOVFF       PRODH+0, POSTINC0+0
	MOVFF       PRODL+0, POSTINC0+0
	MOVFF       PCLATU+0, POSTINC0+0
	MOVFF       PCLATH+0, POSTINC0+0
	MOVFF       R0, POSTINC0+0
	MOVFF       R1, POSTINC0+0
	MOVFF       R2, POSTINC0+0
	MOVFF       R3, POSTINC0+0
	MOVFF       R4, POSTINC0+0
	MOVFF       R5, POSTINC0+0
	MOVFF       R6, POSTINC0+0
	MOVFF       R7, POSTINC0+0
	MOVFF       R8, POSTINC0+0
	MOVFF       R9, POSTINC0+0
	MOVFF       R10, POSTINC0+0
	MOVFF       R11, POSTINC0+0
	MOVFF       R12, POSTINC0+0
	MOVFF       R13, POSTINC0+0
	MOVFF       R14, POSTINC0+0
	MOVFF       R15, POSTINC0+0
	MOVFF       R16, POSTINC0+0
	MOVFF       R17, POSTINC0+0
	MOVFF       R18, POSTINC0+0
	MOVFF       R19, POSTINC0+0
	MOVFF       R20, POSTINC0+0
	MOVFF       _current_cxt+0, FSR2L+0
	MOVFF       _current_cxt+1, FSR2H+0
	MOVLW       4
	ADDWF       FSR2L+0, 1, 1
	BTFSC       STATUS+0, 0, 1
	INCFSZ      FSR2H+0, 1, 1
	MOVF        STKPTR+0, 0 
	SUBWF       INDF2+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_yield2
	MOVF        STKPTR+0, 0 
	MOVWF       FSR1L+0 
L_yield3:
	MOVF        STKPTR+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_yield4
	MOVFF       TOSU+0, POSTINC0+0
	MOVFF       TOSH+0, POSTINC0+0
	MOVFF       TOSL+0, POSTINC0+0
	POP
	GOTO        L_yield3
L_yield4:
	MOVFF       FSR1L+0, INDF0+0
	MOVFF       _current_cxt+0, FSR1L+0
	MOVFF       _current_cxt+1, FSR1H+0
	MOVLW       2
	ADDWF       FSR1L+0, 1, 1
	BTFSC       STATUS+0, 0, 1
	INCFSZ      FSR1H+0, 1, 1
	MOVFF       FSR0L+0, POSTINC1+0
	MOVFF       FSR0H+0, POSTINC1+0
	GOTO        L_yield5
L_yield2:
	CALL        _tech_handle_crash+0, 0
L_yield5:
;TechRTOS.c,50 :: 		node = list_find(cxtlist, &context_equal, current_cxt);
	MOVF        _cxtlist+0, 0 
	MOVWF       FARG_list_find_list+0 
	MOVF        _cxtlist+1, 0 
	MOVWF       FARG_list_find_list+1 
	MOVLW       _context_equal+0
	MOVWF       FARG_list_find_func+0 
	MOVLW       hi_addr(_context_equal+0)
	MOVWF       FARG_list_find_func+1 
	MOVLW       FARG_context_equal_cxt1+0
	MOVWF       FARG_list_find_func+2 
	MOVLW       hi_addr(FARG_context_equal_cxt1+0)
	MOVWF       FARG_list_find_func+3 
	MOVF        _current_cxt+0, 0 
	MOVWF       FARG_list_find_pdata+0 
	MOVF        _current_cxt+1, 0 
	MOVWF       FARG_list_find_pdata+1 
	CALL        _list_find+0, 0
	MOVF        R0, 0 
	MOVWF       yield_node_L0+0 
	MOVF        R1, 0 
	MOVWF       yield_node_L0+1 
;TechRTOS.c,51 :: 		if (node && node->next)
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_yield8
	MOVFF       yield_node_L0+0, FSR0L+0
	MOVFF       yield_node_L0+1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_yield8
L__yield26:
;TechRTOS.c,52 :: 		current_cxt = node->next->pdata;
	MOVFF       yield_node_L0+0, FSR0L+0
	MOVFF       yield_node_L0+1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVLW       4
	ADDWF       R0, 0 
	MOVWF       FSR0L+0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0L+1 
	MOVF        POSTINC0+0, 0 
	MOVWF       _current_cxt+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       _current_cxt+1 
	GOTO        L_yield9
L_yield8:
;TechRTOS.c,53 :: 		else if ((node = list_begin(cxtlist)))
	MOVF        _cxtlist+0, 0 
	MOVWF       FARG_list_begin_list+0 
	MOVF        _cxtlist+1, 0 
	MOVWF       FARG_list_begin_list+1 
	CALL        _list_begin+0, 0
	MOVF        R0, 0 
	MOVWF       yield_node_L0+0 
	MOVF        R1, 0 
	MOVWF       yield_node_L0+1 
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_yield10
;TechRTOS.c,54 :: 		current_cxt = node->pdata;
	MOVLW       4
	ADDWF       yield_node_L0+0, 0 
	MOVWF       FSR0L+0 
	MOVLW       0
	ADDWFC      yield_node_L0+1, 0 
	MOVWF       FSR0L+1 
	MOVF        POSTINC0+0, 0 
	MOVWF       _current_cxt+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       _current_cxt+1 
	GOTO        L_yield11
L_yield10:
;TechRTOS.c,55 :: 		else current_cxt = main_cxt;
	MOVF        _main_cxt+0, 0 
	MOVWF       _current_cxt+0 
	MOVF        _main_cxt+1, 0 
	MOVWF       _current_cxt+1 
L_yield11:
L_yield9:
;TechRTOS.c,57 :: 		restore_context();
	MOVF        _current_cxt+0, 0 
	MOVWF       R0 
	MOVF        _current_cxt+1, 0 
	MOVWF       R1 
	MOVLW       2
	ADDWF       R0, 0 
	MOVWF       FSR0L+0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0L+1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVF        POSTINC0+0, 0 
	MOVWF       R4 
	MOVF        _current_cxt+0, 0 
	MOVWF       FSR2L+0 
	MOVF        _current_cxt+1, 0 
	MOVWF       FSR2L+1 
	MOVF        POSTINC2+0, 0 
	MOVWF       R1 
	MOVF        POSTINC2+0, 0 
	MOVWF       R2 
	MOVF        R4, 0 
	XORWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__yield30
	MOVF        R1, 0 
	XORWF       R3, 0 
L__yield30:
	BTFSS       STATUS+0, 2 
	GOTO        L_yield12
	MOVF        _main_cxt+0, 0 
	MOVWF       _current_cxt+0 
	MOVF        _main_cxt+1, 0 
	MOVWF       _current_cxt+1 
L_yield12:
	MOVF        _current_cxt+0, 0 
	MOVWF       R0 
	MOVF        _current_cxt+1, 0 
	MOVWF       R1 
	MOVLW       2
	ADDWF       R0, 0 
	MOVWF       FSR0L+0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0L+1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVF        POSTINC0+0, 0 
	MOVWF       R4 
	MOVLW       255
	ANDWF       R3, 0 
	MOVWF       FSR0L+0 
	MOVF        R4, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       255
	ANDWF       R0, 0 
	MOVWF       FSR0H+0 
	CLRF        STKPTR+0 
	MOVFF       POSTDEC0+0, FSR1L+0
L_yield13:
	MOVF        FSR1L+0, 0 
	SUBWF       STKPTR+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_yield14
	PUSH
	MOVF        POSTDEC0+0, 0, 0
	MOVWF       TOSL+0, 0
	MOVF        POSTDEC0+0, 0, 0
	MOVWF       TOSH+0, 0
	MOVF        POSTDEC0+0, 0, 0
	MOVWF       TOSU+0, 0
	GOTO        L_yield13
L_yield14:
	MOVFF       POSTDEC0+0, R20
	MOVFF       POSTDEC0+0, R19
	MOVFF       POSTDEC0+0, R18
	MOVFF       POSTDEC0+0, R17
	MOVFF       POSTDEC0+0, R16
	MOVFF       POSTDEC0+0, R15
	MOVFF       POSTDEC0+0, R14
	MOVFF       POSTDEC0+0, R13
	MOVFF       POSTDEC0+0, R12
	MOVFF       POSTDEC0+0, R11
	MOVFF       POSTDEC0+0, R10
	MOVFF       POSTDEC0+0, R9
	MOVFF       POSTDEC0+0, R8
	MOVFF       POSTDEC0+0, R7
	MOVFF       POSTDEC0+0, R6
	MOVFF       POSTDEC0+0, R5
	MOVFF       POSTDEC0+0, R4
	MOVFF       POSTDEC0+0, R3
	MOVFF       POSTDEC0+0, R2
	MOVFF       POSTDEC0+0, R1
	MOVFF       POSTDEC0+0, R0
	MOVFF       POSTDEC0+0, PCLATH+0
	MOVFF       POSTDEC0+0, PCLATU+0
	MOVFF       POSTDEC0+0, PRODL+0
	MOVFF       POSTDEC0+0, PRODH+0
	MOVFF       POSTDEC0+0, TBLPTRL+0
	MOVFF       POSTDEC0+0, TBLPTRH+0
	MOVFF       POSTDEC0+0, TBLPTRU+0
	MOVFF       POSTDEC0+0, TABLAT+0
	MOVFF       POSTDEC0+0, BSR+0
	MOVFF       POSTDEC0+0, STATUS+0
	MOVFF       POSTDEC0+0, WREG+0
	MOVFF       POSTDEC0+0, _tmp_data+5
	MOVFF       POSTDEC0+0, _tmp_data+4
	MOVFF       POSTDEC0+0, _tmp_data+3
	MOVFF       POSTDEC0+0, _tmp_data+2
	MOVFF       POSTDEC0+0, _tmp_data+1
	MOVFF       INDF0+0, _tmp_data+0
	MOVFF       _tmp_data+0, FSR0L+0
	MOVFF       _tmp_data+1, FSR0H+0
	MOVFF       _tmp_data+2, FSR1L+0
	MOVFF       _tmp_data+3, FSR1H+0
	MOVFF       _tmp_data+4, FSR2L+0
	MOVFF       _tmp_data+5, FSR2H+0
;TechRTOS.c,59 :: 		enableInt();
	BSF         INTCON+0, 7 
;TechRTOS.c,60 :: 		}
L_end_yield:
	RETURN      0
; end of _yield

_tech_init:

;TechRTOS.c,62 :: 		void tech_init()
;TechRTOS.c,64 :: 		tech_memory_init();
	CALL        _tech_memory_init+0, 0
;TechRTOS.c,65 :: 		tech_timerSysInit();
	CALL        _tech_timerSysInit+0, 0
;TechRTOS.c,66 :: 		main_cxt = tech_cxt(NULL, NULL, MAX_STACK_SIZE);
	CLRF        FARG_tech_cxt+0 
	CLRF        FARG_tech_cxt+1 
	CLRF        FARG_tech_cxt+2 
	CLRF        FARG_tech_cxt+3 
	CLRF        FARG_tech_cxt+0 
	CLRF        FARG_tech_cxt+1 
	MOVLW       31
	MOVWF       FARG_tech_cxt+0 
	MOVLW       0
	MOVWF       FARG_tech_cxt+1 
	CALL        _tech_cxt+0, 0
	MOVF        R0, 0 
	MOVWF       _main_cxt+0 
	MOVF        R1, 0 
	MOVWF       _main_cxt+1 
;TechRTOS.c,67 :: 		current_cxt = main_cxt;
	MOVF        _main_cxt+0, 0 
	MOVWF       _current_cxt+0 
	MOVF        _main_cxt+1, 0 
	MOVWF       _current_cxt+1 
;TechRTOS.c,69 :: 		cxtlist = list_new();
	CALL        _list_new+0, 0
	MOVF        R0, 0 
	MOVWF       _cxtlist+0 
	MOVF        R1, 0 
	MOVWF       _cxtlist+1 
;TechRTOS.c,70 :: 		}
L_end_tech_init:
	RETURN      0
; end of _tech_init

_tech_drop:

;TechRTOS.c,72 :: 		void tech_drop()
;TechRTOS.c,74 :: 		list_destroy(cxtlist);
	MOVF        _cxtlist+0, 0 
	MOVWF       FARG_list_destroy_list+0 
	MOVF        _cxtlist+1, 0 
	MOVWF       FARG_list_destroy_list+1 
	CALL        _list_destroy+0, 0
;TechRTOS.c,75 :: 		tech_freeAll();
	CALL        _tech_freeAll+0, 0
;TechRTOS.c,76 :: 		}
L_end_tech_drop:
	RETURN      0
; end of _tech_drop

_tech_safe_call:

;TechRTOS.c,78 :: 		void tech_safe_call()
;TechRTOS.c,81 :: 		PUSH
	PUSH
;TechRTOS.c,83 :: 		MOVFF _current_cxt+0, FSR1L
	MOVFF       _current_cxt+0, FSR1L+0
;TechRTOS.c,84 :: 		MOVFF _current_cxt+1, FSR1H
	MOVFF       _current_cxt+1, FSR1H+0
;TechRTOS.c,85 :: 		MOVLW 6
	MOVLW       6
;TechRTOS.c,86 :: 		ADDWF FSR1L
	ADDWF       FSR1L+0, 1, 1
;TechRTOS.c,87 :: 		BTFSC STATUS
	BTFSC       STATUS+0, 0, 1
;TechRTOS.c,88 :: 		INCFSZ FSR1H
	INCFSZ      FSR1H+0, 1, 1
;TechRTOS.c,90 :: 		MOVF POSTINC1, 0, 0
	MOVF        POSTINC1+0, 0, 0
;TechRTOS.c,91 :: 		MOVWF TOSL, 0
	MOVWF       TOSL+0, 0
;TechRTOS.c,92 :: 		MOVF POSTINC1, 0, 0
	MOVF        POSTINC1+0, 0, 0
;TechRTOS.c,93 :: 		MOVWF TOSH, 0
	MOVWF       TOSH+0, 0
;TechRTOS.c,94 :: 		CLRF  TOSU, 0
	CLRF        TOSU+0, 0
;TechRTOS.c,96 :: 		MOVFF POSTINC1, FSR0L
	MOVFF       POSTINC1+0, FSR0L+0
;TechRTOS.c,97 :: 		MOVFF POSTINC1, FSR0H
	MOVFF       POSTINC1+0, FSR0H+0
;TechRTOS.c,99 :: 		MOVFF POSTINC1, POSTINC0
	MOVFF       POSTINC1+0, POSTINC0+0
;TechRTOS.c,100 :: 		MOVFF INDF1, INDF0
	MOVFF       INDF1+0, INDF0+0
;TechRTOS.c,103 :: 		enableInt();
	BSF         INTCON+0, 7 
;TechRTOS.c,104 :: 		}
L_end_tech_safe_call:
	RETURN      0
; end of _tech_safe_call

_run_cxt:

;TechRTOS.c,106 :: 		void run_cxt(void* param)
;TechRTOS.c,108 :: 		pcontext_t cxt = (pcontext_t) param;
	MOVF        FARG_run_cxt_param+0, 0 
	MOVWF       run_cxt_cxt_L0+0 
	MOVF        FARG_run_cxt_param+1, 0 
	MOVWF       run_cxt_cxt_L0+1 
;TechRTOS.c,111 :: 		save_context();
	MOVFF       FSR0L+0, _tmp_data+0
	MOVFF       FSR0H+0, _tmp_data+1
	MOVFF       FSR1L+0, _tmp_data+2
	MOVFF       FSR1H+0, _tmp_data+3
	MOVFF       FSR2L+0, _tmp_data+4
	MOVFF       FSR2H+0, _tmp_data+5
	MOVFF       _current_cxt+0, FSR1L+0
	MOVFF       _current_cxt+1, FSR1H+0
	MOVFF       POSTINC1+0, FSR0L+0
	MOVFF       INDF1+0, FSR0H+0
	MOVFF       _tmp_data+0, POSTINC0+0
	MOVFF       _tmp_data+1, POSTINC0+0
	MOVFF       _tmp_data+2, POSTINC0+0
	MOVFF       _tmp_data+3, POSTINC0+0
	MOVFF       _tmp_data+4, POSTINC0+0
	MOVFF       _tmp_data+5, POSTINC0+0
	MOVFF       WREG+0, POSTINC0+0
	MOVFF       STATUS+0, POSTINC0+0
	BCF         INTCON+0, 7 
	MOVFF       BSR+0, POSTINC0+0
	MOVFF       TABLAT+0, POSTINC0+0
	MOVFF       TBLPTRU+0, POSTINC0+0
	MOVFF       TBLPTRH+0, POSTINC0+0
	MOVFF       TBLPTRL+0, POSTINC0+0
	MOVFF       PRODH+0, POSTINC0+0
	MOVFF       PRODL+0, POSTINC0+0
	MOVFF       PCLATU+0, POSTINC0+0
	MOVFF       PCLATH+0, POSTINC0+0
	MOVFF       R0, POSTINC0+0
	MOVFF       R1, POSTINC0+0
	MOVFF       R2, POSTINC0+0
	MOVFF       R3, POSTINC0+0
	MOVFF       R4, POSTINC0+0
	MOVFF       R5, POSTINC0+0
	MOVFF       R6, POSTINC0+0
	MOVFF       R7, POSTINC0+0
	MOVFF       R8, POSTINC0+0
	MOVFF       R9, POSTINC0+0
	MOVFF       R10, POSTINC0+0
	MOVFF       R11, POSTINC0+0
	MOVFF       R12, POSTINC0+0
	MOVFF       R13, POSTINC0+0
	MOVFF       R14, POSTINC0+0
	MOVFF       R15, POSTINC0+0
	MOVFF       R16, POSTINC0+0
	MOVFF       R17, POSTINC0+0
	MOVFF       R18, POSTINC0+0
	MOVFF       R19, POSTINC0+0
	MOVFF       R20, POSTINC0+0
	MOVFF       _current_cxt+0, FSR2L+0
	MOVFF       _current_cxt+1, FSR2H+0
	MOVLW       4
	ADDWF       FSR2L+0, 1, 1
	BTFSC       STATUS+0, 0, 1
	INCFSZ      FSR2H+0, 1, 1
	MOVF        STKPTR+0, 0 
	SUBWF       INDF2+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_run_cxt15
	MOVF        STKPTR+0, 0 
	MOVWF       FSR1L+0 
L_run_cxt16:
	MOVF        STKPTR+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_run_cxt17
	MOVFF       TOSU+0, POSTINC0+0
	MOVFF       TOSH+0, POSTINC0+0
	MOVFF       TOSL+0, POSTINC0+0
	POP
	GOTO        L_run_cxt16
L_run_cxt17:
	MOVFF       FSR1L+0, INDF0+0
	MOVFF       _current_cxt+0, FSR1L+0
	MOVFF       _current_cxt+1, FSR1H+0
	MOVLW       2
	ADDWF       FSR1L+0, 1, 1
	BTFSC       STATUS+0, 0, 1
	INCFSZ      FSR1H+0, 1, 1
	MOVFF       FSR0L+0, POSTINC1+0
	MOVFF       FSR0H+0, POSTINC1+0
	GOTO        L_run_cxt18
L_run_cxt15:
	CALL        _tech_handle_crash+0, 0
L_run_cxt18:
;TechRTOS.c,114 :: 		current_cxt = cxt;
	MOVF        run_cxt_cxt_L0+0, 0 
	MOVWF       _current_cxt+0 
	MOVF        run_cxt_cxt_L0+1, 0 
	MOVWF       _current_cxt+1 
;TechRTOS.c,115 :: 		tech_safe_call();
	CALL        _tech_safe_call+0, 0
;TechRTOS.c,118 :: 		disableInt();
	BCF         INTCON+0, 7 
;TechRTOS.c,119 :: 		tech_cxt_destroy(current_cxt);
	MOVF        _current_cxt+0, 0 
	MOVWF       FARG_tech_cxt_destroy+0 
	MOVF        _current_cxt+1, 0 
	MOVWF       FARG_tech_cxt_destroy+1 
	CALL        _tech_cxt_destroy+0, 0
;TechRTOS.c,120 :: 		current_cxt = main_cxt;
	MOVF        _main_cxt+0, 0 
	MOVWF       _current_cxt+0 
	MOVF        _main_cxt+1, 0 
	MOVWF       _current_cxt+1 
;TechRTOS.c,121 :: 		restore_context();
	MOVF        _current_cxt+0, 0 
	MOVWF       R0 
	MOVF        _current_cxt+1, 0 
	MOVWF       R1 
	MOVLW       2
	ADDWF       R0, 0 
	MOVWF       FSR0L+0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0L+1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVF        POSTINC0+0, 0 
	MOVWF       R4 
	MOVF        _current_cxt+0, 0 
	MOVWF       FSR2L+0 
	MOVF        _current_cxt+1, 0 
	MOVWF       FSR2L+1 
	MOVF        POSTINC2+0, 0 
	MOVWF       R1 
	MOVF        POSTINC2+0, 0 
	MOVWF       R2 
	MOVF        R4, 0 
	XORWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__run_cxt35
	MOVF        R1, 0 
	XORWF       R3, 0 
L__run_cxt35:
	BTFSS       STATUS+0, 2 
	GOTO        L_run_cxt19
	MOVF        _main_cxt+0, 0 
	MOVWF       _current_cxt+0 
	MOVF        _main_cxt+1, 0 
	MOVWF       _current_cxt+1 
L_run_cxt19:
	MOVF        _current_cxt+0, 0 
	MOVWF       R0 
	MOVF        _current_cxt+1, 0 
	MOVWF       R1 
	MOVLW       2
	ADDWF       R0, 0 
	MOVWF       FSR0L+0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0L+1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVF        POSTINC0+0, 0 
	MOVWF       R4 
	MOVLW       255
	ANDWF       R3, 0 
	MOVWF       FSR0L+0 
	MOVF        R4, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       255
	ANDWF       R0, 0 
	MOVWF       FSR0H+0 
	CLRF        STKPTR+0 
	MOVFF       POSTDEC0+0, FSR1L+0
L_run_cxt20:
	MOVF        FSR1L+0, 0 
	SUBWF       STKPTR+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_run_cxt21
	PUSH
	MOVF        POSTDEC0+0, 0, 0
	MOVWF       TOSL+0, 0
	MOVF        POSTDEC0+0, 0, 0
	MOVWF       TOSH+0, 0
	MOVF        POSTDEC0+0, 0, 0
	MOVWF       TOSU+0, 0
	GOTO        L_run_cxt20
L_run_cxt21:
	MOVFF       POSTDEC0+0, R20
	MOVFF       POSTDEC0+0, R19
	MOVFF       POSTDEC0+0, R18
	MOVFF       POSTDEC0+0, R17
	MOVFF       POSTDEC0+0, R16
	MOVFF       POSTDEC0+0, R15
	MOVFF       POSTDEC0+0, R14
	MOVFF       POSTDEC0+0, R13
	MOVFF       POSTDEC0+0, R12
	MOVFF       POSTDEC0+0, R11
	MOVFF       POSTDEC0+0, R10
	MOVFF       POSTDEC0+0, R9
	MOVFF       POSTDEC0+0, R8
	MOVFF       POSTDEC0+0, R7
	MOVFF       POSTDEC0+0, R6
	MOVFF       POSTDEC0+0, R5
	MOVFF       POSTDEC0+0, R4
	MOVFF       POSTDEC0+0, R3
	MOVFF       POSTDEC0+0, R2
	MOVFF       POSTDEC0+0, R1
	MOVFF       POSTDEC0+0, R0
	MOVFF       POSTDEC0+0, PCLATH+0
	MOVFF       POSTDEC0+0, PCLATU+0
	MOVFF       POSTDEC0+0, PRODL+0
	MOVFF       POSTDEC0+0, PRODH+0
	MOVFF       POSTDEC0+0, TBLPTRL+0
	MOVFF       POSTDEC0+0, TBLPTRH+0
	MOVFF       POSTDEC0+0, TBLPTRU+0
	MOVFF       POSTDEC0+0, TABLAT+0
	MOVFF       POSTDEC0+0, BSR+0
	MOVFF       POSTDEC0+0, STATUS+0
	MOVFF       POSTDEC0+0, WREG+0
	MOVFF       POSTDEC0+0, _tmp_data+5
	MOVFF       POSTDEC0+0, _tmp_data+4
	MOVFF       POSTDEC0+0, _tmp_data+3
	MOVFF       POSTDEC0+0, _tmp_data+2
	MOVFF       POSTDEC0+0, _tmp_data+1
	MOVFF       INDF0+0, _tmp_data+0
	MOVFF       _tmp_data+0, FSR0L+0
	MOVFF       _tmp_data+1, FSR0H+0
	MOVFF       _tmp_data+2, FSR1L+0
	MOVFF       _tmp_data+3, FSR1H+0
	MOVFF       _tmp_data+4, FSR2L+0
	MOVFF       _tmp_data+5, FSR2H+0
;TechRTOS.c,122 :: 		}
L_end_run_cxt:
	RETURN      0
; end of _run_cxt

_tech_run:

;TechRTOS.c,124 :: 		void tech_run()
;TechRTOS.c,126 :: 		list_foreach(cxtlist, &run_cxt);
	MOVF        _cxtlist+0, 0 
	MOVWF       FARG_list_foreach_list+0 
	MOVF        _cxtlist+1, 0 
	MOVWF       FARG_list_foreach_list+1 
	MOVLW       _run_cxt+0
	MOVWF       FARG_list_foreach_func+0 
	MOVLW       hi_addr(_run_cxt+0)
	MOVWF       FARG_list_foreach_func+1 
	MOVLW       FARG_run_cxt_param+0
	MOVWF       FARG_list_foreach_func+2 
	MOVLW       hi_addr(FARG_run_cxt_param+0)
	MOVWF       FARG_list_foreach_func+3 
	CALL        _list_foreach+0, 0
;TechRTOS.c,127 :: 		}
L_end_tech_run:
	RETURN      0
; end of _tech_run

_tech_cxt:

;TechRTOS.c,129 :: 		pcontext_t tech_cxt(void (*func)(void*), void* params, unsigned size)
;TechRTOS.c,131 :: 		pcontext_t p = (pcontext_t) Malloc(sizeof(context));
	MOVLW       16
	MOVWF       FARG_Malloc_Size+0 
	MOVLW       0
	MOVWF       FARG_Malloc_Size+1 
	CALL        _Malloc+0, 0
	MOVF        R0, 0 
	MOVWF       tech_cxt_p_L0+0 
	MOVF        R1, 0 
	MOVWF       tech_cxt_p_L0+1 
;TechRTOS.c,132 :: 		if (!p) return NULL;
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_tech_cxt22
	CLRF        R0 
	CLRF        R1 
	GOTO        L_end_tech_cxt
L_tech_cxt22:
;TechRTOS.c,134 :: 		p->stack_ptr = Malloc(CXT_MIN_SIZE+size);
	MOVF        tech_cxt_p_L0+0, 0 
	MOVWF       FLOC__tech_cxt+0 
	MOVF        tech_cxt_p_L0+1, 0 
	MOVWF       FLOC__tech_cxt+1 
	MOVLW       43
	ADDWF       FARG_tech_cxt_size+0, 0 
	MOVWF       FARG_Malloc_Size+0 
	MOVLW       0
	ADDWFC      FARG_tech_cxt_size+1, 0 
	MOVWF       FARG_Malloc_Size+1 
	CALL        _Malloc+0, 0
	MOVFF       FLOC__tech_cxt+0, FSR1L+0
	MOVFF       FLOC__tech_cxt+1, FSR1H+0
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
;TechRTOS.c,135 :: 		p->top_of_stack = p->stack_ptr;
	MOVLW       2
	ADDWF       tech_cxt_p_L0+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      tech_cxt_p_L0+1, 0 
	MOVWF       FSR1L+1 
	MOVFF       tech_cxt_p_L0+0, FSR0L+0
	MOVFF       tech_cxt_p_L0+1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
;TechRTOS.c,136 :: 		p->stack_size = size;
	MOVLW       4
	ADDWF       tech_cxt_p_L0+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      tech_cxt_p_L0+1, 0 
	MOVWF       FSR1L+1 
	MOVF        FARG_tech_cxt_size+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        FARG_tech_cxt_size+1, 0 
	MOVWF       POSTINC1+0 
;TechRTOS.c,137 :: 		p->func = func;
	MOVLW       6
	ADDWF       tech_cxt_p_L0+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      tech_cxt_p_L0+1, 0 
	MOVWF       FSR1L+1 
	MOVF        FARG_tech_cxt_func+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        FARG_tech_cxt_func+1, 0 
	MOVWF       POSTINC1+0 
	MOVF        FARG_tech_cxt_func+2, 0 
	MOVWF       POSTINC1+0 
	MOVF        FARG_tech_cxt_func+3, 0 
	MOVWF       POSTINC1+0 
;TechRTOS.c,138 :: 		p->params = params;
	MOVLW       10
	ADDWF       tech_cxt_p_L0+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      tech_cxt_p_L0+1, 0 
	MOVWF       FSR1L+1 
	MOVF        FARG_tech_cxt_params+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        FARG_tech_cxt_params+1, 0 
	MOVWF       POSTINC1+0 
;TechRTOS.c,140 :: 		list_insert(cxtlist, p);
	MOVF        _cxtlist+0, 0 
	MOVWF       FARG_list_insert_list+0 
	MOVF        _cxtlist+1, 0 
	MOVWF       FARG_list_insert_list+1 
	MOVF        tech_cxt_p_L0+0, 0 
	MOVWF       FARG_list_insert_pdata+0 
	MOVF        tech_cxt_p_L0+1, 0 
	MOVWF       FARG_list_insert_pdata+1 
	CALL        _list_insert+0, 0
;TechRTOS.c,141 :: 		return p;
	MOVF        tech_cxt_p_L0+0, 0 
	MOVWF       R0 
	MOVF        tech_cxt_p_L0+1, 0 
	MOVWF       R1 
;TechRTOS.c,142 :: 		}
L_end_tech_cxt:
	RETURN      0
; end of _tech_cxt

_tech_cxt_destroy:

;TechRTOS.c,144 :: 		void tech_cxt_destroy(pcontext_t cxt)
;TechRTOS.c,148 :: 		FreeMem((void*)cxt->stack_ptr, CXT_MIN_SIZE+cxt->stack_size);
	MOVFF       FARG_tech_cxt_destroy_cxt+0, FSR0L+0
	MOVFF       FARG_tech_cxt_destroy_cxt+1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_FreeMem_P+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_FreeMem_P+1 
	MOVLW       4
	ADDWF       FARG_tech_cxt_destroy_cxt+0, 0 
	MOVWF       FSR2L+0 
	MOVLW       0
	ADDWFC      FARG_tech_cxt_destroy_cxt+1, 0 
	MOVWF       FSR2L+1 
	MOVLW       43
	ADDWF       POSTINC2+0, 0 
	MOVWF       FARG_FreeMem_Size+0 
	MOVLW       0
	ADDWFC      POSTINC2+0, 0 
	MOVWF       FARG_FreeMem_Size+1 
	CALL        _FreeMem+0, 0
;TechRTOS.c,149 :: 		FreeMem((void*)cxt, sizeof(context));
	MOVF        FARG_tech_cxt_destroy_cxt+0, 0 
	MOVWF       FARG_FreeMem_P+0 
	MOVF        FARG_tech_cxt_destroy_cxt+1, 0 
	MOVWF       FARG_FreeMem_P+1 
	MOVLW       16
	MOVWF       FARG_FreeMem_Size+0 
	MOVLW       0
	MOVWF       FARG_FreeMem_Size+1 
	CALL        _FreeMem+0, 0
;TechRTOS.c,151 :: 		node = list_find(cxtlist, &context_equal, cxt);
	MOVF        _cxtlist+0, 0 
	MOVWF       FARG_list_find_list+0 
	MOVF        _cxtlist+1, 0 
	MOVWF       FARG_list_find_list+1 
	MOVLW       _context_equal+0
	MOVWF       FARG_list_find_func+0 
	MOVLW       hi_addr(_context_equal+0)
	MOVWF       FARG_list_find_func+1 
	MOVLW       FARG_context_equal_cxt1+0
	MOVWF       FARG_list_find_func+2 
	MOVLW       hi_addr(FARG_context_equal_cxt1+0)
	MOVWF       FARG_list_find_func+3 
	MOVF        FARG_tech_cxt_destroy_cxt+0, 0 
	MOVWF       FARG_list_find_pdata+0 
	MOVF        FARG_tech_cxt_destroy_cxt+1, 0 
	MOVWF       FARG_list_find_pdata+1 
	CALL        _list_find+0, 0
	MOVF        R0, 0 
	MOVWF       tech_cxt_destroy_node_L0+0 
	MOVF        R1, 0 
	MOVWF       tech_cxt_destroy_node_L0+1 
;TechRTOS.c,153 :: 		if (!node) return;
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_tech_cxt_destroy23
	GOTO        L_end_tech_cxt_destroy
L_tech_cxt_destroy23:
;TechRTOS.c,155 :: 		list_erase(cxtlist, node);
	MOVF        _cxtlist+0, 0 
	MOVWF       FARG_list_erase_list+0 
	MOVF        _cxtlist+1, 0 
	MOVWF       FARG_list_erase_list+1 
	MOVF        tech_cxt_destroy_node_L0+0, 0 
	MOVWF       FARG_list_erase_node+0 
	MOVF        tech_cxt_destroy_node_L0+1, 0 
	MOVWF       FARG_list_erase_node+1 
	CALL        _list_erase+0, 0
;TechRTOS.c,156 :: 		}
L_end_tech_cxt_destroy:
	RETURN      0
; end of _tech_cxt_destroy

_tech_set_cxt:

;TechRTOS.c,158 :: 		void tech_set_cxt(pcontext_t cxt)
;TechRTOS.c,160 :: 		current_cxt = cxt;
	MOVF        FARG_tech_set_cxt_cxt+0, 0 
	MOVWF       _current_cxt+0 
	MOVF        FARG_tech_set_cxt_cxt+1, 0 
	MOVWF       _current_cxt+1 
;TechRTOS.c,161 :: 		}
L_end_tech_set_cxt:
	RETURN      0
; end of _tech_set_cxt

_tech_cxtof_hook:

;TechRTOS.c,163 :: 		void tech_cxtof_hook(void (*func)(pcontext_t))
;TechRTOS.c,165 :: 		tech_stkof_hook = func;
	MOVF        FARG_tech_cxtof_hook_func+0, 0 
	MOVWF       _tech_stkof_hook+0 
	MOVF        FARG_tech_cxtof_hook_func+1, 0 
	MOVWF       _tech_stkof_hook+1 
	MOVF        FARG_tech_cxtof_hook_func+2, 0 
	MOVWF       _tech_stkof_hook+2 
	MOVF        FARG_tech_cxtof_hook_func+3, 0 
	MOVWF       _tech_stkof_hook+3 
;TechRTOS.c,166 :: 		}
L_end_tech_cxtof_hook:
	RETURN      0
; end of _tech_cxtof_hook

_tech_handle_crash:

;TechRTOS.c,168 :: 		void tech_handle_crash()
;TechRTOS.c,172 :: 		if (tech_stkof_hook) {
	MOVF        _tech_stkof_hook+0, 0 
	IORWF       _tech_stkof_hook+1, 0 
	IORWF       _tech_stkof_hook+2, 0 
	IORWF       _tech_stkof_hook+3, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_tech_handle_crash24
;TechRTOS.c,174 :: 		node = list_find(cxtlist, &context_equal, current_cxt);
	MOVF        _cxtlist+0, 0 
	MOVWF       FARG_list_find_list+0 
	MOVF        _cxtlist+1, 0 
	MOVWF       FARG_list_find_list+1 
	MOVLW       _context_equal+0
	MOVWF       FARG_list_find_func+0 
	MOVLW       hi_addr(_context_equal+0)
	MOVWF       FARG_list_find_func+1 
	MOVLW       FARG_context_equal_cxt1+0
	MOVWF       FARG_list_find_func+2 
	MOVLW       hi_addr(FARG_context_equal_cxt1+0)
	MOVWF       FARG_list_find_func+3 
	MOVF        _current_cxt+0, 0 
	MOVWF       FARG_list_find_pdata+0 
	MOVF        _current_cxt+1, 0 
	MOVWF       FARG_list_find_pdata+1 
	CALL        _list_find+0, 0
;TechRTOS.c,175 :: 		list_erase(cxtlist, node);
	MOVF        _cxtlist+0, 0 
	MOVWF       FARG_list_erase_list+0 
	MOVF        _cxtlist+1, 0 
	MOVWF       FARG_list_erase_list+1 
	MOVF        R0, 0 
	MOVWF       FARG_list_erase_node+0 
	MOVF        R1, 0 
	MOVWF       FARG_list_erase_node+1 
	CALL        _list_erase+0, 0
;TechRTOS.c,177 :: 		tech_stkof_hook(current_cxt);
	MOVF        _tech_stkof_hook+2, 0 
	MOVWF       FSR1+0 
	MOVF        _tech_stkof_hook+3, 0 
	MOVWF       FSR1+1 
	MOVF        _current_cxt+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        _current_cxt+1, 0 
	MOVWF       POSTINC1+0 
	MOVF        _tech_stkof_hook+0, 0 
	MOVWF       R0 
	MOVF        _tech_stkof_hook+1, 0 
	MOVWF       R1 
	CALL        _____DoIFC+0, 0
;TechRTOS.c,178 :: 		} else
	GOTO        L_tech_handle_crash25
L_tech_handle_crash24:
;TechRTOS.c,179 :: 		tech_cxt_destroy(current_cxt);
	MOVF        _current_cxt+0, 0 
	MOVWF       FARG_tech_cxt_destroy_cxt+0 
	MOVF        _current_cxt+1, 0 
	MOVWF       FARG_tech_cxt_destroy_cxt+1 
	CALL        _tech_cxt_destroy+0, 0
L_tech_handle_crash25:
;TechRTOS.c,182 :: 		current_cxt = main_cxt;
	MOVF        _main_cxt+0, 0 
	MOVWF       _current_cxt+0 
	MOVF        _main_cxt+1, 0 
	MOVWF       _current_cxt+1 
;TechRTOS.c,183 :: 		}
L_end_tech_handle_crash:
	RETURN      0
; end of _tech_handle_crash
