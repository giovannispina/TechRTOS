
_compare:

;memory.c,5 :: 		int16 compare(void *ptr, void *ptr2)
;memory.c,7 :: 		return (ptr == ptr2) ? 0 : 1;
	MOVF        FARG_compare_ptr+1, 0 
	XORWF       FARG_compare_ptr2+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__compare6
	MOVF        FARG_compare_ptr2+0, 0 
	XORWF       FARG_compare_ptr+0, 0 
L__compare6:
	BTFSS       STATUS+0, 2 
	GOTO        L_compare0
	CLRF        R2 
	GOTO        L_compare1
L_compare0:
	MOVLW       1
	MOVWF       R2 
L_compare1:
	MOVF        R2, 0 
	MOVWF       R0 
	MOVLW       0
	BTFSC       R2, 7 
	MOVLW       255
	MOVWF       R1 
;memory.c,8 :: 		}
L_end_compare:
	RETURN      0
; end of _compare

_tech_memory_init:

;memory.c,10 :: 		void tech_memory_init()
;memory.c,12 :: 		MM_Init();
	CALL        _MM_Init+0, 0
;memory.c,14 :: 		memory = map_create(10, NULL, &compare);
	MOVLW       10
	MOVWF       FARG_map_create_size+0 
	MOVLW       0
	MOVWF       FARG_map_create_size+1 
	CLRF        FARG_map_create_hash+0 
	CLRF        FARG_map_create_hash+1 
	CLRF        FARG_map_create_hash+2 
	CLRF        FARG_map_create_hash+3 
	MOVLW       _compare+0
	MOVWF       FARG_map_create_cmp+0 
	MOVLW       hi_addr(_compare+0)
	MOVWF       FARG_map_create_cmp+1 
	MOVLW       FARG_compare_ptr+0
	MOVWF       FARG_map_create_cmp+2 
	MOVLW       hi_addr(FARG_compare_ptr+0)
	MOVWF       FARG_map_create_cmp+3 
	CALL        _map_create+0, 0
	MOVF        R0, 0 
	MOVWF       _memory+0 
	MOVF        R1, 0 
	MOVWF       _memory+1 
;memory.c,15 :: 		}
L_end_tech_memory_init:
	RETURN      0
; end of _tech_memory_init

_tech_malloc:

;memory.c,17 :: 		void *tech_malloc(uint32 size)
;memory.c,21 :: 		ptr = Malloc(size);
	MOVF        FARG_tech_malloc_size+0, 0 
	MOVWF       FARG_Malloc_Size+0 
	MOVF        FARG_tech_malloc_size+1, 0 
	MOVWF       FARG_Malloc_Size+1 
	CALL        _Malloc+0, 0
	MOVF        R0, 0 
	MOVWF       tech_malloc_ptr_L0+0 
	MOVF        R1, 0 
	MOVWF       tech_malloc_ptr_L0+1 
;memory.c,22 :: 		assert(ptr);
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_tech_malloc2
	BCF         INTCON+0, 7 
	SLEEP
	CLRF        STKPTR+0 
	CALL        _tech_freeAll+0, 0
	GOTO        0
L_tech_malloc2:
;memory.c,24 :: 		map_insert(memory, ptr, (void *)size);
	MOVF        _memory+0, 0 
	MOVWF       FARG_map_insert_hm+0 
	MOVF        _memory+1, 0 
	MOVWF       FARG_map_insert_hm+1 
	MOVF        tech_malloc_ptr_L0+0, 0 
	MOVWF       FARG_map_insert_key+0 
	MOVF        tech_malloc_ptr_L0+1, 0 
	MOVWF       FARG_map_insert_key+1 
	MOVF        FARG_tech_malloc_size+0, 0 
	MOVWF       FARG_map_insert_value+0 
	MOVF        FARG_tech_malloc_size+1, 0 
	MOVWF       FARG_map_insert_value+1 
	CALL        _map_insert+0, 0
