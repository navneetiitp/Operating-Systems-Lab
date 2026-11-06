#!/usr/bin/env python3
"""Apply this Assignment 10 overlay to a clean MIT xv6-RISC-V checkout."""
from pathlib import Path
import re, shutil

ROOT = Path.cwd()
PKG = Path(__file__).resolve().parents[1]

def read(path):
    p = ROOT / path
    if not p.exists():
        raise SystemExit(f"Missing {path}. Run from xv6-riscv repository root.")
    return p.read_text()

def write(path, data):
    (ROOT / path).write_text(data)

def replace_once(s, old, new, label):
    if new in s:
        return s
    if old not in s:
        raise SystemExit(f"Expected upstream anchor not found: {label}")
    return s.replace(old, new, 1)

# Q1: physical allocator counters.
p = "kernel/kalloc.c"
s = read(p)
s = replace_once(s, "  struct run *freelist;\n} kmem;",
    "  struct run *freelist;\n"
    "  // Assignment 10: runtime physical-page counters.\n"
    "  uint64 total_allocated;\n"
    "  uint64 total_freed;\n} kmem;", "kmem structure")
s = replace_once(s, "  freerange(end, (void*)PHYSTOP);\n}",
    "  freerange(end, (void*)PHYSTOP);\n"
    "  // Exclude the initial free-list construction from runtime counters.\n"
    "  acquire(&kmem.lock);\n"
    "  kmem.total_allocated = 0;\n"
    "  kmem.total_freed = 0;\n"
    "  release(&kmem.lock);\n}", "kinit")
s = replace_once(s, "  kmem.freelist = r;\n  release(&kmem.lock);",
    "  kmem.freelist = r;\n"
    "  kmem.total_freed++;\n"
    "  release(&kmem.lock);", "kfree")
s = replace_once(s, "  if(r)\n    kmem.freelist = r->next;\n  release(&kmem.lock);",
    "  if(r){\n"
    "    kmem.freelist = r->next;\n"
    "    kmem.total_allocated++;\n"
    "  }\n"
    "  release(&kmem.lock);", "kalloc")
if "getmemstats(uint64" not in s:
    s += """
// Assignment 10: return a consistent snapshot of allocator statistics.
void
getmemstats(uint64 *allocated, uint64 *freed, uint64 *available)
{
  struct run *r;
  uint64 count = 0;
  acquire(&kmem.lock);
  *allocated = kmem.total_allocated;
  *freed = kmem.total_freed;
  for(r = kmem.freelist; r != 0; r = r->next)
    count++;
  *available = count;
  release(&kmem.lock);
}
"""
write(p, s)

# Declaration.
p = "kernel/defs.h"
s = read(p)
s = replace_once(s, "void            kfree(void *);\n",
    "void            kfree(void *);\n"
    "void            getmemstats(uint64*, uint64*, uint64*);\n", "allocator prototype")
write(p, s)

