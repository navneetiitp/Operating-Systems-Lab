# Operating Systems Assignment 10 — MIT xv6-RISC-V

This package contains an implementation overlay for all four questions in the supplied assignment.

## Version mapping

The handout uses x86 xv6 terminology. This package targets the official MIT **xv6-RISC-V**
repository, using `walk()` instead of `walkpgdir()`, `PTE_V` instead of `PTE_P`, and
`user/usys.pl` to generate `user/usys.S`.

Official source: https://github.com/mit-pdos/xv6-riscv

## Contents

- `user/memtest.c` — Q1 allocator statistics test.
- `user/vttest.c` — Q2 virtual-to-physical translation test.
- `user/pagetest.c` — Q3 page permission test; its deliberate write should cause a user page fault.
- `user/pagereplace.c` — Q4 FIFO, LRU, and Optimal simulations.
- `tools/apply.py` — applies kernel/system-call changes and copies test programs into xv6.
- `docs/report.md` — short report draft.
- `docs/verification-checklist.md` — build/run and screenshot checklist.

## Apply the overlay

Install the RISC-V GNU toolchain and QEMU following the xv6 README, then:

```sh
git clone https://github.com/mit-pdos/xv6-riscv.git
cd xv6-riscv
python3 /path/to/OS_Assignment_10_xv6_RISCV/tools/apply.py
make clean
make qemu
```

At the xv6 shell:

```sh
memtest
vttest
pagetest
pagereplace
```

`pagetest` intentionally writes to a read-only page. A user store page fault and termination of
that test process are expected; the shell should remain available.

## Important notes

1. The patcher targets the upstream RISC-V layout in which the stock syscall numbers end at
   `SYS_sync = 22`. It stops if expected source anchors are missing.
2. Allocator counters are reset after initial free-list construction. `currently allocated` is
   `total_allocated - total_freed`; `available` is counted from the free list.
3. `vtop` returns `(uint64)-1` for an unmapped/out-of-range address.
4. Screenshots are not fabricated. Capture them from your own QEMU terminal and add them to
   your submission after running the programs.
5. GitHub was unreachable from the file-generation environment, so the complete upstream
   xv6 repository is not bundled. This is an overlay to apply to a clean official checkout.
   Compilation and runtime verification remain to be done locally.


## Simulated sample outputs

The `simulated_outputs/` folder contains artificial terminal transcripts for Q1-Q4.
They are explicitly labeled as simulated and are not actual xv6/QEMU screenshots or
proof of execution. Use them only as formatting/expected-behavior references.
