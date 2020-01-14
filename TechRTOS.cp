#line 1 "X:/TechRTOS/TechRTOS.c"
#line 1 "x:/techrtos/techrtos.h"
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
#line 1 "x:/techrtos/assert.h"
#line 1 "x:/techrtos/memory.h"
#line 1 "x:/techrtos/map.h"
#line 1 "x:/techrtos/list.h"
#line 1 "x:/techrtos/types.h"
#line 31 "x:/techrtos/list.h"
typedef struct node_t {
 struct node_t* next;
 struct node_t* previous;
 void* pdata;
} node_t;

typedef node_t* pnode_t;

typedef struct list_t {
 pnode_t first;
 pnode_t last;
  unsigned int  size;
  unsigned int  node_type;
} list_t;

typedef struct list_t* plist_t;

plist_t list_new();
void list_destroy(plist_t list);
 unsigned int  list_size(plist_t list);
pnode_t list_begin(plist_t list);
pnode_t list_insert(plist_t list, void* pdata);
pnode_t list_insert_after(plist_t list, pnode_t node, void* pdata);
 unsigned char  list_erase(plist_t list, pnode_t node);
void list_foreach(plist_t list, void (*func)(void*));
pnode_t list_find(plist_t list, int (*func)(void*, void*), void* pdata);
#line 31 "x:/techrtos/map.h"
typedef struct hashnode_t {
 node_t node;
 void* value;
} hashnode_t;

typedef hashnode_t* phashnode_t;

typedef struct hashmap_t {
 plist_t* buckets;
  signed int  size;
  signed int  count;
  signed int  (*hash)(void*,  signed int );
  signed int  (*cmp)(void*, void*);
} hashmap_t;

typedef hashmap_t* phashmap_t;

phashmap_t map_create( unsigned int  size,  signed int  (*hash)(void*,  signed int ),  signed int  (*cmp)(void*, void*));
phashnode_t map_find(phashmap_t hm, void* key);
void map_insert(phashmap_t hm, void* key, void* value);
void map_foreach(phashmap_t hm, void (*func)(void*, void*));
void map_erase(phashmap_t hm, void* key);
void map_destroy(phashmap_t hm);
#line 31 "x:/techrtos/memory.h"
void tech_memory_init();
void* tech_malloc( unsigned long  size);
void* tech_calloc( unsigned long  value,  unsigned long  size);
void tech_free(void* ptr);
void* tech_realloc(void* ptr,  unsigned long  size);
void tech_freeAll();
#line 7 "x:/techrtos/techrtos.h"
typedef struct context
{
 volatile void *stack_ptr;
 volatile void *top_of_stack;
 unsigned stack_size;
 void (*func)(void *);
 void *params;
  unsigned long  ticks;
} context;

typedef struct context *pcontext_t;
#line 25 "x:/techrtos/techrtos.h"
void yield();
void tech_init();
void tech_drop();
void tech_run();
pcontext_t tech_cxt(void (*)(void *), void *, unsigned);
void tech_cxt_destroy(pcontext_t);
void tech_set_cxt(pcontext_t);
void tech_cxtof_hook(void (*)(pcontext_t));
#line 1 "x:/techrtos/cxtswitchmacro.h"
#line 29 "X:/TechRTOS/TechRTOS.c"
volatile pcontext_t current_cxt =  0 ;
volatile pcontext_t main_cxt =  0 ;
void (*tech_stkof_hook)(pcontext_t) =  0 ;
plist_t cxtlist =  0 ;

 unsigned char  tmp_data[6];

void tech_handle_crash();

int context_equal(void* cxt1, void* cxt2)
{
 if (cxt1 == cxt2)
 return 0;
 else return 1;
}

