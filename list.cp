#line 1 "X:/TechRTOS/list.c"
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
#line 5 "X:/TechRTOS/list.c"
plist_t list_new()
{
 plist_t list;

 list = (plist_t)Malloc(sizeof(list_t));

 if (!list)
 return  0 ;

 list->first =  0 ;
 list->last =  0 ;

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

 unsigned int  list_size(plist_t list)
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
 return  0 ;

 node->next =  0 ;
 node->previous =  0 ;
 node->pdata = pdata;

 return node;
}

pnode_t list_insert(plist_t list, void *pdata)
{
 pnode_t node;

 if (!list)
 return  0 ;

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
 return  0 ;

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

 unsigned char  list_erase(plist_t list, pnode_t cmp_node)
{
 pnode_t node;

 if (!list || !cmp_node)
 return  0 ;

 if (list->first == cmp_node)
 {
 list->first = cmp_node->next;
 cmp_node->next->previous =  0 ;
 FreeMem((char *)cmp_node, sizeof(node));
 return  1 ;
 }
 else if (list->last == cmp_node)
 {
 list->last = cmp_node->previous;
 list->last->next =  0 ;
 FreeMem((char *)cmp_node, sizeof(node));
 return  1 ;
 }









 node = cmp_node->previous;

 node->next = cmp_node->next;
 cmp_node->next->previous = node;
 FreeMem((char *)cmp_node, sizeof(node));
 return  1 ;
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
 return  0 ;

 for (node = list->first; node; node = node->next)
 {
 if (!func(node->pdata, pdata))
 return node;
 }

 return  0 ;
}
