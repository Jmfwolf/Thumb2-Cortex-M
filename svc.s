		AREA	|.text|, CODE, READONLY, ALIGN=2
		THUMB

		IMPORT	_kfree
		IMPORT	_kalloc
		IMPORT	_signal_handler
		IMPORT	_timer_start

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; System Call Table
SYSTEMCALLTBL	EQU		0x20007B00 ; originally 0x20007500
SYS_EXIT		EQU		0x0		; address 20007B00
SYS_ALARM		EQU		0x1		; address 20007B04
SYS_SIGNAL		EQU		0x2		; address 20007B08
SYS_MEMCPY		EQU		0x3		; address 20007B0C
SYS_MALLOC		EQU		0x4		; address 20007B10
SYS_FREE		EQU		0x5		; address 20007B14

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; System Call Table Initialization
		EXPORT	_syscall_table_init
_syscall_table_init
	;; Implement by yourself
		LDR     	R0, =SYSTEMCALLTBL
		LDR			R1, =_timer_start
		LDR			R2, =SYS_ALARM
		STR			R1, [R0, R2, LSL #2]
		LDR			R1, =_signal_handler
		LDR			R2, =SYS_SIGNAL
		STR			R1, [R0, R2, LSL #2]
		LDR			R1, =_kalloc
		LDR			R2, =SYS_MALLOC
		STR			R1, [R0, R2, LSL #2]
		LDR			R1, =_kfree
		LDR			R2, =SYS_FREE
		STR			R1, [R0, R2, LSL #2]

		MOV		pc, lr

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; System Call Table Jump Routine
        EXPORT	_syscall_table_jump
_syscall_table_jump
	;; Implement by yourself
	
		PUSH	{R1-R11, lr}
		LDR		R11, =SYSTEMCALLTBL
		ADD		r11, r7, LSL #2
		LDR		r6,	[r11]
		BLX		r6
		POP		{R1-R11, PC}
				
		END