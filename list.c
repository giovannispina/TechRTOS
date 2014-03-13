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

#include <list.h>

#define FAST_ERASE

plist_t list_new()
{
	plist_t list;
	
	list = (plist_t) Malloc(sizeof(list_t));

	if (!list)
		return NULL;

	list->first = NULL;
	list->last = NULL;

	list->node_type = sizeof(node_t);

	return list;
}

void list_destroy(plist_t list)
{
	pnode_t node;
	if (!list) return;

	for (node = list->first; node; node = node->next)
		FreeMem((void*)node, sizeof(node_t));
	
	FreeMem((void*)list, sizeof(list_t));
}

uint16 list_size(plist_t list)
{
	return list->size;
}

pnode_t list_begin(plist_t list)
{
	return list->first;
}

pnode_t node_create(plist_t list, void* pdata)
{
	pnode_t node;
	
	node = (pnode_t) Malloc(list->node_type);

	if (!node)
		return NULL;

	node->next = NULL;
	node->previous = NULL;
	node->pdata = pdata;

	return node;
}

pnode_t list_insert(plist_t list, void* pdata)
{
	pnode_t node;

	if (!list)
		return NULL;

	node = node_create(list, pdata);

	if (!list->first)
		list->first = list->last = node;
	else {
		list->last->next = node;
		node->previous = list->last;
		list->last = node;
	}

	return node;
}

pnode_t list_insert_after(plist_t list, pnode_t node, void* pdata)
{
	pnode_t newnode;

	if (!list)
		return NULL;

	newnode = node_create(list, pdata);

	if (list->last == node) {
		list->last->next = newnode;
		newnode->previous = list->last;
		list->last = newnode;
	} else {
		newnode->next = node->next;
		newnode->previous = node;
		node->next = newnode;
	}

	return newnode;
}

bool list_erase(plist_t list, pnode_t cmp_node)
{
	pnode_t node;

	if (!list || !cmp_node)
		return false;

	if (list->first == cmp_node) {
		list->first = cmp_node->next;
		cmp_node->next->previous = NULL;
		FreeMem((char*)cmp_node, sizeof(node));
		return true;
	} else if (list->last == cmp_node) {
		list->last = cmp_node->previous;
		list->last->next = NULL;
		FreeMem((char*)cmp_node, sizeof(node));
		return true;
	}
#ifndef FAST_ERASE
	node = list->first;

	while (node->next && node->next != cmp_node) 
		node = node->next;

	if (!node->next) return false;
#else
	node = cmp_node->previous;
#endif
	node->next = cmp_node->next;
	cmp_node->next->previous = node;
	FreeMem((char*)cmp_node, sizeof(node));
	return true;
}

void list_foreach(plist_t list, void (*func)(void*))
{
	pnode_t node;
	if (!list) return;

	for (node = list->first; node; node = node->next)
		func(node->pdata);
}

pnode_t list_find(plist_t list, int (*func)(void*, void*), void *pdata)
{
	pnode_t node;
	if (!list) return NULL;

	for (node = list->first; node; node = node->next) {
		if (!func(node->pdata, pdata))
			return node;
	}

	return NULL;
}