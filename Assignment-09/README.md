# OS Assignment 9 — xv6 RISC-V adaptation starter pack

This bundle is prepared for the xv6 RISC-V repository visible in your VS Code screenshots. Your assignment PDF specifies xv6 x86, so this is an adaptation, not a drop-in x86 solution. The kernel APIs and page-table format differ.

## Included

- `user/pttest.c` — calls `vmprint()` before and after `sbrk(4 * 4096)`.
- `user/faulttest.c` — reserves 32 pages and writes to five distinct pages; requires a working `getfaults()` system call and lazy allocation kernel changes.
- `user/pagerepl.c` — FIFO/LRU simulator for the supplied reference string and frame counts 3, 4, and 5. Optional: pass page numbers as command-line arguments.
- `screenshots/` — screenshots supplied in the conversation showing your assignment directory and VS Code project setup. These are setup screenshots, not evidence of successful test output.

## Important status

This is a starter bundle, not a verified complete kernel patch. The exact kernel changes depend on the precise xv6-RISC-V revision in your repository. In particular, `vmprint()` and `getfaults()` must be registered as system calls, and lazy allocation must be implemented in the kernel before `faulttest` can pass.

## Install into your copied xv6 repository

From the root of your Assignment 9 `xv6` folder, copy the user programs:

```sh
cp /path/to/Assignment-09-Starter/user/pttest.c user/
cp /path/to/Assignment-09-Starter/user/faulttest.c user/
cp /path/to/Assignment-09-Starter/user/pagerepl.c user/
```

Add `_pttest`, `_faulttest`, and `_pagerepl` to the `UPROGS` list in `Makefile`, following the existing format. Before building, complete the kernel system-call and lazy-allocation changes for your xv6 revision.

## Screenshot policy

No runtime screenshots have been fabricated. To produce real evidence, run the programs in QEMU after implementation and capture the terminal showing the actual output.
