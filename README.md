# Thumb2-Cortex-M

## C Standard Library Functions Implemented in Thumb2 Assembly
   Implemented functions have a leading underscore to differentiate those same functions in the C library.
   
## Implemented Functions
   bzero
   strncpy
   malloc
   free
   signal
   alarm
   atoi
   
   Signal calls the SVC handler to call the timer function signal handler.
   Alarm calls the SVC handler to call the timer start function.
   Malloc and Free are user functions that call the SVC handler to call a privileged function, kalloc and kfree respectively.
   Kalloc and Kfree use the buddy memory system to allocate and free memory. They use recursion to accomplish this, ralloc and rfree respectively.
   Atoi was an extra credit portion and as a result is not fully implemented or useable.
   
## Other Implementations
   startup has been modified to appropriately call the customized functions.
   svc.s is where the system call jump table is intialized and used as a function directory.
   heap.s was is where the memory control block is initialized. The MCB governs the space of the heap in a managable fashion. Showing used portions of the heap with a bit in the 0 place.
   timer.s handles the timer, alarm, and signal handler for system interrupts.
