#ifndef __CXTSWITCHMACRO_H__
#define __CXTSWITCHMACRO_H__

#define CXT_MIN_SIZE 43
#define MAX_STACK_SIZE 31

#define push(t)                \
    {                          \
        asm MOVFF t, POSTINC0; \
    }

#define push_last(t)        \
    {                       \
        asm MOVFF t, INDF0; \
    }

#define pop(t)                 \
    {                          \
        asm MOVFF POSTDEC0, t; \
    }

#define pop_last(t)         \
    {                       \
        asm MOVFF INDF0, t; \
    }

#define push_hw(t)                                                \
    {                                                             \
        /* TOS registers can't be used as destination of MOVFF */ \
        asm MOVF POSTDEC0, 0, 0;                                  \
        asm MOVWF t, 0;                                           \
    }

#define point_to_stack()                   \
    {                                      \
        /* save FSR registers */           \
        asm MOVFF FSR0L, _tmp_data;        \
        asm MOVFF FSR0H, _tmp_data + 1;    \
        asm MOVFF FSR1L, _tmp_data + 2;    \
        asm MOVFF FSR1H, _tmp_data + 3;    \
        asm MOVFF FSR2L, _tmp_data + 4;    \
        asm MOVFF FSR2H, _tmp_data + 5;    \
                                           \
        asm MOVFF _current_cxt + 0, FSR1L; \
        asm MOVFF _current_cxt + 1, FSR1H; \
                                           \
        /* point to stack */               \
        asm MOVFF POSTINC1, FSR0L;         \
        asm MOVFF INDF1, FSR0H;            \
                                           \
        /* push FSR registers */           \
        push(_tmp_data);                   \
        push(_tmp_data + 1);               \
        push(_tmp_data + 2);               \
        push(_tmp_data + 3);               \
        push(_tmp_data + 4);               \
        push(_tmp_data + 5);               \
    }

#define save_top_of_stack()                \
    {                                      \
        /* save top of stack */            \
        asm MOVFF _current_cxt + 0, FSR1L; \
        asm MOVFF _current_cxt + 1, FSR1H; \
        asm MOVLW 0x2;                     \
        asm ADDWF FSR1L;                   \
        asm BTFSC STATUS;                  \
        asm INCFSZ FSR1H;                  \
                                           \
        asm MOVFF FSR0L, POSTINC1;         \
        asm MOVFF FSR0H, POSTINC1;         \
    }

#define restore_fsr()                   \
    {                                   \
        /* restore FSR registers */     \
        pop(_tmp_data + 5);             \
        pop(_tmp_data + 4);             \
        pop(_tmp_data + 3);             \
        pop(_tmp_data + 2);             \
        pop(_tmp_data + 1);             \
        pop_last(_tmp_data);            \
        asm MOVFF _tmp_data, FSR0L;     \
        asm MOVFF _tmp_data + 1, FSR0H; \
        asm MOVFF _tmp_data + 2, FSR1L; \
        asm MOVFF _tmp_data + 3, FSR1H; \
        asm MOVFF _tmp_data + 4, FSR2L; \
        asm MOVFF _tmp_data + 5, FSR2H; \
    }

#define saveStack()          \
    {                        \
        FSR1L = STKPTR;      \
                             \
        while (STKPTR)       \
        {                    \
            push(TOSU);      \
            push(TOSH);      \
            push(TOSL);      \
            asm POP;         \
        }                    \
                             \
        push_last(FSR1L);    \
        save_top_of_stack(); \
    }

#define check_stkof()                      \
    {                                      \
        asm MOVFF _current_cxt + 0, FSR2L; \
        asm MOVFF _current_cxt + 1, FSR2H; \
        asm MOVLW 0x4;                     \
        asm ADDWF FSR2L;                   \
        asm BTFSC STATUS;                  \
        asm INCFSZ FSR2H;                  \
                                           \
        if (INDF2 >= STKPTR)               \
        {                                  \
            saveStack();                   \
        }                                  \
        else                               \
        {                                  \
            tech_handle_crash();           \
        }                                  \
    }

