		AREA	|.text|, CODE, READONLY, ALIGN=2
		THUMB

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; System Call Table
HEAP_TOP	EQU		0x20001000
HEAP_BOT	EQU		0x20004FE0
MAX_SIZE	EQU		0x00004000		; 16KB = 2^14
MIN_SIZE	EQU		0x00000020		; 32B  = 2^5
	
MCB_TOP		EQU		0x20006800      	; 2^10B = 1K Space
MCB_BOT		EQU		0x20006BFE
MCB_ENT_SZ	EQU		0x00000002		; 2B per entry
MCB_TOTAL	EQU		512			; 2^9 = 512 entries
	
INVALID		EQU		-1			; an invalid id
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Memory Control Block Initialization
		EXPORT	_heap_init
_heap_init


_kinit
	;; Implement by yourself
		PUSH	{R1-R11, LR}
	    LDR    R0, =MCB_TOP
        LDR    R1, =MCB_BOT
		EOR		R2, R2, R2
_kinit_loop
		CMP		R1, R0
		BEQ		_kinit_end
		STRB	R2, [R1]
		SUB		R1, R1, #1
_kinit_end
		LDR		R2, =MAX_SIZE
		STR		R2, [R0]
		POP		{R1-R11, PC}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Kernel Memory Allocation
; void* _k_alloc( int size )
		EXPORT	_kalloc
_kalloc
	;; Implement by yourself
		push	{r1-r12, lr}
		mov		r0, r8
		ldr		r1, =MCB_TOP
		ldr		r2, =MCB_BOT
		BL		_ralloc
		MOVW	r4, #0x5000
		MOVT	r4, #0x2000
		STR		r0, [r4]
		pop     {r1-r12, pc}

_ralloc
		push	{r4, lr}
		mov		r3, r1
        ldr     r4, =MIN_SIZE
        cmp     r0, r4
        it      lt
        movlt   r0, r4
        ldr     r4, =MCB_BOT
        cmp     r4, r2
        it      eq
        addeq   r2, r2, #2
        subs    r2, r2, r3
        asrs    r2, r2, #1
        ldrsh   r1, [r3]
        cmp     r1, r0
        blt     _ralloc_Lrange
        tst     r1, #1
        bne     _ralloc_Lrange
        cmp     r1, r0
        beq     _ralloc_range
        cmp     r0, r1, lsl #1
        ble     _ralloc_hit
_ralloc_range
        orr     r1, r1, #1
        strh    r1, [r3]
        ldr     r1, =MCB_TOP
        subs    r1, r3, r1
        ldr     r0, =HEAP_TOP
        add     r0, r0, r1, lsl #4
        b       _ralloc_end
_ralloc_hit
        asrs    r1, r1, #1
        strh    r1, [r3]    
        strh    r1, [r2, r3]
        add     r2, r2, r3
        mov     r1, r3
        bl		_ralloc
		b 		_ralloc_end
_ralloc_Lrange
        ldr     r2, =MAX_SIZE
        cmp     r2, r1
        it      ne
        cmpne   r4, r3
        it      le
        movle   r0, #0
        bgt     _ralloc_Rrange
_ralloc_end	
		pop		{r4, pc}
_ralloc_Rrange
        asrs    r2, r1, #4
        adds    r1, r2, r3
        ldrsh   r2, [r2, r3]
        add     r2, r1, r2, asr #4
        bl      _ralloc
		b		_ralloc_end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Kernel Memory De-allocation
; void free( void *ptr )
		EXPORT	_kfree
_kfree
	;; Implement by yourself
		MOV		r0, r8

		LDR		r2, =HEAP_TOP
		cmp     r2, r0
		BGT		_kfree_null
		LDR		r1, =HEAP_BOT
		PUSH	{r4, lr}
		MOV		r4, r0
		CMP		r1, r0
		BLT		_kfree_end
		LDR		r0, =MCB_TOP
		SUBS    r2, r4, r2
        ADD     r0, r0, r2, asr #4
		BL		_rfree
		CBZ		r0, _kfree_end
		MOV		r0, r4
		POP		{r4, pc}
_kfree_end
		EOR		r0, r0, r0
		POP		{r4, pc}						; return from rfree( )
_kfree_null
		EOR		r0, r0, r0
		BX		lr
_rfree
        push    {r1-r11,lr}
        mov     r5, r0
		mov		r8, #0
        ldr   	r6, =MCB_TOP
		ldr		r7, =MCB_BOT
		sub		r9, r0, r6
		
_rfree_body_logic

        ldrsh   r4, [r5]
        mov     r0, r9
        bic     r4, r4, #1
        strh    r4, [r5]      
        asrs    r4, r4, #4
        mov     r1, r4
		bl		_rdiv_
        ands    r0, r0, #1
        add     r3, r5, r4
        it      ne
        subne   r3, r5, r4
        cmp     r6, r3
        bgt     _rfree_end
        cmp     r7, r3
        blt     _rfree_end
		ldrsh   r1, [r3]
        mvns    r2, r1
        cmp     r1, #0
        ite     eq
        moveq   r2, #0
        andne   r2, r2, #1
        cbz     r2, _rfree_end
        cbz     r0, _rfree_left
        strh    r8, [r5]        
        sub     r9, r3, r6
        mov     r5, r3
        ldrsh   r2, [r3]
        lsls    r2, r2, #1
        strh    r2, [r3]        
        b       _rfree_body_logic
_rfree_left

        strh    r0, [r3]        
        ldrsh   r3, [r5]
        lsls    r3, r3, #1
        strh    r3, [r5]       
        b       _rfree_body_logic
_rfree_end
        pop     {r1-r11, pc}
_rdiv_
		udiv	r0, r0, r1
		bx		lr
		
		END