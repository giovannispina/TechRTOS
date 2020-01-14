#include "map.h"

int16 default_hash(void *ptr, int16 size)
{
    return ((int16)ptr % size);
}

phashmap_t map_create(uint16 size, int16 (*hash)(void *, int16), int16 (*cmp)(void *, void *))
{
    phashmap_t hm;

    if (!cmp)
        return NULL;

    hm = (phashmap_t)Malloc(sizeof(hashmap_t));

    if (!hm)
        return NULL;

    hm->buckets = Malloc(sizeof(plist_t) * size);
    memset(hm->buckets, 0, sizeof(plist_t) * size);
    hm->size = size;
    hm->count = 0;
    hm->cmp = cmp;

    if (!hash)
        hm->hash = &default_hash;

    return hm;
}

phashnode_t map_find(phashmap_t hm, void *key)
{
    pnode_t node;
    int16 index;

    index = hm->hash(key, hm->size);

    if (!hm->buckets[index])
        return NULL;

    for (node = hm->buckets[index]->first; node; node = node->next)
    {
        phashnode_t item = (phashnode_t)node;

        if (!hm->cmp(node->pdata, key))
            return item;
    }

    return NULL;
}

void map_insert(phashmap_t hm, void *key, void *value)
{
    pnode_t node;
    phashnode_t item;
    int16 index;

    index = hm->hash(key, hm->size);

    if (!hm->buckets[index])
    {
        hm->buckets[index] = list_new();
        hm->buckets[index]->node_type = sizeof(hashnode_t);
    }
    else
    {
        for (node = hm->buckets[index]->first; node; node = node->next)
        {
            item = (phashnode_t)node;

            if (!hm->cmp(node->pdata, key))
            {
                item->value = value;
                return;
            }
        }
    }

    item = (phashnode_t)list_insert(key, item);
    item->value = value;
}

void map_foreach(phashmap_t hm, void (*func)(void *, void *))
{
    pnode_t node;
    int16 i;

    for (i = 0; i < hm->size; i++)
    {
        if (!hm->buckets[i])
            continue;

        for (node = hm->buckets[i]->first; node; node = node->next)
        {
            phashnode_t item = (phashnode_t)node;
            func(node->pdata, item->value);
        }
    }
}

void map_erase(phashmap_t hm, pnode_t node)
{
    phashnode_t item;
    int16 index;

    item = (phashnode_t)node;
    index = hm->hash(node->pdata, hm->size);

    if (!hm->buckets[index])
        return;
    list_erase(hm->buckets[index], node);
}

void map_destroy(phashmap_t hm)
{
    pnode_t node;
    int16 i;

    if (!hm)
        return;

    for (i = 0; i < hm->size; i++)
    {
        if (hm->buckets[i])
            list_destroy(hm->buckets[i]);
    }

    FreeMem((void *)hm->buckets, sizeof(plist_t) * hm->size);
}