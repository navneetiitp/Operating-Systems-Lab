# Operating Systems — Assignment 10 Report

## Platform

This implementation targets the official MIT xv6-RISC-V teaching operating system. The
assignment handout uses x86 names; the RISC-V equivalents used here are `walk()`, `PTE_V`,
and `user/usys.pl`.

## Q1 — Physical memory allocation statistics

The allocator in `kernel/kalloc.c` maintains counters for successful allocations and page
releases. The counters are reset after the initial free-list construction so boot-time setup is
not counted as runtime deallocation. `getmemstats()` locks the allocator while taking a
consistent snapshot and counting pages on the free list. The `memstats` system call displays
total allocations, total frees, currently allocated pages, and currently available pages.
`memtest` allocates three pages using `sbrk()`, touches each page, displays the statistics,
releases the memory, and displays the updated statistics.

## Q2 — Virtual-to-physical translation

The `vtop` system call validates the supplied virtual address and calls `walk()` on the current
process page table. For a valid PTE, it obtains the physical page base with `PTE2PA()` and adds
the original page offset. Unmapped or out-of-range addresses return `(uint64)-1`. `vttest`
checks two allocated addresses and one deliberately unmapped address.

## Q3 — Page-table information and read-only protection

`pageinfo` reports the physical page number and valid, writable, and user-accessible flags.
`setreadonly` clears `PTE_W` in the current process's PTE and flushes the local TLB using
`sfence_vma()`. `pagetest` allocates and touches a page, inspects its permissions, changes it
to read-only, inspects it again, and attempts a write. The resulting user store page fault and
process termination are intentional.

## Q4 — Page replacement algorithms

`pagereplace` simulates FIFO, LRU, and Optimal replacement using the reference string
`7 0 1 2 0 3 0 4 2 3 0 3 2 1 2 0 1 7 0 1`. It prints frame contents and the hit/fault result
after each reference, then compares all algorithms with 3, 4, and 5 frames. Hit and fault ratios
are calculated over 20 references.

## Verification

Compilation and QEMU execution must be performed on a machine with the RISC-V GNU toolchain
and QEMU installed. Add terminal screenshots and update this report with the observed output
after running all four programs. Do not represent predicted output as an actual execution result.


### Q4 comparison results (20 references)

| Frames | Algorithm | Page faults | Page hits | Hit ratio | Fault ratio |
|---:|---|---:|---:|---:|---:|
| 3 | FIFO | 15 | 5 | 25% | 75% |
| 3 | LRU | 12 | 8 | 40% | 60% |
| 3 | Optimal | 9 | 11 | 55% | 45% |
| 4 | FIFO | 10 | 10 | 50% | 50% |
| 4 | LRU | 8 | 12 | 60% | 40% |
| 4 | Optimal | 8 | 12 | 60% | 40% |
| 5 | FIFO | 9 | 11 | 55% | 45% |
| 5 | LRU | 7 | 13 | 65% | 35% |
| 5 | Optimal | 7 | 13 | 65% | 35% |

For this reference string, Optimal gives the fewest faults with three frames. With four and
five frames, Optimal and LRU tie. FIFO has the most faults in all three frame configurations.
These counts are algorithmically calculated from the supplied reference string; confirm them
against the xv6 program output during local execution.
