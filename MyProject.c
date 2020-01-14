#include "TechOS.h"

#pragma funcall main task1
#pragma funcall main task2

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
// End LCD module connections

void Lcd_Clr_Line(uint8 line)
{
    Lcd_Out(line, 1, "                ");
}

int16 strlen_rom(const char *text)
{
    int16 i;
    for (i = 0; text[i] != '\0'; i++)
        ;

    return i;
}

void strcpy_rom(char *dest, const char *src)
{
    uint8 i;
    for (i = 0; (dest[i] = src[i]) != '\0'; i++)
        ;
}

void Lcd_OutText(uint8 var, char *text)
{
    if (var)
        Lcd_Out(2, 1, text);
    else
        Lcd_Clr_Line(2);
}

void task1(void *params)
{
    uint8 *var = (uint8 *)params;
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
    uint8 *var = (uint8 *)params;
    uint32 ticks, current;

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
    uint8 resource;

    pcontext_t p2;
    pcontext_t p1;

    // timer settings
    TMR0L = 56;
    TMR0H = 0;
    T0CON.PSA = 1;
    T0CON.T0PS0 = 0;
    T0CON.T0PS1 = 0;
    T0CON.T0PS2 = 0;
    T0CON.T0CS = 0;
    T0CON.T0SE = 0;
    T0CON.T08BIT = 1;

    // techRTOS init
    tech_init();
    tech_setInc(100); // 100 us

    // enable interrupts
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