#line 1 "X:/TechRTOS/memory.c"
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
#line 3 "X:/TechRTOS/memory.c"
phashmap_t memory;

 signed int  compare(void *ptr, void *ptr2)
{
 return (ptr == ptr2) ? 0 : 1;
}

void tech_memory_init()
{
 MM_Init();

 memory = map_create(10,  0 , &compare);
}

void *tech_malloc( unsigned long  size)
{
 void *ptr;

 ptr = Malloc(size);
  { if (!ptr) { INTCON.GIEH = 0; ; { asm SLEEP; } ; { STKPTR = 0; tech_freeAll(); asm goto 0x0; } ;} } ;

 map_insert(memory, ptr, (void *)size);
 return ptr;
}

void *tech_calloc( unsigned long  value,  unsigned long  size)
{
 void *ptr;

 ptr = Malloc(size);
  { if (!ptr) { INTCON.GIEH = 0; ; { asm SLEEP; } ; { STKPTR = 0; tech_freeAll(); asm goto 0x0; } ;} } ;

 memset(ptr, value, size);
 map_insert(memory, ptr, (void *)size);
 return ptr;
}

void tech_free(void *ptr)
{
 phashnode_t node;

 node = map_find(memory, ptr);
  { if (!node) { INTCON.GIEH = 0; ; { asm SLEEP; } ; { STKPTR = 0; tech_freeAll(); asm goto 0x0; } ;} } ;
 FreeMem(ptr, ( unsigned long )node->value);
}

void *tech_realloc(void *ptr,  unsigned long  size)
{
 void *new_ptr;
 new_ptr = tech_malloc(size);

 memcpy(new_ptr, ptr, size);
 tech_free(ptr);
 return new_ptr;
}

void tech_freeAll()
{
 map_destroy(memory);
 MM_TotalFreeMemSize();
}
