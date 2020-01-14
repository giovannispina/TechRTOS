
_Lcd_Clr_Line:

;MyProject.c,21 :: 		void Lcd_Clr_Line(uint8 line)
;MyProject.c,23 :: 		Lcd_Out(line, 1, "                ");
	MOVF        FARG_Lcd_Clr_Line_line+0, 0 
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_MyProject+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_MyProject+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;MyProject.c,24 :: 		}
L_end_Lcd_Clr_Line:
	RETURN      0
; end of _Lcd_Clr_Line

_strlen_rom:

;MyProject.c,26 :: 		int16 strlen_rom(const char *text)
;MyProject.c,29 :: 		for (i = 0; text[i] != '\0'; i++)
	CLRF        R2 
	CLRF        R3 
L_strlen_rom0:
	MOVF        R2, 0 
	ADDWF       FARG_strlen_rom_text+0, 0 
	MOVWF       TBLPTR+0 
	MOVF        R3, 0 
	ADDWFC      FARG_strlen_rom_text+1, 0 
	MOVWF       TBLPTR+1 
	MOVLW       0
	BTFSC       R3, 7 
	MOVLW       255
	ADDWFC      FARG_strlen_rom_text+2, 0 
	MOVWF       TBLPTR+2 
	TBLRD*+
	MOVFF       TABLAT+0, R1
	MOVF        R1, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_strlen_rom1
	INFSNZ      R2, 1 
	INCF        R3, 1 
;MyProject.c,30 :: 		;
	GOTO        L_strlen_rom0
L_strlen_rom1:
;MyProject.c,32 :: 		return i;
	MOVF        R2, 0 
	MOVWF       R0 
	MOVF        R3, 0 
	MOVWF       R1 
;MyProject.c,33 :: 		}
L_end_strlen_rom:
	RETURN      0
; end of _strlen_rom

_strcpy_rom:

;MyProject.c,35 :: 		void strcpy_rom(char *dest, const char *src)
;MyProject.c,38 :: 		for (i = 0; (dest[i] = src[i]) != '\0'; i++)
	CLRF        R3 
L_strcpy_rom3:
	MOVF        R3, 0 
	ADDWF       FARG_strcpy_rom_dest+0, 0 
	MOVWF       R1 
	MOVLW       0
	ADDWFC      FARG_strcpy_rom_dest+1, 0 
	MOVWF       R2 
	MOVF        R3, 0 
	ADDWF       FARG_strcpy_rom_src+0, 0 
	MOVWF       TBLPTR+0 
	MOVLW       0
	ADDWFC      FARG_strcpy_rom_src+1, 0 
	MOVWF       TBLPTR+1 
	MOVLW       0
	ADDWFC      FARG_strcpy_rom_src+2, 0 
	MOVWF       TBLPTR+2 
	TBLRD*+
	MOVFF       TABLAT+0, R0
	MOVFF       R1, FSR1L+0
	MOVFF       R2, FSR1H+0
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVFF       R1, FSR0L+0
	MOVFF       R2, FSR0H+0
	MOVF        POSTINC0+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_strcpy_rom4
	INCF        R3, 1 
;MyProject.c,39 :: 		;
	GOTO        L_strcpy_rom3
L_strcpy_rom4:
;MyProject.c,40 :: 		}
L_end_strcpy_rom:
	RETURN      0
; end of _strcpy_rom

_Lcd_OutText:

;MyProject.c,42 :: 		void Lcd_OutText(uint8 var, char *text)
;MyProject.c,44 :: 		if (var)
	MOVF        FARG_Lcd_OutText_var+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Lcd_OutText6
;MyProject.c,45 :: 		Lcd_Out(2, 1, text);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVF        FARG_Lcd_OutText_text+0, 0 
	MOVWF       FARG_Lcd_Out_text+0 
	MOVF        FARG_Lcd_OutText_text+1, 0 
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	GOTO        L_Lcd_OutText7
L_Lcd_OutText6:
;MyProject.c,47 :: 		Lcd_Clr_Line(2);
	MOVLW       2
	MOVWF       FARG_Lcd_Clr_Line_line+0 
	CALL        _Lcd_Clr_Line+0, 0
L_Lcd_OutText7:
;MyProject.c,48 :: 		}
L_end_Lcd_OutText:
	RETURN      0
; end of _Lcd_OutText

_task1:

