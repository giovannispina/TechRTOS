#include "list.h"

#define FAST_ERASE

plist_t list_new()
{
    plist_t list;

    list = (plist_t)Malloc(sizeof(list_t));

    if (!list)
        return NULL;

    list->first = NULL;
    list->last = NULL;

    list->node_type = sizeof(node_t);

    return list;
}

void list_destroy(plist_t list)
{
    pnode_t node;
    if (!list)
        return;

    for (node = list->first; node; node = node->next)
        FreeMem((void *)node, sizeof(node_t));

    FreeMem((void *)list, sizeof(list_t));
}

uint16 list_size(plist_t list)
{
    return list->size;
}

pnode_t list_begin(plist_t list)
{
    return list->first;
}

pnode_t node_create(plist_t list, void *pdata)
{
    pnode_t node;

    node = (pnode_t)Malloc(list->node_type);

    if (!node)
        return NULL;

    node->next = NULL;
    node->previous = NULL;
    node->pdata = pdata;

    return node;
}

pnode_t list_insert(plist_t list, void *pdata)
{
    pnode_t node;

    if (!list)
        return NULL;

    node = node_create(list, pdata);

    if (!list->first)
        list->first = list->last = node;
    else
    {
        list->last->next = node;
        node->previous = list->last;
        list->last = node;
    }

    return node;
}

pnode_t list_insert_after(plist_t list, pnode_t node, void *pdata)
{
    pnode_t newnode;

    if (!list)
        return NULL;

    newnode = node_create(list, pdata);

    if (list->last == node)
    {
        list->last->next = newnode;
        newnode->previous = list->last;
        list->last = newnode;
    }
    else
    {
        newnode->next = node->next;
        newnode->previous = node;
        node->next = newnode;
    }

    return newnode;
}

bool list_erase(plist_t list, pnode_t cmp_node)
{
    pnode_t node;

    if (!list || !cmp_node)
        return false;

    if (list->first == cmp_node)
    {
        list->first = cmp_node->next;
        cmp_node->next->previous = NULL;
        FreeMem((char *)cmp_node, sizeof(node));
        return true;
    }
    else if (list->last == cmp_node)
    {
        list->last = cmp_node->previous;
        list->last->next = NULL;
        FreeMem((char *)cmp_node, sizeof(node));
        return true;
    }
#ifndef FAST_ERASE
    node = list->first;

    while (node->next && node->next != cmp_node)
        node = node->next;

    if (!node->next)
        return false;
#else
    node = cmp_node->previous;
#endif
    node->next = cmp_node->next;
    cmp_node->next->previous = node;
    FreeMem((char *)cmp_node, sizeof(node));
    return true;
}

void list_foreach(plist_t list, void (*func)(void *))
{
    pnode_t node;
    if (!list)
        return;

    for (node = list->first; node; node = node->next)
        func(node->pdata);
}

pnode_t list_find(plist_t list, int (*func)(void *, void *), void *pdata)
{
    pnode_t node;
    if (!list)
        return NULL;

    for (node = list->first; node; node = node->next)
    {
        if (!func(node->pdata, pdata))
            return node;
    }

    return NULL;
}