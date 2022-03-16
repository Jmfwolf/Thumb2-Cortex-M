		AREA	|.text|, CODE, READONLY, ALIGN=2
		THUMB

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; void _bzero( void *s, int n )
; Parameters
;	s 		- pointer to the memory location to zero-initialize
;	n		- a number of bytes to zero-initialize
; Return value
;   none
		EXPORT	_bzero
_bzero
		; implement your complete logic, including stack operations
		PUSH	{r1-r12, lr}
		EOR		r2, r2
_bz_loop
		STRB	r2, [r0], #1
		SUBS	r1, r1, #1
		BGT		_bz_loop
		MOV		pc, lr
		POP		{r1-r12, pc}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; char* _strncpy( char* dest, char* src, int size )
; Parameters
;   	dest 	- pointer to the buffer to copy to
;	src	- pointer to the zero-terminated string to copy from
;	size	- a total of n bytes
; Return value
;   dest
		EXPORT	_strncpy
_strncpy
		; implement your complete logic, including stack operations
		PUSH	{r1-r12, lr}
								;store destination for return
_str_loop
		LDRB	r5, [r1], #1
		STRB	r5, [r0], #1
		BEQ		_str_end
		SUBS	r2, r2, #1
		BGT		_str_loop
_str_end
		POP		{r1-r12, pc}
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; void* _malloc( int size )
; Parameters
;	size	- #bytes to allocate
; Return value
;   	void*	a pointer to the allocated space
		EXPORT	_malloc
_malloc
		; save registers
		push	{r1-r12, lr}
		; set the system call # to R7
		mov		r8, r0
		mov		r7, #4
	    SVC     #0x4
		MOVW	r4, #0x5000
		MOVT	r4, #0x2000
		LDR		r0, [r4]
		; resume registers
		POP		{r1-r12, pc}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; void _free( void* addr )
; Parameters
;	size	- the address of a space to deallocate
; Return value
;   	none
		EXPORT	_free
_free
		; save registers
		push	{r1-r12,lr}
		; set the system call # to R7
		mov		r8, r0
		mov		r7, #5
        SVC     #0x5

		; resume registers
		POP		{r1-r12,PC}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; unsigned int _alarm( unsigned int seconds )
; Parameters
;   seconds - seconds when a SIGALRM signal should be delivered to the calling program	
; Return value
;   unsigned int - the number of seconds remaining until any previously scheduled alarm
;                  was due to be delivered, or zero if there was no previously schedul-
;                  ed alarm. 
		EXPORT	_alarm
_alarm
		; save registers
		push{r1-r12,lr}
		; set the system call # to R7
		mov	r7, #1
        SVC     #0x1
		; resume registers	
		POP		{r1-r12,PC}	
			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; void* _signal( int signum, void *handler )
; Parameters
;   signum - a signal number (assumed to be 14 = SIGALRM)
;   handler - a pointer to a user-level signal handling function
; Return value
;   void*   - a pointer to the user-level signal handling function previously handled
;             (the same as the 2nd parameter in this project)
		EXPORT	_signal
_signal
		; save registers
		push	{r1-r12,lr}
		; set the system call # to R7
			MOV	r7, #2
        	SVC     #0x2
		; resume registers
		POP		{r1-r12,PC}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;int _atoi(char* str)
; Parameters
;   str - a pointer to the beginning of a string
; Return Value
;   int  - the integer value extracted from string
;
		Export _atoi
_atoi
		push {r1-r11}
		
		ldrb    r3, [r0]       
        mov     r2, r0
        cbz     r3, _atoi_end
        movs    r0, #0
        movs    r1, #10
_atoi_loop
        mla     r0, r1, r0, r3
        ldrb    r3, [r2, #1]! 
        subs    r0, r0, #48
        cmp     r3, #0
        bne     _atoi_loop
        pop    {r1-r11}
		bx		lr
_atoi_end
        mov     r0, r3
		pop    {r1-r11}
        bx      lr

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		END			