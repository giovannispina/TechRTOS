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

#ifndef __LIST_H__
#define __LIST_H__

#include <Types.h>

typedef struct node_t {
	void* pdata;
	struct node_t* next;
	struct node_t* previous;
} node_t;

typedef node_t* pnode_t;

typedef struct list_t {
	pnode_t first;
	pnode_t last;
	uint16 size;
} list_t;

typedef struct list_t* plist_t;

plist_t	list_new();
uint16	list_size(plist_t list);
pnode_t	list_begin(plist_t list);
pnode_t	list_insert(plist_t list, void* pdata);
pnode_t	list_insert_after(plist_t list, pnode_t node, void* pdata);
bool	list_erase(plist_t list, pnode_t node);
void	list_foreach(plist_t list, void (*func)(void*));
pnode_t	list_find(plist_t list, int (*func)(void*, void*), void* pdata);

#endif /* __LIST_H__ */