;MyProject.c,50 :: 		void task1(void *params)
;MyProject.c,52 :: 		uint8 *var = (uint8 *)params;
	MOVF        FARG_task1_params+0, 0 
	MOVWF       task1_var_L0+0 
	MOVF        FARG_task1_params+1, 0 
	MOVWF       task1_var_L0+1 
;MyProject.c,59 :: 		text = tech_malloc((strlen_rom(text_rom) + 1) * sizeof(char));
	MOVLW       task1_text_rom_L0+0
	MOVWF       FARG_strlen_rom_text+0 
	MOVLW       hi_addr(task1_text_rom_L0+0)
	MOVWF       FARG_strlen_rom_text+1 
	MOVLW       higher_addr(task1_text_rom_L0+0)
	MOVWF       FARG_strlen_rom_text+2 
	CALL        _strlen_rom+0, 0
	MOVLW       1
	ADDWF       R0, 0 
	MOVWF       FARG_tech_malloc_size+0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FARG_tech_malloc_size+1 
	MOVLW       0
	BTFSC       FARG_tech_malloc_size+1, 7 
	MOVLW       255
	MOVWF       FARG_tech_malloc_size+2 
	MOVWF       FARG_tech_malloc_size+3 
	CALL        _tech_malloc+0, 0
	MOVF        R0, 0 
	MOVWF       task1_text_L0+0 
	MOVF        R1, 0 
	MOVWF       task1_text_L0+1 
;MyProject.c,60 :: 		strcpy_rom(text, text_rom);
	MOVF        R0, 0 
	MOVWF       FARG_strcpy_rom_dest+0 
	MOVF        R1, 0 
	MOVWF       FARG_strcpy_rom_dest+1 
	MOVLW       task1_text_rom_L0+0
	MOVWF       FARG_strcpy_rom_src+0 
	MOVLW       hi_addr(task1_text_rom_L0+0)
	MOVWF       FARG_strcpy_rom_src+1 
	MOVLW       higher_addr(task1_text_rom_L0+0)
	MOVWF       FARG_strcpy_rom_src+2 
	CALL        _strcpy_rom+0, 0
;MyProject.c,62 :: 		website = tech_malloc((strlen_rom(website_rom) + 1) * sizeof(char));
	MOVLW       task1_website_rom_L0+0
	MOVWF       FARG_strlen_rom_text+0 
	MOVLW       hi_addr(task1_website_rom_L0+0)
	MOVWF       FARG_strlen_rom_text+1 
	MOVLW       higher_addr(task1_website_rom_L0+0)
	MOVWF       FARG_strlen_rom_text+2 
	CALL        _strlen_rom+0, 0
	MOVLW       1
	ADDWF       R0, 0 
	MOVWF       FARG_tech_malloc_size+0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FARG_tech_malloc_size+1 
	MOVLW       0
	BTFSC       FARG_tech_malloc_size+1, 7 
	MOVLW       255
	MOVWF       FARG_tech_malloc_size+2 
	MOVWF       FARG_tech_malloc_size+3 
	CALL        _tech_malloc+0, 0
	MOVF        R0, 0 
	MOVWF       task1_website_L0+0 
	MOVF        R1, 0 
	MOVWF       task1_website_L0+1 
;MyProject.c,63 :: 		strcpy_rom(website, website_rom);
	MOVF        R0, 0 
	MOVWF       FARG_strcpy_rom_dest+0 
	MOVF        R1, 0 
	MOVWF       FARG_strcpy_rom_dest+1 
	MOVLW       task1_website_rom_L0+0
	MOVWF       FARG_strcpy_rom_src+0 
	MOVLW       hi_addr(task1_website_rom_L0+0)
	MOVWF       FARG_strcpy_rom_src+1 
	MOVLW       higher_addr(task1_website_rom_L0+0)
	MOVWF       FARG_strcpy_rom_src+2 
	CALL        _strcpy_rom+0, 0
;MyProject.c,65 :: 		for (;; yield())
L_task18:
;MyProject.c,67 :: 		Lcd_OutText(*var, website);
	MOVFF       task1_var_L0+0, FSR0L+0
	MOVFF       task1_var_L0+1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_Lcd_OutText_var+0 
	MOVF        task1_website_L0+0, 0 
	MOVWF       FARG_Lcd_OutText_text+0 
	MOVF        task1_website_L0+1, 0 
	MOVWF       FARG_Lcd_OutText_text+1 
	CALL        _Lcd_OutText+0, 0
