# Integration guide

Use the standard MIT `xv6-riscv` tree. Keep a backup or create a Git branch before editing.

## 1. Add the shared structure

Copy `user/meminfo.h` into `user/meminfo.h`. Also copy the same file to `kernel/meminfo.h` (the kernel version uses the same fixed-width field layout).

## 2. `kernel/defs.h`

Add declarations near the existing VM / allocator declarations:

```c
uint64 freepages(void);
uint64 totalpages(void);
uint64 vmcountpt(pagetable_t);
void vmprint(pagetable_t);
int uvmfault(pagetable_t, uint64, uint64);
```

If `pagetable_t` is not yet declared at the point you add these, place the VM declarations after the existing `typedef uint64 *pagetable_t;` from `kernel/riscv.h` is available through the normal includes. In standard xv6-riscv, `defs.h` already uses `pagetable_t` in VM prototypes.

## 3. `kernel/kalloc.c`

Add `uint64 free_pages;` to the `kmem` structure. Add a file-scope `static uint64 total_pages_count;`.

In `kinit()`, before or after `freerange(end, (void*)PHYSTOP)`, set:

```c
total_pages_count = (PHYSTOP - PGROUNDUP((uint64)end)) / PGSIZE;
```

Increment `kmem.free_pages` under `kmem.lock` whenever `kfree()` puts a page on the free list. Decrement it under the same lock in `kalloc()` only when a page was actually removed from the list. Do not increment the count for an invalid `kfree()` call; retain the stock `kfree()` validation.

Append the implementation in `kernel/kalloc.c` from `kernel/kalloc_additions.c.txt` (or merge it into the file):

```c
uint64
freepages(void)
{
  uint64 n;
  acquire(&kmem.lock);
  n = kmem.free_pages;
  release(&kmem.lock);
  return n;
}

uint64
totalpages(void)
{
  return total_pages_count;
}
```

The `freerange()` initialization calls `kfree()`, so the free counter naturally starts at the number of managed pages.

## 4. `kernel/vm.c`

Merge the functions from `kernel/vm_additions.c.txt` into `kernel/vm.c`:
- `vmcountpt()` counts the root page-table page plus all valid non-leaf child page-table pages.
- `vmprint()` prints valid user-side entries and summarizes root entries in the kernel half. On RISC-V, kernel mappings are in the upper half, unlike the x86 assignment.
- `uvmfault()` allocates and maps a zero-filled page for a valid lazy user address.

### Make unmapping tolerate lazy holes

In `uvmunmap()`, where the stock code currently panics if `walk()` returns 0 or the PTE is not valid, change that logic to skip absent pages. Preserve the panic for a valid non-leaf PTE. Use this pattern inside the loop:

```c
pte = walk(pagetable, a, 0);
if(pte == 0 || (*pte & PTE_V) == 0)
  continue;
if(PTE_FLAGS(*pte) == PTE_V)
  panic("uvmunmap: not a leaf");
```

Then retain the stock `do_free` handling, clear the PTE, and loop. This allows `sbrk()` shrinking and process teardown to pass over unallocated lazy pages.

### Make `uvmcopy()` tolerate holes

In the loop in `uvmcopy()`, replace the panic for a missing/invalid source PTE with:

```c
pte = walk(old, i, 0);
if(pte == 0 || (*pte & PTE_V) == 0)
  continue;
```

Keep the existing copy and permission logic for mapped pages. This is necessary because `fork()` must preserve holes in a lazily allocated address range.

### Make copyin/copyout/copyinstr tolerate lazy pages

In `copyin()`, `copyout()`, and `copyinstr()`, when `walkaddr()` returns 0, attempt `uvmfault()` only if `pagetable == myproc()->pagetable`, using `myproc()->sz` as the bound. If allocation fails, return `-1`. After successful allocation, retry `walkaddr()` for that address. Do not allocate for another process's page table or for invalid/kernel addresses.

## 5. `kernel/sysproc.c`

Merge the three syscall implementations from `kernel/sysproc_additions.c.txt` into `kernel/sysproc.c`.

For `sys_sbrk()`, replace eager growth with lazy growth for positive `n`:
- Save and return the old `p->sz`.
- For `n > 0`, reject overflow or values reaching `MAXVA`, then increase `p->sz` without calling `growproc()`.
- For `n < 0`, continue to call `growproc(n)` so allocated pages are freed during shrinking.

## 6. `kernel/trap.c`

In `usertrap()`, add a branch for load/store page faults (`r_scause() == 13 || r_scause() == 15`) before the generic unexpected-trap branch:

```c
} else if(r_scause() == 13 || r_scause() == 15) {
  if(uvmfault(p->pagetable, r_stval(), p->sz) < 0)
    p->killed = 1;
```

Check the braces against your local `usertrap()` implementation. Invalid addresses and guard-page accesses should kill the offending process rather than panic the kernel.

## 7. `kernel/syscall.h`

Add unique syscall numbers after the existing highest number. In the standard xv6-riscv tree, `SYS_close` is usually 21:

```c
#define SYS_va2pa      22
#define SYS_getmeminfo 23
#define SYS_vmprint    24
```

If your tree has more syscalls, choose three unused numbers instead.

## 8. `kernel/syscall.c`

Add declarations:

```c
extern uint64 sys_va2pa(void);
extern uint64 sys_getmeminfo(void);
extern uint64 sys_vmprint(void);
```

Add cases to the syscall dispatch table:

```c
[SYS_va2pa]      sys_va2pa,
[SYS_getmeminfo] sys_getmeminfo,
[SYS_vmprint]    sys_vmprint,
```

## 9. `user/user.h`

Add these declarations:

```c
uint64 va2pa(uint64);
int getmeminfo(struct meminfo *);
int vmprint(void);
```

Include the shared structure in programs that use it with `#include "meminfo.h"`.

## 10. `user/usys.pl`

Add:

```perl
entry("va2pa");
entry("getmeminfo");
entry("vmprint");
```

## 11. `user/Makefile`

Add these entries to `UPROGS`:

```make
  $U/_vatest\
  $U/_memtest\
  $U/_vmprinttest\
  $U/_lazytest\
```

Follow the exact continuation style used by neighboring entries.

## 12. `kernel/sysproc.c` additions and headers

Include `meminfo.h` and ensure the existing `defs.h`, `memlayout.h`, `proc.h`, `riscv.h`, and `spinlock.h` headers remain in place. The `sys_getmeminfo()` code needs `copyout()`, `myproc()`, `freepages()`, `totalpages()`, and `vmcountpt()`.

## Suggested workflow

```sh
git checkout -b assignment-8
# make the edits above
make clean
make qemu
```

If compilation fails, fix the first error before continuing. xv6 source revisions differ slightly, especially around trap and VM functions.
