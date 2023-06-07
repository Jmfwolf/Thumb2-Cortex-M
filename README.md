# Thumb2-Cortex-M

This repository contains an implementation of several C standard library functions in Thumb2 assembly for the Cortex-M microcontroller. This project was undertaken as an exploration of low-level programming, combining C and Thumb2 assembly to build a custom C library.

## About

The Thumb2-Cortex-M project showcases the implementation of various C standard library functions in Thumb2 assembly. The objective was to gain a deeper understanding of how these functions work at the assembly level, while also providing a practical toolkit for use in Cortex-M microcontroller programming. Each implemented function is prefixed with an underscore (_) to distinguish it from the original functions in the C library.

## Implemented Functions

The repository includes the following C standard library functions implemented in Thumb2 assembly:

- `_bzero`: Sets the values of a block of memory to zero.
- `_strncpy`: Copies a specified number of characters from one string to another.
- `_malloc` and `_free`: These are user functions that interact with the SVC handler to call the correspondingprivileged functions, `_kalloc` and `_kfree`. The latter pair utilizes the buddy memory system for memory allocation and deallocation, using recursion in the form of `_ralloc` and `_rfree`.
- `_signal` and `_alarm`: These functions interact with the SVC handler to call appropriate timer functions for signal handling and timer start, respectively.
- `_atoi`: This function converts a string into an integer. It was implemented as an extra credit challenge and is not fully functional.

## Other Implementations

In addition to the C standard library functions, the project also includes:

- `startup`: This script has been modified to call the custom functions appropriately.
- `svc.s`: This is where the system call jump table is initialized and used as a function directory.
- `heap.s`: This script initializes the Memory Control Block (MCB), which manages the heap's space. It also provides a visual representation of used portions of the heap with a bit in the 0 place.
- `timer.s`: This script handles the timer, alarm, and signal handler for system interrupts.