;MyProject.c,68 :: 		Lcd_Out(1, 1, text);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVF        task1_text_L0+0, 0 
	MOVWF       FARG_Lcd_Out_text+0 
	MOVF        task1_text_L0+1, 0 
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;MyProject.c,65 :: 		for (;; yield())
	CALL        _yield+0, 0
;MyProject.c,69 :: 		}
	GOTO        L_task18
;MyProject.c,70 :: 		}
L_end_task1:
	RETURN      0
; end of _task1

_task2:

;MyProject.c,72 :: 		void task2(void *params)
;MyProject.c,74 :: 		uint8 *var = (uint8 *)params;
	MOVF        FARG_task2_params+0, 0 
	MOVWF       task2_var_L0+0 
	MOVF        FARG_task2_params+1, 0 
	MOVWF       task2_var_L0+1 
;MyProject.c,77 :: 		ticks = tech_getTicks();
	CALL        _tech_getTicks+0, 0
	MOVF        R0, 0 
	MOVWF       task2_ticks_L0+0 
	MOVF        R1, 0 
	MOVWF       task2_ticks_L0+1 
	MOVF        R2, 0 
	MOVWF       task2_ticks_L0+2 
	MOVF        R3, 0 
	MOVWF       task2_ticks_L0+3 
;MyProject.c,78 :: 		for (;;)
L_task211:
;MyProject.c,80 :: 		current = tech_getTicks();
	CALL        _tech_getTicks+0, 0
	MOVF        R0, 0 
	MOVWF       task2_current_L0+0 
	MOVF        R1, 0 
	MOVWF       task2_current_L0+1 
	MOVF        R2, 0 
	MOVWF       task2_current_L0+2 
	MOVF        R3, 0 
	MOVWF       task2_current_L0+3 
;MyProject.c,82 :: 		if (current - ticks > 1000)
	MOVF        R0, 0 
	MOVWF       R4 
	MOVF        R1, 0 
	MOVWF       R5 
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
	MOVF        task2_ticks_L0+0, 0 
	SUBWF       R4, 1 
	MOVF        task2_ticks_L0+1, 0 
	SUBWFB      R5, 1 
	MOVF        task2_ticks_L0+2, 0 
	SUBWFB      R6, 1 
	MOVF        task2_ticks_L0+3, 0 
	SUBWFB      R7, 1 
	MOVF        R7, 0 
	SUBLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__task222
	MOVF        R6, 0 
	SUBLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__task222
	MOVF        R5, 0 
	SUBLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L__task222
	MOVF        R4, 0 
	SUBLW       232
L__task222:
	BTFSC       STATUS+0, 0 
	GOTO        L_task214
;MyProject.c,84 :: 		ticks = current;
	MOVF        task2_current_L0+0, 0 
	MOVWF       task2_ticks_L0+0 
	MOVF        task2_current_L0+1, 0 
	MOVWF       task2_ticks_L0+1 
	MOVF        task2_current_L0+2, 0 
	MOVWF       task2_ticks_L0+2 
	MOVF        task2_current_L0+3, 0 
	MOVWF       task2_ticks_L0+3 
;MyProject.c,85 :: 		*var = !*var;
	MOVFF       task2_var_L0+0, FSR0L+0
	MOVFF       task2_var_L0+1, FSR0H+0
	MOVFF       task2_var_L0+0, FSR1L+0
	MOVFF       task2_var_L0+1, FSR1H+0
	MOVF        POSTINC0+0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       POSTINC1+0 
;MyProject.c,86 :: 		yield();
	CALL        _yield+0, 0
;MyProject.c,87 :: 		}
L_task214:
;MyProject.c,88 :: 		}
	GOTO        L_task211
;MyProject.c,89 :: 		}
L_end_task2:
	RETURN      0
; end of _task2

_interrupt:

;MyProject.c,91 :: 		void interrupt()
;MyProject.c,93 :: 		if (INTCON.T0IF)
	BTFSS       INTCON+0, 2 
	GOTO        L_interrupt15
;MyProject.c,95 :: 		tech_timer();
	CALL        _tech_timer+0, 0
;MyProject.c,97 :: 		INTCON.TMR0IE = 1;
	BSF         INTCON+0, 5 
;MyProject.c,98 :: 		INTCON.T0IF = 0;
	BCF         INTCON+0, 2 
;MyProject.c,99 :: 		TMR0L = 56;
	MOVLW       56
	MOVWF       TMR0L+0 
