
_default_hash:

;map.c,3 :: 		int16 default_hash(void *ptr, int16 size)
;map.c,5 :: 		return ((int16)ptr % size);
	MOVF        FARG_default_hash_size+0, 0 
	MOVWF       R4 
	MOVF        FARG_default_hash_size+1, 0 
	MOVWF       R5 
	MOVF        FARG_default_hash_ptr+0, 0 
	MOVWF       R0 
	MOVF        FARG_default_hash_ptr+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
;map.c,6 :: 		}
L_end_default_hash:
	RETURN      0
; end of _default_hash

_map_create:

;map.c,8 :: 		phashmap_t map_create(uint16 size, int16 (*hash)(void *, int16), int16 (*cmp)(void *, void *))
;map.c,12 :: 		if (!cmp)
	MOVF        FARG_map_create_cmp+0, 0 
	IORWF       FARG_map_create_cmp+1, 0 
	IORWF       FARG_map_create_cmp+2, 0 
	IORWF       FARG_map_create_cmp+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_map_create0
;map.c,13 :: 		return NULL;
	CLRF        R0 
	CLRF        R1 
	GOTO        L_end_map_create
L_map_create0:
;map.c,15 :: 		hm = (phashmap_t)Malloc(sizeof(hashmap_t));
	MOVLW       14
	MOVWF       FARG_Malloc_Size+0 
	MOVLW       0
	MOVWF       FARG_Malloc_Size+1 
	CALL        _Malloc+0, 0
	MOVF        R0, 0 
	MOVWF       map_create_hm_L0+0 
	MOVF        R1, 0 
	MOVWF       map_create_hm_L0+1 
;map.c,17 :: 		if (!hm)
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_map_create1
;map.c,18 :: 		return NULL;
	CLRF        R0 
	CLRF        R1 
	GOTO        L_end_map_create
L_map_create1:
;map.c,20 :: 		hm->buckets = Malloc(sizeof(plist_t) * size);
	MOVF        map_create_hm_L0+0, 0 
	MOVWF       FLOC__map_create+0 
	MOVF        map_create_hm_L0+1, 0 
	MOVWF       FLOC__map_create+1 
	MOVF        FARG_map_create_size+0, 0 
	MOVWF       FARG_Malloc_Size+0 
	MOVF        FARG_map_create_size+1, 0 
	MOVWF       FARG_Malloc_Size+1 
	RLCF        FARG_Malloc_Size+0, 1 
	BCF         FARG_Malloc_Size+0, 0 
	RLCF        FARG_Malloc_Size+1, 1 
	CALL        _Malloc+0, 0
	MOVFF       FLOC__map_create+0, FSR1L+0
	MOVFF       FLOC__map_create+1, FSR1H+0
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
;map.c,21 :: 		memset(hm->buckets, 0, sizeof(plist_t) * size);
	MOVFF       map_create_hm_L0+0, FSR0L+0
	MOVFF       map_create_hm_L0+1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_memset_p1+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_memset_p1+1 
	CLRF        FARG_memset_character+0 
	MOVF        FARG_map_create_size+0, 0 
	MOVWF       FARG_memset_n+0 
	MOVF        FARG_map_create_size+1, 0 
	MOVWF       FARG_memset_n+1 
	RLCF        FARG_memset_n+0, 1 
	BCF         FARG_memset_n+0, 0 
	RLCF        FARG_memset_n+1, 1 
	CALL        _memset+0, 0
;map.c,22 :: 		hm->size = size;
	MOVLW       2
	ADDWF       map_create_hm_L0+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      map_create_hm_L0+1, 0 
	MOVWF       FSR1L+1 
	MOVF        FARG_map_create_size+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        FARG_map_create_size+1, 0 
	MOVWF       POSTINC1+0 
;map.c,23 :: 		hm->count = 0;
	MOVLW       4
	ADDWF       map_create_hm_L0+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      map_create_hm_L0+1, 0 
	MOVWF       FSR1L+1 
	CLRF        POSTINC1+0 
	CLRF        POSTINC1+0 
;map.c,24 :: 		hm->cmp = cmp;
	MOVLW       10
	ADDWF       map_create_hm_L0+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      map_create_hm_L0+1, 0 
	MOVWF       FSR1L+1 
	MOVF        FARG_map_create_cmp+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        FARG_map_create_cmp+1, 0 
	MOVWF       POSTINC1+0 
	MOVF        FARG_map_create_cmp+2, 0 
	MOVWF       POSTINC1+0 
	MOVF        FARG_map_create_cmp+3, 0 
	MOVWF       POSTINC1+0 