#define restoreStack()         \
    {                          \
        STKPTR = 0;            \
        pop(FSR1L);            \
                               \
        while (STKPTR < FSR1L) \
        {                      \
            asm PUSH;          \
            push_hw(TOSL);     \
            push_hw(TOSH);     \
            push_hw(TOSU);     \
        }                      \
    }

#define save_context()                             \
    {                                              \
        /* point to our stack */                   \
        point_to_stack();                          \
                                                   \
        /* save WREG and STATUS registers first */ \
        push(WREG);                                \
        push(STATUS);                              \
                                                   \
        disableInt();                              \
        /* saving the other necessary registers */ \
        push(BSR);                                 \
        push(TABLAT);                              \
        push(TBLPTRU);                             \
        push(TBLPTRH);                             \
        push(TBLPTRL);                             \
        push(PRODH);                               \
        push(PRODL);                               \
        push(PCLATU);                              \
        push(PCLATH);                              \
                                                   \
        /* saving tmp and math data */             \
        push(R0);                                  \
        push(R1);                                  \
        push(R2);                                  \
        push(R3);                                  \
        push(R4);                                  \
        push(R5);                                  \
        push(R6);                                  \
        push(R7);                                  \
        push(R8);                                  \
        push(R9);                                  \
        push(R10);                                 \
        push(R11);                                 \
        push(R12);                                 \
        push(R13);                                 \
        push(R14);                                 \
        push(R15);                                 \
        push(R16);                                 \
        push(R17);                                 \
        push(R18);                                 \
        push(R19);                                 \
        push(R20);                                 \
                                                   \
        /* save stack content */                   \
        check_stkof()                              \
    }

#define restore_context()                                        \
    {                                                            \
        uint16 top_of_stack;                                     \
                                                                 \
        /* task probably finished it job */                      \
        if (current_cxt->top_of_stack == current_cxt->stack_ptr) \
            current_cxt = main_cxt;                              \
                                                                 \
        /* point to our stack */                                 \
        top_of_stack = current_cxt->top_of_stack;                \
                                                                 \
        FSR0L = top_of_stack & 0xff;                             \
        FSR0H = (top_of_stack >> 8) & 0xff;                      \
                                                                 \
        /* restore stack content */                              \
        restoreStack();                                          \
                                                                 \
        /* restore tmp and math data */                          \
        pop(R20);                                                \
        pop(R19);                                                \
        pop(R18);                                                \
        pop(R17);                                                \
        pop(R16);                                                \
        pop(R15);                                                \
        pop(R14);                                                \
        pop(R13);                                                \
        pop(R12);                                                \
        pop(R11);                                                \
        pop(R10);                                                \
        pop(R9);                                                 \
        pop(R8);                                                 \
        pop(R7);                                                 \
        pop(R6);                                                 \
        pop(R5);                                                 \
        pop(R4);                                                 \
        pop(R3);                                                 \
        pop(R2);                                                 \
        pop(R1);                                                 \
        pop(R0);                                                 \
                                                                 \
        /* restore other necessary registers */                  \
        pop(PCLATH);                                             \
        pop(PCLATU);                                             \
        pop(PRODL);                                              \
        pop(PRODH);                                              \
        pop(TBLPTRL);                                            \
        pop(TBLPTRH);                                            \
        pop(TBLPTRU);                                            \
        pop(TABLAT);                                             \
        pop(BSR);                                                \
                                                                 \
        /* restore STATUS and WREG */                            \
        pop(STATUS);                                             \
        pop(WREG);                                               \
                                                                 \
        /* restore FSR registers */                              \
        restore_fsr();                                           \
    }

#endif /* __CXTSWITCHMACRO_H__ */