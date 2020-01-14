#include "assert.h"

phashmap_t memory;

int16 compare(void *ptr, void *ptr2)
{
    return (ptr == ptr2) ? 0 : 1;
}

void tech_memory_init()
{
    MM_Init();

    memory = map_create(10, NULL, &compare);
}

void *tech_malloc(uint32 size)
{
    void *ptr;

    ptr = Malloc(size);
    assert(ptr);

    map_insert(memory, ptr, (void *)size);
    return ptr;
}

void *tech_calloc(uint32 num, uint32 size)
{
    void *ptr;

    ptr = Malloc(num * size);
    assert(ptr);

    memset(ptr, 0, size);
    map_insert(memory, ptr, (void *)size);
    return ptr;
}

void tech_free(void *ptr)
{
    phashnode_t node;

    node = map_find(memory, ptr);
    assert(node);
    FreeMem(ptr, (uint32)node->value);
}

void *tech_realloc(void *ptr, uint32 size)
{
    void *new_ptr;
    new_ptr = tech_malloc(size);

    memcpy(new_ptr, ptr, size);
    tech_free(ptr);
    return new_ptr;
}

void tech_free_all()
{
    map_destroy(memory);
    MM_TotalFreeMemSize();
}