;map.c,26 :: 		if (!hash)
	MOVF        FARG_map_create_hash+0, 0 
	IORWF       FARG_map_create_hash+1, 0 
	IORWF       FARG_map_create_hash+2, 0 
	IORWF       FARG_map_create_hash+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_map_create2
;map.c,27 :: 		hm->hash = &default_hash;
	MOVLW       6
	ADDWF       map_create_hm_L0+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      map_create_hm_L0+1, 0 
	MOVWF       FSR1L+1 
	MOVLW       _default_hash+0
	MOVWF       POSTINC1+0 
	MOVLW       hi_addr(_default_hash+0)
	MOVWF       POSTINC1+0 
	MOVLW       FARG_default_hash_ptr+0
	MOVWF       POSTINC1+0 
	MOVLW       hi_addr(FARG_default_hash_ptr+0)
	MOVWF       POSTINC1+0 
L_map_create2:
;map.c,29 :: 		return hm;
	MOVF        map_create_hm_L0+0, 0 
	MOVWF       R0 
	MOVF        map_create_hm_L0+1, 0 
	MOVWF       R1 
;map.c,30 :: 		}
L_end_map_create:
	RETURN      0
; end of _map_create

_map_find:

;map.c,32 :: 		phashnode_t map_find(phashmap_t hm, void *key)
;map.c,37 :: 		index = hm->hash(key, hm->size);
	MOVLW       6
	ADDWF       FARG_map_find_hm+0, 0 
	MOVWF       FSR0L+0 
	MOVLW       0
	ADDWFC      FARG_map_find_hm+1, 0 
	MOVWF       FSR0L+1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVF        POSTINC0+0, 0 
	MOVWF       R4 
	MOVF        POSTINC0+0, 0 
	MOVWF       R5 
	MOVLW       2
	ADDWF       FARG_map_find_hm+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_map_find_hm+1, 0 
	MOVWF       R1 
	MOVF        R4, 0 
	MOVWF       FSR1+0 
	MOVF        R5, 0 
	MOVWF       FSR1+1 
	MOVF        FARG_map_find_key+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        FARG_map_find_key+1, 0 
	MOVWF       POSTINC1+0 
	MOVFF       R0, FSR0L+0
	MOVFF       R1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R2, 0 
	MOVWF       R0 
	MOVF        R3, 0 
	MOVWF       R1 
	CALL        _____DoIFC+0, 0
	MOVF        R0, 0 
	MOVWF       map_find_index_L0+0 
	MOVF        R1, 0 
	MOVWF       map_find_index_L0+1 
;map.c,39 :: 		if (!hm->buckets[index])
	MOVFF       FARG_map_find_hm+0, FSR0L+0
	MOVFF       FARG_map_find_hm+1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       R5 
	MOVF        POSTINC0+0, 0 
	MOVWF       R6 
	MOVF        R0, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	MOVWF       R3 
	RLCF        R2, 1 
	BCF         R2, 0 
	RLCF        R3, 1 
	MOVF        R2, 0 
	ADDWF       R5, 0 
	MOVWF       FSR0L+0 
	MOVF        R3, 0 
	ADDWFC      R6, 0 
	MOVWF       FSR0L+1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_map_find3
;map.c,40 :: 		return NULL;
	CLRF        R0 
	CLRF        R1 
	GOTO        L_end_map_find
L_map_find3:
;map.c,42 :: 		for (node = hm->buckets[index]->first; node; node = node->next)
	MOVFF       FARG_map_find_hm+0, FSR0L+0
	MOVFF       FARG_map_find_hm+1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVF        POSTINC0+0, 0 
	MOVWF       R4 
	MOVF        map_find_index_L0+0, 0 
	MOVWF       R0 
	MOVF        map_find_index_L0+1, 0 
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVF        R0, 0 
	ADDWF       R3, 0 
	MOVWF       FSR0L+0 
	MOVF        R1, 0 
	ADDWFC      R4, 0 
	MOVWF       FSR0L+1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVFF       R0, FSR0L+0
	MOVFF       R1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       map_find_node_L0+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       map_find_node_L0+1 
