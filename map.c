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

#include <map.h>

int16 default_hash(void* ptr, int16 size)
{
	return ((int16)ptr % size);
}

phashmap_t map_create(uint16 size, int16 (*hash)(void*, int16), int16 (*cmp)(void*, void*))
{
	phashmap_t hm;

	if (!cmp) return NULL;

	hm = (phashmap_t) Malloc(sizeof(hashmap_t));
	
	if (!hm) return NULL;

	hm->buckets = Malloc(sizeof(plist_t)*size);
	memset(hm->buckets, 0, sizeof(plist_t)*size);
	hm->size = size;
	hm->count = 0;
	hm->cmp = cmp;

	if (!hash)
		hm->hash = &default_hash;

	return hm;
}

phashnode_t map_find(phashmap_t hm, void* key)
{
	pnode_t node;
	int16 index;
	
	index = hm->hash(key, hm->size);

	if (!hm->buckets[index]) return NULL;

	for (node = hm->buckets[index]->first; node; node = node->next) {
		phashnode_t item = (phashnode_t)node;

		if (!hm->cmp(item->key, key))
			return item;
	}
	
	return NULL;
}

void map_insert(phashmap_t hm, void* key, void* value)
{
	pnode_t node;
	phashnode_t item;
	int16 index;
	
	index = hm->hash(key, hm->size);

	if (!hm->buckets[index]) {
		hm->buckets[index] = list_new();
		hm->buckets[index]->node_type = sizeof(hashnode_t);
	}

	for (node = hm->buckets[index]->first; node; node = node->next) {
		item = (phashnode_t)node;

		if (!hm->cmp(item->key, key)) {
			item->value = value;
			return;
		}
	}

	item = (phashnode_t)list_insert(p, item);
	item->key = key;
	item->value = value;
}

void map_foreach(phashmap_t hm, void (*func)(void*, void*))
{
	pnode_t node;
	int16 i;

	for (i = 0; i < hm->size; i++) {
		for (node = hm->buckets[i]->first; node; node = node->next) {
			phashnode_t item = (phashnode_t)node;
			func(item->key, item->value);
		}
	}
}

void map_erase(phashmap_t hm, pnode_t node)
{
	phashnode_t item;
	int16 index;
	
	item = (phashnode_t)node;
	index = hm->hash(item->key, hm->size);

	list_erase(hm->buckets[index], node);
}

void map_destroy(phashmap_t hm)
{
	pnode_t node;
	int16 i;
	
	if (!hm) return;

	for (i = 0; i < hm->size; i++) {
		if (hm->buckets[i])
			list_destroy(hm->buckets[i]);
	}

	FreeMem((void*)hm->buckets, sizeof(plist_t)*hm->size);
}