void yield()
{
 pnode_t node;
  { { asm MOVFF FSR0L, _tmp_data; asm MOVFF FSR0H, _tmp_data+1; asm MOVFF FSR1L, _tmp_data+2; asm MOVFF FSR1H, _tmp_data+3; asm MOVFF FSR2L, _tmp_data+4; asm MOVFF FSR2H, _tmp_data+5; asm MOVFF _current_cxt+0, FSR1L; asm MOVFF _current_cxt+1, FSR1H; asm MOVFF POSTINC1, FSR0L; asm MOVFF INDF1, FSR0H; { asm MOVFF _tmp_data, POSTINC0;} ; { asm MOVFF _tmp_data+1, POSTINC0;} ; { asm MOVFF _tmp_data+2, POSTINC0;} ; { asm MOVFF _tmp_data+3, POSTINC0;} ; { asm MOVFF _tmp_data+4, POSTINC0;} ; { asm MOVFF _tmp_data+5, POSTINC0;} ;} ; { asm MOVFF WREG, POSTINC0;} ; { asm MOVFF STATUS, POSTINC0;} ; INTCON.GIEH = 0; ; { asm MOVFF BSR, POSTINC0;} ; { asm MOVFF TABLAT, POSTINC0;} ; { asm MOVFF TBLPTRU, POSTINC0;} ; { asm MOVFF TBLPTRH, POSTINC0;} ; { asm MOVFF TBLPTRL, POSTINC0;} ; { asm MOVFF PRODH, POSTINC0;} ; { asm MOVFF PRODL, POSTINC0;} ; { asm MOVFF PCLATU, POSTINC0;} ; { asm MOVFF PCLATH, POSTINC0;} ; { asm MOVFF R0, POSTINC0;} ; { asm MOVFF R1, POSTINC0;} ; { asm MOVFF R2, POSTINC0;} ; { asm MOVFF R3, POSTINC0;} ; { asm MOVFF R4, POSTINC0;} ; { asm MOVFF R5, POSTINC0;} ; { asm MOVFF R6, POSTINC0;} ; { asm MOVFF R7, POSTINC0;} ; { asm MOVFF R8, POSTINC0;} ; { asm MOVFF R9, POSTINC0;} ; { asm MOVFF R10, POSTINC0;} ; { asm MOVFF R11, POSTINC0;} ; { asm MOVFF R12, POSTINC0;} ; { asm MOVFF R13, POSTINC0;} ; { asm MOVFF R14, POSTINC0;} ; { asm MOVFF R15, POSTINC0;} ; { asm MOVFF R16, POSTINC0;} ; { asm MOVFF R17, POSTINC0;} ; { asm MOVFF R18, POSTINC0;} ; { asm MOVFF R19, POSTINC0;} ; { asm MOVFF R20, POSTINC0;} ; { asm MOVFF _current_cxt+0, FSR2L; asm MOVFF _current_cxt+1, FSR2H; asm MOVLW 0x4; asm ADDWF FSR2L; asm BTFSC STATUS; asm INCFSZ FSR2H; if (INDF2 >= STKPTR) { { FSR1L = STKPTR; while (STKPTR) { { asm MOVFF TOSU, POSTINC0;} ; { asm MOVFF TOSH, POSTINC0;} ; { asm MOVFF TOSL, POSTINC0;} ; asm POP; } { asm MOVFF FSR1L, INDF0;} ; { asm MOVFF _current_cxt+0, FSR1L; asm MOVFF _current_cxt+1, FSR1H; asm MOVLW 0x2; asm ADDWF FSR1L; asm BTFSC STATUS; asm INCFSZ FSR1H; asm MOVFF FSR0L, POSTINC1; asm MOVFF FSR0H, POSTINC1;} ;} ; } else { tech_handle_crash(); }} } ;

 node = list_find(cxtlist, &context_equal, current_cxt);
 if (node && node->next)
 current_cxt = node->next->pdata;
 else if ((node = list_begin(cxtlist)))
 current_cxt = node->pdata;
 else current_cxt = main_cxt;

  { unsigned int  top_of_stack; if (current_cxt->top_of_stack == current_cxt->stack_ptr) current_cxt = main_cxt; top_of_stack = current_cxt->top_of_stack; FSR0L = top_of_stack & 0xff; FSR0H = (top_of_stack>>8) & 0xff; { STKPTR = 0; { asm MOVFF POSTDEC0, FSR1L;} ; while (STKPTR < FSR1L) { asm PUSH; { asm MOVF POSTDEC0, 0, 0; asm MOVWF TOSL, 0;} ; { asm MOVF POSTDEC0, 0, 0; asm MOVWF TOSH, 0;} ; { asm MOVF POSTDEC0, 0, 0; asm MOVWF TOSU, 0;} ; }} ; { asm MOVFF POSTDEC0, R20;} ; { asm MOVFF POSTDEC0, R19;} ; { asm MOVFF POSTDEC0, R18;} ; { asm MOVFF POSTDEC0, R17;} ; { asm MOVFF POSTDEC0, R16;} ; { asm MOVFF POSTDEC0, R15;} ; { asm MOVFF POSTDEC0, R14;} ; { asm MOVFF POSTDEC0, R13;} ; { asm MOVFF POSTDEC0, R12;} ; { asm MOVFF POSTDEC0, R11;} ; { asm MOVFF POSTDEC0, R10;} ; { asm MOVFF POSTDEC0, R9;} ; { asm MOVFF POSTDEC0, R8;} ; { asm MOVFF POSTDEC0, R7;} ; { asm MOVFF POSTDEC0, R6;} ; { asm MOVFF POSTDEC0, R5;} ; { asm MOVFF POSTDEC0, R4;} ; { asm MOVFF POSTDEC0, R3;} ; { asm MOVFF POSTDEC0, R2;} ; { asm MOVFF POSTDEC0, R1;} ; { asm MOVFF POSTDEC0, R0;} ; { asm MOVFF POSTDEC0, PCLATH;} ; { asm MOVFF POSTDEC0, PCLATU;} ; { asm MOVFF POSTDEC0, PRODL;} ; { asm MOVFF POSTDEC0, PRODH;} ; { asm MOVFF POSTDEC0, TBLPTRL;} ; { asm MOVFF POSTDEC0, TBLPTRH;} ; { asm MOVFF POSTDEC0, TBLPTRU;} ; { asm MOVFF POSTDEC0, TABLAT;} ; { asm MOVFF POSTDEC0, BSR;} ; { asm MOVFF POSTDEC0, STATUS;} ; { asm MOVFF POSTDEC0, WREG;} ; { { asm MOVFF POSTDEC0, _tmp_data+5;} ; { asm MOVFF POSTDEC0, _tmp_data+4;} ; { asm MOVFF POSTDEC0, _tmp_data+3;} ; { asm MOVFF POSTDEC0, _tmp_data+2;} ; { asm MOVFF POSTDEC0, _tmp_data+1;} ; { asm MOVFF INDF0, _tmp_data;} ; asm MOVFF _tmp_data, FSR0L; asm MOVFF _tmp_data+1, FSR0H; asm MOVFF _tmp_data+2, FSR1L; asm MOVFF _tmp_data+3, FSR1H; asm MOVFF _tmp_data+4, FSR2L; asm MOVFF _tmp_data+5, FSR2H;} ;} ;

  INTCON.GIEH = 1; ;
}