;memory.c,25 :: 		return ptr;
	MOVF        tech_malloc_ptr_L0+0, 0 
	MOVWF       R0 
	MOVF        tech_malloc_ptr_L0+1, 0 
	MOVWF       R1 
;memory.c,26 :: 		}
L_end_tech_malloc:
	RETURN      0
; end of _tech_malloc

_tech_calloc:

;memory.c,28 :: 		void *tech_calloc(uint32 value, uint32 size)
;memory.c,32 :: 		ptr = Malloc(size);
	MOVF        FARG_tech_calloc_size+0, 0 
	MOVWF       FARG_Malloc_Size+0 
	MOVF        FARG_tech_calloc_size+1, 0 
	MOVWF       FARG_Malloc_Size+1 
	CALL        _Malloc+0, 0
	MOVF        R0, 0 
	MOVWF       tech_calloc_ptr_L0+0 
	MOVF        R1, 0 
	MOVWF       tech_calloc_ptr_L0+1 
;memory.c,33 :: 		assert(ptr);
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_tech_calloc3
	BCF         INTCON+0, 7 
	SLEEP
	CLRF        STKPTR+0 
	CALL        _tech_freeAll+0, 0
	GOTO        0
L_tech_calloc3:
;memory.c,35 :: 		memset(ptr, value, size);
	MOVF        tech_calloc_ptr_L0+0, 0 
	MOVWF       FARG_memset_p1+0 
	MOVF        tech_calloc_ptr_L0+1, 0 
	MOVWF       FARG_memset_p1+1 
	MOVF        FARG_tech_calloc_value+0, 0 
	MOVWF       FARG_memset_character+0 
	MOVF        FARG_tech_calloc_size+0, 0 
	MOVWF       FARG_memset_n+0 
	MOVF        FARG_tech_calloc_size+1, 0 
	MOVWF       FARG_memset_n+1 
	CALL        _memset+0, 0
;memory.c,36 :: 		map_insert(memory, ptr, (void *)size);
	MOVF        _memory+0, 0 
	MOVWF       FARG_map_insert_hm+0 
	MOVF        _memory+1, 0 
	MOVWF       FARG_map_insert_hm+1 
	MOVF        tech_calloc_ptr_L0+0, 0 
	MOVWF       FARG_map_insert_key+0 
	MOVF        tech_calloc_ptr_L0+1, 0 
	MOVWF       FARG_map_insert_key+1 
	MOVF        FARG_tech_calloc_size+0, 0 
	MOVWF       FARG_map_insert_value+0 
	MOVF        FARG_tech_calloc_size+1, 0 
	MOVWF       FARG_map_insert_value+1 
	CALL        _map_insert+0, 0
;memory.c,37 :: 		return ptr;
	MOVF        tech_calloc_ptr_L0+0, 0 
	MOVWF       R0 
	MOVF        tech_calloc_ptr_L0+1, 0 
	MOVWF       R1 
;memory.c,38 :: 		}
L_end_tech_calloc:
	RETURN      0
; end of _tech_calloc

_tech_free:

;memory.c,40 :: 		void tech_free(void *ptr)
;memory.c,44 :: 		node = map_find(memory, ptr);
	MOVF        _memory+0, 0 
	MOVWF       FARG_map_find_hm+0 
	MOVF        _memory+1, 0 
	MOVWF       FARG_map_find_hm+1 
	MOVF        FARG_tech_free_ptr+0, 0 
	MOVWF       FARG_map_find_key+0 
	MOVF        FARG_tech_free_ptr+1, 0 
	MOVWF       FARG_map_find_key+1 
	CALL        _map_find+0, 0
	MOVF        R0, 0 
	MOVWF       tech_free_node_L0+0 
	MOVF        R1, 0 
	MOVWF       tech_free_node_L0+1 
;memory.c,45 :: 		assert(node);
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_tech_free4
	BCF         INTCON+0, 7 
	SLEEP
	CLRF        STKPTR+0 
	CALL        _tech_freeAll+0, 0
	GOTO        0
