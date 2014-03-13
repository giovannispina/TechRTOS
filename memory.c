/* Copyright (c) 2014, Giovanni Spina <giovanni@codeforfun.it>
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*     * Redistributions of source code must retain the above copyright
*       notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above copyright
*       notice, this list of conditions and the following disclaimer in the
*       documentation and/or other materials provided with the distribution.
*     * Neither the name of the uploader nor the
*       names of its contributors may be used to endorse or promote products
*       derived from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY GIOVANNI SPINA ``AS IS'' AND ANY
* EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL GIOVANNI SPINA BE LIABLE FOR ANY
* DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
* ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.*/

#include <assert.h>

phashmap_t memory;

int16 compare(void* ptr, void* ptr2)
{
	return (ptr == ptr2) ? 0 : 1;
}

void tech_memory_init()
{
	MM_Init();

	memory = map_create(10, NULL, &compare);
}

void* tech_malloc(uint32 size)
{
	void* ptr;

	ptr = Malloc(size);
	assert (ptr);

	map_insert(memory, ptr, (void*)size);
	return ptr;
}

void* tech_calloc(uint32 value, uint32 size)
{
	void* ptr;

	ptr = Malloc(size);
	assert (ptr);

	memset(ptr, value, size);
	map_insert(memory, ptr, (void*)size);
	return ptr;
}

void tech_free(void* ptr)
{
	phashnode_t node;

	node = map_find(memory, ptr);
	assert (node);
	FreeMem(ptr, (uint32)node->value);
}

void* tech_realloc(void* ptr, uint32 size)
{
	void* new_ptr;
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