# System-call handlers.
p = "kernel/sysproc.c"
s = read(p)
if "sys_memstats(void)" not in s:
    s += """
// Q1: Print physical-memory allocator statistics.
uint64
sys_memstats(void)
{
  uint64 allocated, freed, available;
  getmemstats(&allocated, &freed, &available);
  printf("\\n===== MEMORY STATISTICS =====\\n");
  printf("Total allocated pages : %d\\n", (int)allocated);
  printf("Total freed pages     : %d\\n", (int)freed);
  printf("Currently allocated   : %d\\n", (int)(allocated - freed));
  printf("Available pages       : %d\\n", (int)available);
  printf("=============================\\n");
  return 0;
}

// Q2: Translate a virtual address in the calling process.
uint64
sys_vtop(void)
{
  uint64 va;
  pte_t *pte;
  argaddr(0, &va);
  if(va >= MAXVA)
    return (uint64)-1;
  pte = walk(myproc()->pagetable, va, 0);
  if(pte == 0 || (*pte & PTE_V) == 0)
    return (uint64)-1;
  return PTE2PA(*pte) | (va & (PGSIZE - 1));
}

// Q3: Print PPN and the valid, writable, and user flags.
uint64
sys_pageinfo(void)
{
  uint64 va;
  pte_t *pte;
  argaddr(0, &va);
  if(va >= MAXVA)
    return -1;
  pte = walk(myproc()->pagetable, va, 0);
  if(pte == 0 || (*pte & PTE_V) == 0){
    printf("pageinfo: virtual address %p is unmapped\\n", va);
    return -1;
  }
  printf("pageinfo: VA=%p PPN=%d P=%d W=%d U=%d\\n",
         va, (int)(PTE2PA(*pte) >> 12),
         ((*pte & PTE_V) != 0),
         ((*pte & PTE_W) != 0),
         ((*pte & PTE_U) != 0));
  return 0;
}

// Q3: Remove write permission from a mapped user page.
uint64
sys_setreadonly(void)
{
  uint64 va;
  pte_t *pte;
  argaddr(0, &va);
  if(va >= MAXVA)
    return -1;
  pte = walk(myproc()->pagetable, va, 0);
  if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0)
    return -1;
  *pte &= ~PTE_W;
  sfence_vma();
  return 0;
}
"""
write(p, s)

# System call numbers and dispatcher.
p = "kernel/syscall.h"
s = read(p)
if "#define SYS_memstats" not in s:
    s += "\n// Assignment 10 system calls.\n#define SYS_memstats 23\n#define SYS_vtop 24\n#define SYS_pageinfo 25\n#define SYS_setreadonly 26\n"
write(p, s)

p = "kernel/syscall.c"
s = read(p)
s = replace_once(s, "extern uint64 sys_sync(void);\n",
    "extern uint64 sys_sync(void);\n"
    "extern uint64 sys_memstats(void);\n"
    "extern uint64 sys_vtop(void);\n"
    "extern uint64 sys_pageinfo(void);\n"
    "extern uint64 sys_setreadonly(void);\n", "syscall prototypes")
s = replace_once(s, "[SYS_sync] sys_sync,\n",
    "[SYS_sync] sys_sync,\n"
    "[SYS_memstats] sys_memstats,\n"
    "[SYS_vtop] sys_vtop,\n"
    "[SYS_pageinfo] sys_pageinfo,\n"
    "[SYS_setreadonly] sys_setreadonly,\n", "syscall table")
write(p, s)

# User-space declarations and generated stubs.
p = "user/user.h"
s = read(p)
if "int memstats(void);" not in s:
    s += "\n// Assignment 10 system calls.\nint memstats(void);\nuint64 vtop(uint64);\nint pageinfo(uint64);\nint setreadonly(uint64);\n"
write(p, s)

p = "user/usys.pl"
s = read(p)
for name in ("memstats", "vtop", "pageinfo", "setreadonly"):
    if f'entry("{name}");' not in s:
        s += f'\nentry("{name}");\n'
write(p, s)

# Copy user programs into xv6.
for name in ("memtest.c", "vttest.c", "pagetest.c", "pagereplace.c"):
    shutil.copy2(PKG / "user" / name, ROOT / "user" / name)

# Add test programs to the UPROGS list.
p = "Makefile"
s = read(p)
if "$U/_memtest" not in s:
    marker = "\n\nfs.img:"
    if marker not in s:
        raise SystemExit("Cannot locate fs.img target in Makefile.")
    before, after = s.split(marker, 1)
    lines = before.splitlines()
    indices = [i for i, line in enumerate(lines) if re.match(r"\s*\$U/_", line)]
    if not indices:
        raise SystemExit("Cannot find UPROGS entries in Makefile.")
    last = indices[-1]
    if not lines[last].rstrip().endswith("\\"):
        lines[last] = lines[last].rstrip() + "\\"
    additions = ["\t$U/_memtest\\", "\t$U/_vttest\\",
                 "\t$U/_pagetest\\", "\t$U/_pagereplace"]
    lines[last+1:last+1] = additions
    s = "\n".join(lines) + marker + after
write(p, s)

print("Assignment 10 overlay applied. Run: make clean && make qemu")
