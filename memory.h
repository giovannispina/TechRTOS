#ifndef __MEMORY_H__
#define __MEMORY_H__

#include "map.h"

void tech_memory_init();
void *tech_malloc(uint32 size);
void *tech_calloc(uint32 value, uint32 size);
void tech_free(void *ptr);
void *tech_realloc(void *ptr, uint32 size);
void tech_free_all();

#endif /* __MEMORY_H__ */