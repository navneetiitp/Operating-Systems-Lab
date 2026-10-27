# OS Assignment 9 — Solution Bundle (xv6-RISC-V adaptation)

This ZIP contains the three user-level solutions plus kernel implementation snippets and setup instructions. It intentionally contains no screenshots.

## Important compatibility note
The assignment PDF specifies **xv6 x86** (`walkpgdir`, `deallocuvm`, `rcr2`, two-level page tables). Your working repository and screenshots show **xv6-RISC-V** (`pagetable_t`, Sv39, `r_stval`, three-level page tables). The kernel snippets here are adapted for RISC-V and are not an x86 drop-in patch. Your repository also has custom thread, semaphore, and shared-memory syscalls, so keep its existing files and syscall numbers intact.

## Included files
- `user/pttest.c`: calls `vmprint()` before and after reserving four pages.
- `user/faulttest.c`: reserves 32 pages and writes to five distinct pages; expects `getfaults()` to return 5.
- `user/pagerepl.c`: FIFO and LRU simulation, per-reference frame trace, and summary table for 3, 4, and 5 frames. It uses integer percentages because xv6's `printf` does not support floating-point formatting.
- `kernel-snippets/vmprint.c.txt`: recursive Sv39 page-table traversal and summary counters.
- `kernel-snippets/lazy-allocation-riscv.txt`: sys_sbrk, trap, and process-counter changes.
- `kernel-snippets/syscall-handlers.c.txt`: kernel syscall handlers and process counter notes.
- `kernel-snippets/syscall-registration.txt`: registration checklist for this repository's syscall layout.
- `docs/report.md`: short report text to customize after testing.

## Integration steps
1. Copy `user/pttest.c`, `user/faulttest.c`, and `user/pagerepl.c` into your xv6 `user/` directory.
2. Apply the kernel snippets to the existing files; do not replace whole `syscall.c`, `syscall.h`, `defs.h`, `proc.c`, `proc.h`, or `trap.c` files with versions from a different xv6 fork.
3. Allocate two unique syscall numbers for `vmprint` and `getfaults` in `kernel/syscall.h`. Preserve every number already used in your fork. Register kernel handlers and user stubs as described in `kernel-snippets/syscall-registration.txt`.
4. Add `$U/_pttest`, `$U/_faulttest`, and `$U/_pagerepl` to the existing `UPROGS` list in the root `Makefile`.
5. Build and test from the xv6 root with `make clean && make qemu`.

## Expected checks
- Q1: `vmprint` should show four more valid user leaf mappings after `sbrk(4 * 4096)` **only if those pages are actually touched/allocated**. Under lazy allocation, merely calling `sbrk` reserves address space but does not map four pages; update the test to touch one byte in each of the four pages before the second `vmprint()` if the assignment expects four new mappings.
- Q2: `faulttest` touches five distinct pages, so the page-fault counter should report 5, assuming no earlier lazy faults are counted in that process.
- Q3: For the given reference string and 20 references, expected faults are FIFO/LRU: 3 frames = 15/12, 4 frames = 10/8, 5 frames = 9/7. Integer hit ratios are respectively FIFO/LRU: 25%/40%, 50%/60%, and 55%/65%.

The bundle has not been compiled against your exact custom kernel fork; syscall numbers and trap integration must be reconciled with your existing source before building.
