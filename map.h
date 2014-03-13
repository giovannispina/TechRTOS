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

#ifndef __MAP_H__
#define __MAP_H__

#include <list.h>

typedef struct hashnode_t {
	node_t node;
	void* key;
	void* value;
} hashnode_t;

typedef hashnode_t* phashnode_t;

typedef struct hashmap_t {
	plist_t* buckets;
	int16 size;
	int16 count;
	int16 (*hash)(void*, int16);
	int16 (*cmp)(void*, void*);
} hashmap_t;

typedef hashmap_t* phashmap_t;

phashmap_t	map_create(uint16 size, int16 (*hash)(void*, int16), int16 (*cmp)(void*, void*));
phashnode_t	map_find(phashmap_t hm, void* key);
void		map_insert(phashmap_t hm, void* key, void* value);
void		map_foreach(phashmap_t hm, void (*func)(void*, void*));
void		map_erase(phashmap_t hm, void* key);
void		map_destroy(phashmap_t hm);

#endif /* __MAP_H__ */