L_map_find4:
	MOVF        map_find_node_L0+0, 0 
	IORWF       map_find_node_L0+1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_map_find5
;map.c,44 :: 		phashnode_t item = (phashnode_t)node;
	MOVF        map_find_node_L0+0, 0 
	MOVWF       map_find_item_L1+0 
	MOVF        map_find_node_L0+1, 0 
	MOVWF       map_find_item_L1+1 
;map.c,46 :: 		if (!hm->cmp(node->pdata, key))
	MOVLW       10
	ADDWF       FARG_map_find_hm+0, 0 
	MOVWF       FSR0L+0 
	MOVLW       0
	ADDWFC      FARG_map_find_hm+1, 0 
	MOVWF       FSR0L+1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVLW       4
	ADDWF       map_find_node_L0+0, 0 
	MOVWF       FSR0L+0 
	MOVLW       0
	ADDWFC      map_find_node_L0+1, 0 
	MOVWF       FSR0L+1 
	MOVF        R2, 0 
	MOVWF       FSR1+0 
	MOVF        R3, 0 
	MOVWF       FSR1+1 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        FARG_map_find_key+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        FARG_map_find_key+1, 0 
	MOVWF       POSTINC1+0 
	CALL        _____DoIFC+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_map_find7
;map.c,47 :: 		return item;
	MOVF        map_find_item_L1+0, 0 
	MOVWF       R0 
	MOVF        map_find_item_L1+1, 0 
	MOVWF       R1 
	GOTO        L_end_map_find
L_map_find7:
;map.c,42 :: 		for (node = hm->buckets[index]->first; node; node = node->next)
	MOVFF       map_find_node_L0+0, FSR0L+0
	MOVFF       map_find_node_L0+1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       map_find_node_L0+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       map_find_node_L0+1 
;map.c,48 :: 		}
	GOTO        L_map_find4
L_map_find5:
;map.c,50 :: 		return NULL;
	CLRF        R0 
	CLRF        R1 
;map.c,51 :: 		}
L_end_map_find:
	RETURN      0
; end of _map_find

_map_insert:

;map.c,53 :: 		void map_insert(phashmap_t hm, void *key, void *value)
;map.c,59 :: 		index = hm->hash(key, hm->size);
	MOVLW       6
	ADDWF       FARG_map_insert_hm+0, 0 
	MOVWF       FSR0L+0 
	MOVLW       0
	ADDWFC      FARG_map_insert_hm+1, 0 
	MOVWF       FSR0L+1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVF        POSTINC0+0, 0 
	MOVWF       R4 
	MOVF        POSTINC0+0, 0 
	MOVWF       R5 
	MOVLW       2
	ADDWF       FARG_map_insert_hm+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_map_insert_hm+1, 0 
	MOVWF       R1 
	MOVF        R4, 0 
	MOVWF       FSR1+0 
	MOVF        R5, 0 
	MOVWF       FSR1+1 
	MOVF        FARG_map_insert_key+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        FARG_map_insert_key+1, 0 
	MOVWF       POSTINC1+0 
	MOVFF       R0, FSR0L+0
	MOVFF       R1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R2, 0 
	MOVWF       R0 
	MOVF        R3, 0 
	MOVWF       R1 
	CALL        _____DoIFC+0, 0
	MOVF        R0, 0 
	MOVWF       map_insert_index_L0+0 
	MOVF        R1, 0 
	MOVWF       map_insert_index_L0+1 
;map.c,61 :: 		if (!hm->buckets[index])
	MOVFF       FARG_map_insert_hm+0, FSR0L+0
	MOVFF       FARG_map_insert_hm+1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       R5 
	MOVF        POSTINC0+0, 0 
	MOVWF       R6 
	MOVF        R0, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	MOVWF       R3 
	RLCF        R2, 1 
	BCF         R2, 0 
	RLCF        R3, 1 
	MOVF        R2, 0 
	ADDWF       R5, 0 
	MOVWF       FSR0L+0 
	MOVF        R3, 0 
	ADDWFC      R6, 0 
	MOVWF       FSR0L+1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_map_insert8
