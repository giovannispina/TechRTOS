#include "TechOS.h"
#include "CxtSwitchMacro.h"

volatile pcontext_t current_cxt = NULL;
volatile pcontext_t main_cxt = NULL;
void (*tech_stkof_hook)(pcontext_t) = NULL;
plist_t cxtlist = NULL;

uint8 tmp_data[6];

void tech_handle_crash();

int context_equal(void *cxt1, void *cxt2)
{
    if (cxt1 == cxt2)
        return 0;
    else
        return 1;
}

void yield()
{
    pnode_t node;
    save_context();

    node = list_find(cxtlist, &context_equal, current_cxt);
    if (node && node->next)
        current_cxt = node->next->pdata;
    else if ((node = list_begin(cxtlist)))
        current_cxt = node->pdata;
    else
        current_cxt = main_cxt;

    restore_context();

    enableInt();
}

void tech_init()
{
    tech_memory_init();
    tech_timerSysInit();
    main_cxt = tech_cxt(NULL, NULL, MAX_STACK_SIZE);
    current_cxt = main_cxt;

    cxtlist = list_new();
}

void tech_drop()
{
    list_destroy(cxtlist);
    tech_free_all();
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
        CLRF  TOSU, 0

        MOVFF POSTINC1, FSR0L
        MOVFF POSTINC1, FSR0H

        MOVFF POSTINC1, POSTINC0
        MOVFF INDF1, INDF0
    }

    enableInt();
}

void run_cxt(void *param)
{
    pcontext_t cxt = (pcontext_t)param;

    /* save main cxt */
    save_context();

    /* running cxt */
    current_cxt = cxt;
    tech_safe_call();

    /* restore main cxt */
    disableInt();
    tech_cxt_destroy(current_cxt);
    current_cxt = main_cxt;
    restore_context();
}

void tech_run()
{
    list_foreach(cxtlist, &run_cxt);
}

pcontext_t tech_cxt(void (*func)(void *), void *params, unsigned size)
{
    pcontext_t p = (pcontext_t)Malloc(sizeof(context));
    if (!p)
        return NULL;

    p->stack_ptr = Malloc(CXT_MIN_SIZE + size);
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

    FreeMem((void *)cxt->stack_ptr, CXT_MIN_SIZE + cxt->stack_size);
    FreeMem((void *)cxt, sizeof(context));

    node = list_find(cxtlist, &context_equal, cxt);

    if (!node)
        return;

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

    if (tech_stkof_hook)
    {
        /* we are not going to destroy the context, the user will handle this */
        node = list_find(cxtlist, &context_equal, current_cxt);
        list_erase(cxtlist, node);
        /* user hook */
        tech_stkof_hook(current_cxt);
    }
    else
        tech_cxt_destroy(current_cxt);

    /* back to main context */
    current_cxt = main_cxt;
}