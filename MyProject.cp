#line 1 "X:/TechRTOS/MyProject.c"
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
#line 7 "x:/techrtos/timersys.h"
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
void tech_gettimeofday(timeval_t *);
 unsigned long  tech_getTicks();
 unsigned long  tech_time(time_t *);
 unsigned char  tech_weekday();
const char *tech_getMonth( unsigned char );
void tech_setTime(time_t *);
#line 1 "x:/techrtos/assert.h"
#line 1 "x:/techrtos/memory.h"
#line 1 "x:/techrtos/map.h"
#line 1 "x:/techrtos/list.h"
#line 1 "x:/techrtos/types.h"
#line 6 "x:/techrtos/list.h"
typedef struct node_t
{
 struct node_t *next;
 struct node_t *previous;
 void *pdata;
} node_t;

typedef node_t *pnode_t;

typedef struct list_t
{
 pnode_t first;
 pnode_t last;
  unsigned int  size;
  unsigned int  node_type;
} list_t;

typedef struct list_t *plist_t;

plist_t list_new();
void list_destroy(plist_t list);
 unsigned int  list_size(plist_t list);
pnode_t list_begin(plist_t list);
pnode_t list_insert(plist_t list, void *pdata);
pnode_t list_insert_after(plist_t list, pnode_t node, void *pdata);
 unsigned char  list_erase(plist_t list, pnode_t node);
void list_foreach(plist_t list, void (*func)(void *));
pnode_t list_find(plist_t list, int (*func)(void *, void *), void *pdata);
#line 6 "x:/techrtos/map.h"
typedef struct hashnode_t
{
 node_t node;
 void *value;
} hashnode_t;

typedef hashnode_t *phashnode_t;

typedef struct hashmap_t
{
 plist_t *buckets;
  signed int  size;
  signed int  count;
  signed int  (*hash)(void *,  signed int );
  signed int  (*cmp)(void *, void *);
} hashmap_t;

typedef hashmap_t *phashmap_t;

phashmap_t map_create( unsigned int  size,  signed int  (*hash)(void *,  signed int ),  signed int  (*cmp)(void *, void *));
phashnode_t map_find(phashmap_t hm, void *key);
void map_insert(phashmap_t hm, void *key, void *value);
void map_foreach(phashmap_t hm, void (*func)(void *, void *));
void map_erase(phashmap_t hm, void *key);
void map_destroy(phashmap_t hm);
#line 6 "x:/techrtos/memory.h"
void tech_memory_init();
void *tech_malloc( unsigned long  size);
void *tech_calloc( unsigned long  value,  unsigned long  size);
void tech_free(void *ptr);
void *tech_realloc(void *ptr,  unsigned long  size);
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
#pragma funcall main task1
#pragma funcall main task2
#line 6 "X:/TechRTOS/MyProject.c"
sbit LCD_RS at LATB4_bit;
sbit LCD_EN at LATB5_bit;
sbit LCD_D4 at LATB0_bit;
sbit LCD_D5 at LATB1_bit;
sbit LCD_D6 at LATB2_bit;
sbit LCD_D7 at LATB3_bit;

sbit LCD_RS_Direction at TRISB4_bit;
sbit LCD_EN_Direction at TRISB5_bit;
sbit LCD_D4_Direction at TRISB0_bit;
sbit LCD_D5_Direction at TRISB1_bit;
sbit LCD_D6_Direction at TRISB2_bit;
sbit LCD_D7_Direction at TRISB3_bit;


void Lcd_Clr_Line( unsigned char  line)
{
 Lcd_Out(line, 1, "                ");
}

 signed int  strlen_rom(const char *text)
{
  signed int  i;
 for (i = 0; text[i] != '\0'; i++)
 ;

 return i;
}

void strcpy_rom(char *dest, const char *src)
{
  unsigned char  i;
 for (i = 0; (dest[i] = src[i]) != '\0'; i++)
 ;
}

void Lcd_OutText( unsigned char  var, char *text)
{
 if (var)
 Lcd_Out(2, 1, text);
 else
 Lcd_Clr_Line(2);
}

void task1(void *params)
{
  unsigned char  *var = ( unsigned char  *)params;
 const char text_rom[] = "TechRTOS:";
 const char website_rom[] = "-codeforfun.it-";

 static char *website;
 static char *text;

 text = tech_malloc((strlen_rom(text_rom) + 1) * sizeof(char));
 strcpy_rom(text, text_rom);

 website = tech_malloc((strlen_rom(website_rom) + 1) * sizeof(char));
 strcpy_rom(website, website_rom);

 for (;; yield())
 {
 Lcd_OutText(*var, website);
 Lcd_Out(1, 1, text);
 }
}

void task2(void *params)
{
  unsigned char  *var = ( unsigned char  *)params;
  unsigned long  ticks, current;

 ticks = tech_getTicks();
 for (;;)
 {
 current = tech_getTicks();

 if (current - ticks > 1000)
 {
 ticks = current;
 *var = !*var;
 yield();
 }
 }
}

void interrupt()
{
 if (INTCON.T0IF)
 {
 tech_timer();

 INTCON.TMR0IE = 1;
 INTCON.T0IF = 0;
 TMR0L = 56;
 }
}

void main()
{
  unsigned char  resource;

 pcontext_t p2;
 pcontext_t p1;


 TMR0L = 56;
 TMR0H = 0;
 T0CON.PSA = 1;
 T0CON.T0PS0 = 0;
 T0CON.T0PS1 = 0;
 T0CON.T0PS2 = 0;
 T0CON.T0CS = 0;
 T0CON.T0SE = 0;
 T0CON.T08BIT = 1;


 tech_init();
 tech_setInc(100);


 T0CON.TMR0ON = 1;
 INTCON.GIE = 1;
 INTCON.TMR0IE = 1;
 INTCON.T0IF = 0;

 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);

 resource = 1;

 p1 = tech_cxt(&task1, &resource, 5);
 p2 = tech_cxt(&task2, &resource, 5);

 tech_run();
 tech_drop();
}