;map.c,63 :: 		hm->buckets[index] = list_new();
	MOVFF       FARG_map_insert_hm+0, FSR0L+0
	MOVFF       FARG_map_insert_hm+1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVF        POSTINC0+0, 0 
	MOVWF       R4 
	MOVF        map_insert_index_L0+0, 0 
	MOVWF       R0 
	MOVF        map_insert_index_L0+1, 0 
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVF        R0, 0 
	ADDWF       R3, 0 
	MOVWF       FLOC__map_insert+0 
	MOVF        R1, 0 
	ADDWFC      R4, 0 
	MOVWF       FLOC__map_insert+1 
	CALL        _list_new+0, 0
	MOVFF       FLOC__map_insert+0, FSR1L+0
	MOVFF       FLOC__map_insert+1, FSR1H+0
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
;map.c,64 :: 		hm->buckets[index]->node_type = sizeof(hashnode_t);
	MOVFF       FARG_map_insert_hm+0, FSR0L+0
	MOVFF       FARG_map_insert_hm+1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVF        POSTINC0+0, 0 
	MOVWF       R4 
	MOVF        map_insert_index_L0+0, 0 
	MOVWF       R0 
	MOVF        map_insert_index_L0+1, 0 
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVF        R0, 0 
	ADDWF       R3, 0 
	MOVWF       FSR0L+0 
	MOVF        R1, 0 
	ADDWFC      R4, 0 
	MOVWF       FSR0L+1 
	MOVLW       6
	ADDWF       POSTINC0+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      POSTINC0+0, 0 
	MOVWF       FSR1L+1 
	MOVLW       8
	MOVWF       POSTINC1+0 
	MOVLW       0
	MOVWF       POSTINC1+0 
;map.c,65 :: 		}
	GOTO        L_map_insert9
L_map_insert8:
;map.c,68 :: 		for (node = hm->buckets[index]->first; node; node = node->next)
	MOVFF       FARG_map_insert_hm+0, FSR0L+0
	MOVFF       FARG_map_insert_hm+1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVF        POSTINC0+0, 0 
	MOVWF       R4 
	MOVF        map_insert_index_L0+0, 0 
	MOVWF       R0 
	MOVF        map_insert_index_L0+1, 0 
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVF        R0, 0 
	ADDWF       R3, 0 
	MOVWF       FSR0L+0 
	MOVF        R1, 0 
	ADDWFC      R4, 0 
	MOVWF       FSR0L+1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVFF       R0, FSR0L+0
	MOVFF       R1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       map_insert_node_L0+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       map_insert_node_L0+1 
L_map_insert10:
	MOVF        map_insert_node_L0+0, 0 
	IORWF       map_insert_node_L0+1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_map_insert11
;map.c,70 :: 		item = (phashnode_t)node;
	MOVF        map_insert_node_L0+0, 0 
	MOVWF       map_insert_item_L0+0 
	MOVF        map_insert_node_L0+1, 0 
	MOVWF       map_insert_item_L0+1 
;map.c,72 :: 		if (!hm->cmp(node->pdata, key))
	MOVLW       10
	ADDWF       FARG_map_insert_hm+0, 0 
	MOVWF       FSR0L+0 
	MOVLW       0
	ADDWFC      FARG_map_insert_hm+1, 0 
	MOVWF       FSR0L+1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVLW       4
	ADDWF       map_insert_node_L0+0, 0 
	MOVWF       FSR0L+0 
	MOVLW       0
	ADDWFC      map_insert_node_L0+1, 0 
	MOVWF       FSR0L+1 
	MOVF        R2, 0 
	MOVWF       FSR1+0 
	MOVF        R3, 0 
	MOVWF       FSR1+1 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        FARG_map_insert_key+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        FARG_map_insert_key+1, 0 
	MOVWF       POSTINC1+0 
	CALL        _____DoIFC+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_map_insert13
;map.c,74 :: 		item->value = value;
	MOVLW       6
	ADDWF       map_insert_item_L0+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      map_insert_item_L0+1, 0 
	MOVWF       FSR1L+1 
	MOVF        FARG_map_insert_value+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        FARG_map_insert_value+1, 0 
	MOVWF       POSTINC1+0 
;map.c,75 :: 		return;
	GOTO        L_end_map_insert
;map.c,76 :: 		}
L_map_insert13:
;map.c,68 :: 		for (node = hm->buckets[index]->first; node; node = node->next)
	MOVFF       map_insert_node_L0+0, FSR0L+0
	MOVFF       map_insert_node_L0+1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       map_insert_node_L0+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       map_insert_node_L0+1 