L_tech_free4:
;memory.c,46 :: 		FreeMem(ptr, (uint32)node->value);
	MOVF        FARG_tech_free_ptr+0, 0 
	MOVWF       FARG_FreeMem_P+0 
	MOVF        FARG_tech_free_ptr+1, 0 
	MOVWF       FARG_FreeMem_P+1 
	MOVLW       6
	ADDWF       tech_free_node_L0+0, 0 
	MOVWF       FSR0L+0 
	MOVLW       0
	ADDWFC      tech_free_node_L0+1, 0 
	MOVWF       FSR0L+1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVLW       0
	MOVWF       R2 
	MOVWF       R3 
	MOVF        R0, 0 
	MOVWF       FARG_FreeMem_Size+0 
	MOVF        R1, 0 
	MOVWF       FARG_FreeMem_Size+1 
	CALL        _FreeMem+0, 0
;memory.c,47 :: 		}
L_end_tech_free:
	RETURN      0
; end of _tech_free

_tech_realloc:

;memory.c,49 :: 		void *tech_realloc(void *ptr, uint32 size)
;memory.c,52 :: 		new_ptr = tech_malloc(size);
	MOVF        FARG_tech_realloc_size+0, 0 
	MOVWF       FARG_tech_malloc_size+0 
	MOVF        FARG_tech_realloc_size+1, 0 
	MOVWF       FARG_tech_malloc_size+1 
	MOVF        FARG_tech_realloc_size+2, 0 
	MOVWF       FARG_tech_malloc_size+2 
	MOVF        FARG_tech_realloc_size+3, 0 
	MOVWF       FARG_tech_malloc_size+3 
	CALL        _tech_malloc+0, 0
	MOVF        R0, 0 
	MOVWF       tech_realloc_new_ptr_L0+0 
	MOVF        R1, 0 
	MOVWF       tech_realloc_new_ptr_L0+1 
;memory.c,54 :: 		memcpy(new_ptr, ptr, size);
	MOVF        R0, 0 
	MOVWF       FARG_memcpy_d1+0 
	MOVF        R1, 0 
	MOVWF       FARG_memcpy_d1+1 
	MOVF        FARG_tech_realloc_ptr+0, 0 
	MOVWF       FARG_memcpy_s1+0 
	MOVF        FARG_tech_realloc_ptr+1, 0 
	MOVWF       FARG_memcpy_s1+1 
	MOVF        FARG_tech_realloc_size+0, 0 
	MOVWF       FARG_memcpy_n+0 
	MOVF        FARG_tech_realloc_size+1, 0 
	MOVWF       FARG_memcpy_n+1 
	CALL        _memcpy+0, 0
;memory.c,55 :: 		tech_free(ptr);
	MOVF        FARG_tech_realloc_ptr+0, 0 
	MOVWF       FARG_tech_free_ptr+0 
	MOVF        FARG_tech_realloc_ptr+1, 0 
	MOVWF       FARG_tech_free_ptr+1 
	CALL        _tech_free+0, 0
;memory.c,56 :: 		return new_ptr;
	MOVF        tech_realloc_new_ptr_L0+0, 0 
	MOVWF       R0 
	MOVF        tech_realloc_new_ptr_L0+1, 0 
	MOVWF       R1 
;memory.c,57 :: 		}
L_end_tech_realloc:
	RETURN      0
; end of _tech_realloc

_tech_freeAll:

;memory.c,59 :: 		void tech_freeAll()
;memory.c,61 :: 		map_destroy(memory);
	MOVF        _memory+0, 0 
	MOVWF       FARG_map_destroy_hm+0 
	MOVF        _memory+1, 0 
	MOVWF       FARG_map_destroy_hm+1 
	CALL        _map_destroy+0, 0
;memory.c,62 :: 		MM_TotalFreeMemSize();
	CALL        _MM_TotalFreeMemSize+0, 0
;memory.c,63 :: 		}
L_end_tech_freeAll:
	RETURN      0
; end of _tech_freeAll