void tech_init()
{
 tech_memory_init();
 tech_timerSysInit();
 main_cxt = tech_cxt( 0 ,  0 ,  31 );
 current_cxt = main_cxt;

 cxtlist = list_new();
}

void tech_drop()
{
 list_destroy(cxtlist);
 tech_freeAll();
}

void tech_safe_call()
{
 _asm {
 PUSH

 MOVFF _current_cxt+0, FSR1L
 MOVFF _current_cxt+1, FSR1H
 MOVLW 6
 ADDWF FSR1L
 BTFSC STATUS
 INCFSZ FSR1H

 MOVF POSTINC1, 0, 0
 MOVWF TOSL, 0
 MOVF POSTINC1, 0, 0
 MOVWF TOSH, 0
 CLRF TOSU, 0

 MOVFF POSTINC1, FSR0L
 MOVFF POSTINC1, FSR0H

 MOVFF POSTINC1, POSTINC0
 MOVFF INDF1, INDF0
 }

  INTCON.GIEH = 1; ;
}

void run_cxt(void* param)
{
 pcontext_t cxt = (pcontext_t) param;


  { { asm MOVFF FSR0L, _tmp_data; asm MOVFF FSR0H, _tmp_data+1; asm MOVFF FSR1L, _tmp_data+2; asm MOVFF FSR1H, _tmp_data+3; asm MOVFF FSR2L, _tmp_data+4; asm MOVFF FSR2H, _tmp_data+5; asm MOVFF _current_cxt+0, FSR1L; asm MOVFF _current_cxt+1, FSR1H; asm MOVFF POSTINC1, FSR0L; asm MOVFF INDF1, FSR0H; { asm MOVFF _tmp_data, POSTINC0;} ; { asm MOVFF _tmp_data+1, POSTINC0;} ; { asm MOVFF _tmp_data+2, POSTINC0;} ; { asm MOVFF _tmp_data+3, POSTINC0;} ; { asm MOVFF _tmp_data+4, POSTINC0;} ; { asm MOVFF _tmp_data+5, POSTINC0;} ;} ; { asm MOVFF WREG, POSTINC0;} ; { asm MOVFF STATUS, POSTINC0;} ; INTCON.GIEH = 0; ; { asm MOVFF BSR, POSTINC0;} ; { asm MOVFF TABLAT, POSTINC0;} ; { asm MOVFF TBLPTRU, POSTINC0;} ; { asm MOVFF TBLPTRH, POSTINC0;} ; { asm MOVFF TBLPTRL, POSTINC0;} ; { asm MOVFF PRODH, POSTINC0;} ; { asm MOVFF PRODL, POSTINC0;} ; { asm MOVFF PCLATU, POSTINC0;} ; { asm MOVFF PCLATH, POSTINC0;} ; { asm MOVFF R0, POSTINC0;} ; { asm MOVFF R1, POSTINC0;} ; { asm MOVFF R2, POSTINC0;} ; { asm MOVFF R3, POSTINC0;} ; { asm MOVFF R4, POSTINC0;} ; { asm MOVFF R5, POSTINC0;} ; { asm MOVFF R6, POSTINC0;} ; { asm MOVFF R7, POSTINC0;} ; { asm MOVFF R8, POSTINC0;} ; { asm MOVFF R9, POSTINC0;} ; { asm MOVFF R10, POSTINC0;} ; { asm MOVFF R11, POSTINC0;} ; { asm MOVFF R12, POSTINC0;} ; { asm MOVFF R13, POSTINC0;} ; { asm MOVFF R14, POSTINC0;} ; { asm MOVFF R15, POSTINC0;} ; { asm MOVFF R16, POSTINC0;} ; { asm MOVFF R17, POSTINC0;} ; { asm MOVFF R18, POSTINC0;} ; { asm MOVFF R19, POSTINC0;} ; { asm MOVFF R20, POSTINC0;} ; { asm MOVFF _current_cxt+0, FSR2L; asm MOVFF _current_cxt+1, FSR2H; asm MOVLW 0x4; asm ADDWF FSR2L; asm BTFSC STATUS; asm INCFSZ FSR2H; if (INDF2 >= STKPTR) { { FSR1L = STKPTR; while (STKPTR) { { asm MOVFF TOSU, POSTINC0;} ; { asm MOVFF TOSH, POSTINC0;} ; { asm MOVFF TOSL, POSTINC0;} ; asm POP; } { asm MOVFF FSR1L, INDF0;} ; { asm MOVFF _current_cxt+0, FSR1L; asm MOVFF _current_cxt+1, FSR1H; asm MOVLW 0x2; asm ADDWF FSR1L; asm BTFSC STATUS; asm INCFSZ FSR1H; asm MOVFF FSR0L, POSTINC1; asm MOVFF FSR0H, POSTINC1;} ;} ; } else { tech_handle_crash(); }} } ;


 current_cxt = cxt;
 tech_safe_call();


  INTCON.GIEH = 0; ;
 tech_cxt_destroy(current_cxt);
 current_cxt = main_cxt;
  { unsigned int  top_of_stack; if (current_cxt->top_of_stack == current_cxt->stack_ptr) current_cxt = main_cxt; top_of_stack = current_cxt->top_of_stack; FSR0L = top_of_stack & 0xff; FSR0H = (top_of_stack>>8) & 0xff; { STKPTR = 0; { asm MOVFF POSTDEC0, FSR1L;} ; while (STKPTR < FSR1L) { asm PUSH; { asm MOVF POSTDEC0, 0, 0; asm MOVWF TOSL, 0;} ; { asm MOVF POSTDEC0, 0, 0; asm MOVWF TOSH, 0;} ; { asm MOVF POSTDEC0, 0, 0; asm MOVWF TOSU, 0;} ; }} ; { asm MOVFF POSTDEC0, R20;} ; { asm MOVFF POSTDEC0, R19;} ; { asm MOVFF POSTDEC0, R18;} ; { asm MOVFF POSTDEC0, R17;} ; { asm MOVFF POSTDEC0, R16;} ; { asm MOVFF POSTDEC0, R15;} ; { asm MOVFF POSTDEC0, R14;} ; { asm MOVFF POSTDEC0, R13;} ; { asm MOVFF POSTDEC0, R12;} ; { asm MOVFF POSTDEC0, R11;} ; { asm MOVFF POSTDEC0, R10;} ; { asm MOVFF POSTDEC0, R9;} ; { asm MOVFF POSTDEC0, R8;} ; { asm MOVFF POSTDEC0, R7;} ; { asm MOVFF POSTDEC0, R6;} ; { asm MOVFF POSTDEC0, R5;} ; { asm MOVFF POSTDEC0, R4;} ; { asm MOVFF POSTDEC0, R3;} ; { asm MOVFF POSTDEC0, R2;} ; { asm MOVFF POSTDEC0, R1;} ; { asm MOVFF POSTDEC0, R0;} ; { asm MOVFF POSTDEC0, PCLATH;} ; { asm MOVFF POSTDEC0, PCLATU;} ; { asm MOVFF POSTDEC0, PRODL;} ; { asm MOVFF POSTDEC0, PRODH;} ; { asm MOVFF POSTDEC0, TBLPTRL;} ; { asm MOVFF POSTDEC0, TBLPTRH;} ; { asm MOVFF POSTDEC0, TBLPTRU;} ; { asm MOVFF POSTDEC0, TABLAT;} ; { asm MOVFF POSTDEC0, BSR;} ; { asm MOVFF POSTDEC0, STATUS;} ; { asm MOVFF POSTDEC0, WREG;} ; { { asm MOVFF POSTDEC0, _tmp_data+5;} ; { asm MOVFF POSTDEC0, _tmp_data+4;} ; { asm MOVFF POSTDEC0, _tmp_data+3;} ; { asm MOVFF POSTDEC0, _tmp_data+2;} ; { asm MOVFF POSTDEC0, _tmp_data+1;} ; { asm MOVFF INDF0, _tmp_data;} ; asm MOVFF _tmp_data, FSR0L; asm MOVFF _tmp_data+1, FSR0H; asm MOVFF _tmp_data+2, FSR1L; asm MOVFF _tmp_data+3, FSR1H; asm MOVFF _tmp_data+4, FSR2L; asm MOVFF _tmp_data+5, FSR2H;} ;} ;
}