;map.c,77 :: 		}
	GOTO        L_map_insert10
L_map_insert11:
;map.c,78 :: 		}
L_map_insert9:
;map.c,80 :: 		item = (phashnode_t)list_insert(key, item);
	MOVF        FARG_map_insert_key+0, 0 
	MOVWF       FARG_list_insert_list+0 
	MOVF        FARG_map_insert_key+1, 0 
	MOVWF       FARG_list_insert_list+1 
	MOVF        map_insert_item_L0+0, 0 
	MOVWF       FARG_list_insert_pdata+0 
	MOVF        map_insert_item_L0+1, 0 
	MOVWF       FARG_list_insert_pdata+1 
	CALL        _list_insert+0, 0
	MOVF        R0, 0 
	MOVWF       map_insert_item_L0+0 
	MOVF        R1, 0 
	MOVWF       map_insert_item_L0+1 
;map.c,81 :: 		item->value = value;
	MOVLW       6
	ADDWF       R0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1L+1 
	MOVF        FARG_map_insert_value+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        FARG_map_insert_value+1, 0 
	MOVWF       POSTINC1+0 
;map.c,82 :: 		}
L_end_map_insert:
	RETURN      0
; end of _map_insert

_map_foreach:

;map.c,84 :: 		void map_foreach(phashmap_t hm, void (*func)(void *, void *))
;map.c,89 :: 		for (i = 0; i < hm->size; i++)
	CLRF        map_foreach_i_L0+0 
	CLRF        map_foreach_i_L0+1 
L_map_foreach14:
	MOVLW       2
	ADDWF       FARG_map_foreach_hm+0, 0 
	MOVWF       FSR2L+0 
	MOVLW       0
	ADDWFC      FARG_map_foreach_hm+1, 0 
	MOVWF       FSR2L+1 
	MOVF        POSTINC2+0, 0 
	MOVWF       R1 
	MOVF        POSTINC2+0, 0 
	MOVWF       R2 
	MOVLW       128
	XORWF       map_foreach_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       R2, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__map_foreach32
	MOVF        R1, 0 
	SUBWF       map_foreach_i_L0+0, 0 
L__map_foreach32:
	BTFSC       STATUS+0, 0 
	GOTO        L_map_foreach15
;map.c,91 :: 		if (!hm->buckets[i])
	MOVFF       FARG_map_foreach_hm+0, FSR0L+0
	MOVFF       FARG_map_foreach_hm+1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVF        POSTINC0+0, 0 
	MOVWF       R4 
	MOVF        map_foreach_i_L0+0, 0 
	MOVWF       R0 
	MOVF        map_foreach_i_L0+1, 0 
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVF        R0, 0 
	ADDWF       R3, 0 
	MOVWF       FSR0L+0 
	MOVF        R1, 0 
	ADDWFC      R4, 0 
	MOVWF       FSR0L+1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_map_foreach17
;map.c,92 :: 		continue;
	GOTO        L_map_foreach16
L_map_foreach17:
;map.c,94 :: 		for (node = hm->buckets[i]->first; node; node = node->next)
	MOVFF       FARG_map_foreach_hm+0, FSR0L+0
	MOVFF       FARG_map_foreach_hm+1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVF        POSTINC0+0, 0 
	MOVWF       R4 
	MOVF        map_foreach_i_L0+0, 0 
	MOVWF       R0 
	MOVF        map_foreach_i_L0+1, 0 
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVF        R0, 0 
	ADDWF       R3, 0 
	MOVWF       FSR0L+0 
	MOVF        R1, 0 
	ADDWFC      R4, 0 
	MOVWF       FSR0L+1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVFF       R0, FSR0L+0
	MOVFF       R1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       map_foreach_node_L0+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       map_foreach_node_L0+1 
L_map_foreach18:
	MOVF        map_foreach_node_L0+0, 0 
	IORWF       map_foreach_node_L0+1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_map_foreach19
