# Build and test

From the root of your xv6-riscv source tree after integration:

```sh
make clean
make qemu
```

At the xv6 shell, run:

```text
$ vatest
$ memtest
$ vmprinttest
$ lazytest
```

Exit QEMU with `Ctrl-a` then `x` (depending on your terminal setup).

## Expected behavior

- `vatest`: global and local variables should have valid mappings; the deliberately invalid/unmapped address should report `-1`. After `fork()`, a global variable should have the same VA but normally a different PA in the parent and child.
- `memtest`: reports total/free pages, process size in pages, and page-table pages. Allocating/touching memory should reduce free pages. After a child exits and is reaped, the free-page count should return close to its earlier value; minor timing/output differences can occur if the shell or other processes allocate memory.
- `vmprinttest`: shows a page-table dump at startup, after adding two pages, and after shrinking. The user-side heap entries should appear/disappear accordingly. The output also summarizes valid kernel-half root entries.
- `lazytest`: a large positive `sbrk()` should succeed before all its pages are physically allocated. Touching a few pages should consume frames. `fork()`, child exit/reaping, and a syscall that reads from a previously untouched buffer exercise the lazy-page paths.

## Important test notes

1. This package has not been compiled against your exact xv6 checkout. Treat the first build as the integration test.
2. `getmeminfo()` counts managed RAM pages beginning at the end of the kernel image and ending at `PHYSTOP`; it does not count reserved memory below `end`.
3. The `page_table_pages` count includes the root page table and valid non-leaf page-table pages, including the process page table's kernel-side mapping structures.
4. xv6's shell and kernel activity can change the free-page count between separate observations. Compare values within one test run and avoid expecting an exact constant across boots.
5. The RISC-V adaptation does not print x86 `PTE_P`; it reports `PTE_V`, `PTE_R`, `PTE_W`, `PTE_X`, and `PTE_U`.