void tech_run()
{
 list_foreach(cxtlist, &run_cxt);
}

pcontext_t tech_cxt(void (*func)(void*), void* params, unsigned size)
{
 pcontext_t p = (pcontext_t) Malloc(sizeof(context));
 if (!p) return  0 ;

 p->stack_ptr = Malloc( 43 +size);
 p->top_of_stack = p->stack_ptr;
 p->stack_size = size;
 p->func = func;
 p->params = params;

 list_insert(cxtlist, p);
 return p;
}

void tech_cxt_destroy(pcontext_t cxt)
{
 pnode_t node;

 FreeMem((void*)cxt->stack_ptr,  43 +cxt->stack_size);
 FreeMem((void*)cxt, sizeof(context));

 node = list_find(cxtlist, &context_equal, cxt);

 if (!node) return;

 list_erase(cxtlist, node);
}

void tech_set_cxt(pcontext_t cxt)
{
 current_cxt = cxt;
}

void tech_cxtof_hook(void (*func)(pcontext_t))
{
 tech_stkof_hook = func;
}

void tech_handle_crash()
{
 pnode_t node;

 if (tech_stkof_hook) {

 node = list_find(cxtlist, &context_equal, current_cxt);
 list_erase(cxtlist, node);

 tech_stkof_hook(current_cxt);
 } else
 tech_cxt_destroy(current_cxt);


 current_cxt = main_cxt;
}