;map.c,97 :: 		func(node->pdata, item->value);
	MOVLW       4
	ADDWF       map_foreach_node_L0+0, 0 
	MOVWF       FSR0L+0 
	MOVLW       0
	ADDWFC      map_foreach_node_L0+1, 0 
	MOVWF       FSR0L+1 
	MOVLW       6
	ADDWF       map_foreach_node_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      map_foreach_node_L0+1, 0 
	MOVWF       R1 
	MOVF        FARG_map_foreach_func+2, 0 
	MOVWF       FSR1+0 
	MOVF        FARG_map_foreach_func+3, 0 
	MOVWF       FSR1+1 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	MOVFF       R0, FSR0L+0
	MOVFF       R1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        FARG_map_foreach_func+0, 0 
	MOVWF       R0 
	MOVF        FARG_map_foreach_func+1, 0 
	MOVWF       R1 
	CALL        _____DoIFC+0, 0
;map.c,94 :: 		for (node = hm->buckets[i]->first; node; node = node->next)
	MOVFF       map_foreach_node_L0+0, FSR0L+0
	MOVFF       map_foreach_node_L0+1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       map_foreach_node_L0+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       map_foreach_node_L0+1 
;map.c,98 :: 		}
	GOTO        L_map_foreach18
L_map_foreach19:
;map.c,99 :: 		}
L_map_foreach16:
;map.c,89 :: 		for (i = 0; i < hm->size; i++)
	INFSNZ      map_foreach_i_L0+0, 1 
	INCF        map_foreach_i_L0+1, 1 
;map.c,99 :: 		}
	GOTO        L_map_foreach14
L_map_foreach15:
;map.c,100 :: 		}
L_end_map_foreach:
	RETURN      0
; end of _map_foreach

_map_erase:

;map.c,102 :: 		void map_erase(phashmap_t hm, pnode_t node)
;map.c,108 :: 		index = hm->hash(node->pdata, hm->size);
	MOVLW       6
	ADDWF       FARG_map_erase_hm+0, 0 
	MOVWF       FSR0L+0 
	MOVLW       0
	ADDWFC      FARG_map_erase_hm+1, 0 
	MOVWF       FSR0L+1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVF        POSTINC0+0, 0 
	MOVWF       R4 
	MOVF        POSTINC0+0, 0 
	MOVWF       R5 
	MOVLW       4
	ADDWF       FARG_map_erase_node+0, 0 
	MOVWF       FSR0L+0 
	MOVLW       0
	ADDWFC      FARG_map_erase_node+1, 0 
	MOVWF       FSR0L+1 
	MOVLW       2
	ADDWF       FARG_map_erase_hm+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_map_erase_hm+1, 0 
	MOVWF       R1 
	MOVF        R4, 0 
	MOVWF       FSR1+0 
	MOVF        R5, 0 
	MOVWF       FSR1+1 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	MOVFF       R0, FSR0L+0
	MOVFF       R1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R2, 0 
	MOVWF       R0 
	MOVF        R3, 0 
	MOVWF       R1 
	CALL        _____DoIFC+0, 0
	MOVF        R0, 0 
	MOVWF       map_erase_index_L0+0 
	MOVF        R1, 0 
	MOVWF       map_erase_index_L0+1 
;map.c,110 :: 		if (!hm->buckets[index])
	MOVFF       FARG_map_erase_hm+0, FSR0L+0
	MOVFF       FARG_map_erase_hm+1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       R5 
	MOVF        POSTINC0+0, 0 
	MOVWF       R6 
	MOVF        R0, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	MOVWF       R3 
	RLCF        R2, 1 
	BCF         R2, 0 
	RLCF        R3, 1 
	MOVF        R2, 0 
	ADDWF       R5, 0 
	MOVWF       FSR0L+0 
	MOVF        R3, 0 
	ADDWFC      R6, 0 
	MOVWF       FSR0L+1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_map_erase21
;map.c,111 :: 		return;
	GOTO        L_end_map_erase
L_map_erase21:
;map.c,112 :: 		list_erase(hm->buckets[index], node);
	MOVFF       FARG_map_erase_hm+0, FSR0L+0
	MOVFF       FARG_map_erase_hm+1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVF        POSTINC0+0, 0 
	MOVWF       R4 
	MOVF        map_erase_index_L0+0, 0 
	MOVWF       R0 
	MOVF        map_erase_index_L0+1, 0 
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVF        R0, 0 
	ADDWF       R3, 0 
	MOVWF       FSR0L+0 
	MOVF        R1, 0 
	ADDWFC      R4, 0 
	MOVWF       FSR0L+1 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_list_erase_list+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_list_erase_list+1 
	MOVF        FARG_map_erase_node+0, 0 
	MOVWF       FARG_list_erase_node+0 
	MOVF        FARG_map_erase_node+1, 0 
	MOVWF       FARG_list_erase_node+1 
	CALL        _list_erase+0, 0