;MyProject.c,100 :: 		}
L_interrupt15:
;MyProject.c,101 :: 		}
L_end_interrupt:
L__interrupt24:
	RETFIE      1
; end of _interrupt

_main:

;MyProject.c,103 :: 		void main()
;MyProject.c,111 :: 		TMR0L = 56;
	MOVLW       56
	MOVWF       TMR0L+0 
;MyProject.c,112 :: 		TMR0H = 0;
	CLRF        TMR0H+0 
;MyProject.c,113 :: 		T0CON.PSA = 1;
	BSF         T0CON+0, 3 
;MyProject.c,114 :: 		T0CON.T0PS0 = 0;
	BCF         T0CON+0, 0 
;MyProject.c,115 :: 		T0CON.T0PS1 = 0;
	BCF         T0CON+0, 1 
;MyProject.c,116 :: 		T0CON.T0PS2 = 0;
	BCF         T0CON+0, 2 
;MyProject.c,117 :: 		T0CON.T0CS = 0;
	BCF         T0CON+0, 5 
;MyProject.c,118 :: 		T0CON.T0SE = 0;
	BCF         T0CON+0, 4 
;MyProject.c,119 :: 		T0CON.T08BIT = 1;
	BSF         T0CON+0, 6 
;MyProject.c,122 :: 		tech_init();
	CALL        _tech_init+0, 0
;MyProject.c,123 :: 		tech_setInc(100); // 100 us
	MOVLW       100
	MOVWF       FARG_tech_setInc+0 
	MOVLW       0
	MOVWF       FARG_tech_setInc+1 
	MOVWF       FARG_tech_setInc+2 
	MOVWF       FARG_tech_setInc+3 
	CALL        _tech_setInc+0, 0
;MyProject.c,126 :: 		T0CON.TMR0ON = 1;
	BSF         T0CON+0, 7 
;MyProject.c,127 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;MyProject.c,128 :: 		INTCON.TMR0IE = 1;
	BSF         INTCON+0, 5 
;MyProject.c,129 :: 		INTCON.T0IF = 0;
	BCF         INTCON+0, 2 
;MyProject.c,131 :: 		Lcd_Init();
	CALL        _Lcd_Init+0, 0
;MyProject.c,132 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;MyProject.c,133 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;MyProject.c,135 :: 		resource = 1;
	MOVLW       1
	MOVWF       main_resource_L0+0 
;MyProject.c,137 :: 		p1 = tech_cxt(&task1, &resource, 5);
	MOVLW       _task1+0
	MOVWF       FARG_tech_cxt+0 
	MOVLW       hi_addr(_task1+0)
	MOVWF       FARG_tech_cxt+1 
	MOVLW       FARG_task1_params+0
	MOVWF       FARG_tech_cxt+2 
	MOVLW       hi_addr(FARG_task1_params+0)
	MOVWF       FARG_tech_cxt+3 
	MOVLW       main_resource_L0+0
	MOVWF       FARG_tech_cxt+0 
	MOVLW       hi_addr(main_resource_L0+0)
	MOVWF       FARG_tech_cxt+1 
	MOVLW       5
	MOVWF       FARG_tech_cxt+0 
	MOVLW       0
	MOVWF       FARG_tech_cxt+1 
	CALL        _tech_cxt+0, 0
;MyProject.c,138 :: 		p2 = tech_cxt(&task2, &resource, 5);
	MOVLW       _task2+0
	MOVWF       FARG_tech_cxt+0 
	MOVLW       hi_addr(_task2+0)
	MOVWF       FARG_tech_cxt+1 
	MOVLW       FARG_task2_params+0
	MOVWF       FARG_tech_cxt+2 
	MOVLW       hi_addr(FARG_task2_params+0)
	MOVWF       FARG_tech_cxt+3 
	MOVLW       main_resource_L0+0
	MOVWF       FARG_tech_cxt+0 
	MOVLW       hi_addr(main_resource_L0+0)
	MOVWF       FARG_tech_cxt+1 
	MOVLW       5
	MOVWF       FARG_tech_cxt+0 
	MOVLW       0
	MOVWF       FARG_tech_cxt+1 
	CALL        _tech_cxt+0, 0
;MyProject.c,140 :: 		tech_run();
	CALL        _tech_run+0, 0
;MyProject.c,141 :: 		tech_drop();
	CALL        _tech_drop+0, 0
;MyProject.c,142 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
