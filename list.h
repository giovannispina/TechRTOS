#ifndef __LIST_H__
#define __LIST_H__

#include "Types.h"

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
    uint16 size;
    uint16 node_type;
} list_t;

typedef struct list_t *plist_t;

plist_t list_new();
void list_destroy(plist_t list);
uint16 list_size(plist_t list);
pnode_t list_begin(plist_t list);
pnode_t list_insert(plist_t list, void *pdata);
pnode_t list_insert_after(plist_t list, pnode_t node, void *pdata);
bool list_erase(plist_t list, pnode_t node);
void list_foreach(plist_t list, void (*func)(void *));
pnode_t list_find(plist_t list, int (*func)(void *, void *), void *pdata);

#endif /* __LIST_H__ */