;map.c,113 :: 		}
L_end_map_erase:
	RETURN      0
; end of _map_erase

_map_destroy:

;map.c,115 :: 		void map_destroy(phashmap_t hm)
;map.c,120 :: 		if (!hm)
	MOVF        FARG_map_destroy_hm+0, 0 
	IORWF       FARG_map_destroy_hm+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_map_destroy22
;map.c,121 :: 		return;
	GOTO        L_end_map_destroy
L_map_destroy22:
;map.c,123 :: 		for (i = 0; i < hm->size; i++)
	CLRF        map_destroy_i_L0+0 
	CLRF        map_destroy_i_L0+1 
L_map_destroy23:
	MOVLW       2
	ADDWF       FARG_map_destroy_hm+0, 0 
	MOVWF       FSR2L+0 
	MOVLW       0
	ADDWFC      FARG_map_destroy_hm+1, 0 
	MOVWF       FSR2L+1 
	MOVF        POSTINC2+0, 0 
	MOVWF       R1 
	MOVF        POSTINC2+0, 0 
	MOVWF       R2 
	MOVLW       128
	XORWF       map_destroy_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       R2, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__map_destroy35
	MOVF        R1, 0 
	SUBWF       map_destroy_i_L0+0, 0 
L__map_destroy35:
	BTFSC       STATUS+0, 0 
	GOTO        L_map_destroy24
;map.c,125 :: 		if (hm->buckets[i])
	MOVFF       FARG_map_destroy_hm+0, FSR0L+0
	MOVFF       FARG_map_destroy_hm+1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVF        POSTINC0+0, 0 
	MOVWF       R4 
	MOVF        map_destroy_i_L0+0, 0 
	MOVWF       R0 
	MOVF        map_destroy_i_L0+1, 0 
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVF        R0, 0 
	ADDWF       R3, 0 
	MOVWF       FSR0L+0 
	MOVF        R1, 0 
	ADDWFC      R4, 0 
	MOVWF       FSR0L+1 
	MOVF        POSTINC0+0, 0 
	IORWF       POSTINC0+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_map_destroy26
;map.c,126 :: 		list_destroy(hm->buckets[i]);
	MOVFF       FARG_map_destroy_hm+0, FSR0L+0
	MOVFF       FARG_map_destroy_hm+1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVF        POSTINC0+0, 0 
	MOVWF       R4 
	MOVF        map_destroy_i_L0+0, 0 
	MOVWF       R0 
	MOVF        map_destroy_i_L0+1, 0 
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVF        R0, 0 
	ADDWF       R3, 0 
	MOVWF       FSR0L+0 
	MOVF        R1, 0 
	ADDWFC      R4, 0 
	MOVWF       FSR0L+1 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_list_destroy_list+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_list_destroy_list+1 
	CALL        _list_destroy+0, 0
L_map_destroy26:
;map.c,123 :: 		for (i = 0; i < hm->size; i++)
	INFSNZ      map_destroy_i_L0+0, 1 
	INCF        map_destroy_i_L0+1, 1 
;map.c,127 :: 		}
	GOTO        L_map_destroy23
L_map_destroy24:
;map.c,129 :: 		FreeMem((void *)hm->buckets, sizeof(plist_t) * hm->size);
	MOVFF       FARG_map_destroy_hm+0, FSR0L+0
	MOVFF       FARG_map_destroy_hm+1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_FreeMem_P+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_FreeMem_P+1 
	MOVLW       2
	ADDWF       FARG_map_destroy_hm+0, 0 
	MOVWF       FSR0L+0 
	MOVLW       0
	ADDWFC      FARG_map_destroy_hm+1, 0 
	MOVWF       FSR0L+1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	MOVWF       FARG_FreeMem_Size+0 
	MOVF        R2, 0 
	MOVWF       FARG_FreeMem_Size+1 
	RLCF        FARG_FreeMem_Size+0, 1 
	BCF         FARG_FreeMem_Size+0, 0 
	RLCF        FARG_FreeMem_Size+1, 1 
	CALL        _FreeMem+0, 0
;map.c,130 :: 		}
L_end_map_destroy:
	RETURN      0
; end of _map_destroy
