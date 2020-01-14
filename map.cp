#line 1 "X:/TechRTOS/map.c"
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
#line 3 "X:/TechRTOS/map.c"
 signed int  default_hash(void *ptr,  signed int  size)
{
 return (( signed int )ptr % size);
}

phashmap_t map_create( unsigned int  size,  signed int  (*hash)(void *,  signed int ),  signed int  (*cmp)(void *, void *))
{
 phashmap_t hm;

 if (!cmp)
 return  0 ;

 hm = (phashmap_t)Malloc(sizeof(hashmap_t));

 if (!hm)
 return  0 ;

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
  signed int  index;

 index = hm->hash(key, hm->size);

 if (!hm->buckets[index])
 return  0 ;

 for (node = hm->buckets[index]->first; node; node = node->next)
 {
 phashnode_t item = (phashnode_t)node;

 if (!hm->cmp(node->pdata, key))
 return item;
 }

 return  0 ;
}

void map_insert(phashmap_t hm, void *key, void *value)
{
 pnode_t node;
 phashnode_t item;
  signed int  index;

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
  signed int  i;

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
  signed int  index;

 item = (phashnode_t)node;
 index = hm->hash(node->pdata, hm->size);

 if (!hm->buckets[index])
 return;
 list_erase(hm->buckets[index], node);
}

void map_destroy(phashmap_t hm)
{
 pnode_t node;
  signed int  i;

 if (!hm)
 return;

 for (i = 0; i < hm->size; i++)
 {
 if (hm->buckets[i])
 list_destroy(hm->buckets[i]);
 }

 FreeMem((void *)hm->buckets, sizeof(plist_t) * hm->size);
}
