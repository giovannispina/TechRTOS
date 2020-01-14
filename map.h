#ifndef __MAP_H__
#define __MAP_H__

#include "list.h"

typedef struct hashnode_t
{
    node_t node;
    void *value;
} hashnode_t;

typedef hashnode_t *phashnode_t;

typedef struct hashmap_t
{
    plist_t *buckets;
    int16 size;
    int16 count;
    int16 (*hash)(void *, int16);
    int16 (*cmp)(void *, void *);
} hashmap_t;

typedef hashmap_t *phashmap_t;

phashmap_t map_create(uint16 size, int16 (*hash)(void *, int16), int16 (*cmp)(void *, void *));
phashnode_t map_find(phashmap_t hm, void *key);
void map_insert(phashmap_t hm, void *key, void *value);
void map_foreach(phashmap_t hm, void (*func)(void *, void *));
void map_erase(phashmap_t hm, void *key);
void map_destroy(phashmap_t hm);

#endif /* __MAP_H__ */