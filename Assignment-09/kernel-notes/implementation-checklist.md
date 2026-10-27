# Kernel implementation checklist (xv6 RISC-V)

## Q1: vmprint
- Implement a recursive walk over Sv39 levels 2, 1, and 0 in `kernel/vm.c`.
- Print user leaf mappings and P/W/U flags (`PTE_V`, `PTE_W`, `PTE_U`).
- Count valid user leaf pages and page-table pages, clearly defining whether the root page table is included.
- Add the prototype to `kernel/defs.h`.
- Add `sys_vmprint()` to `kernel/sysproc.c`.
- Add a free syscall number in `kernel/syscall.h`, dispatch entry in `kernel/syscall.c`, declaration in `user/user.h`, and stub in `user/usys.pl`.
- Register `_pttest` in `Makefile`.

## Q2: lazy allocation
- Adapt `sys_sbrk()` in `kernel/sysproc.c` so positive increments reserve virtual size without allocating pages.
- Ensure `uvmunmap()`/deallocation and `uvmcopy()` tolerate unallocated holes appropriately for the chosen xv6 revision.
- Handle user page faults in `kernel/trap.c`: validate the address against the process size, allocate/zero a page, map it with user/write permissions, increment a per-process counter, and kill the process on invalid access or allocation failure.
- Add and initialize a fault counter in `kernel/proc.h` / process initialization paths.
- Add `getfaults()` system-call number, handler, dispatch entry, user declaration, and stub.
- Register `_faulttest` in `Makefile`.

## Q3: FIFO/LRU
- Add `_pagerepl` to `UPROGS`.
- Run with the supplied 20-page reference string and 3, 4, and 5 frames.
- Verify the 3-frame counts against the assignment's expected FIFO=15 and LRU=12.

The assignment PDF targets x86; this checklist describes the adaptation to the RISC-V repository currently being used.
