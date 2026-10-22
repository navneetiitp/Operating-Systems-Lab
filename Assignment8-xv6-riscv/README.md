# Operating Systems Assignment 8 — xv6-riscv (Questions 1–4)

This package provides user programs and kernel implementation snippets for the first four questions:
1. Virtual-to-physical address translation (`va2pa`)
2. Physical-memory statistics (`getmeminfo`)
3. Page-table dump (`vmprint`)
4. Lazy heap allocation (demand paging)

**Important:** This is an integration package for the MIT `xv6-riscv` source tree, not a replacement copy of the entire xv6 kernel. The original repository was not available in this environment, so the package has not been compiled or run against your exact checkout. Apply the changes to a clean copy of your course's xv6-riscv tree, build, test, and then commit.

## Contents

- `user/`: four user test programs and `meminfo.h`
- `kernel/`: implementation snippets for kernel files
- `INTEGRATION.md`: exact file-by-file integration checklist
- `TESTING.md`: build and run steps plus expected behavior

## Compatibility notes

The assignment images describe xv6 **x86** APIs such as `walkpgdir()`, `PTE_P`, and `KERNBASE`. This package adapts the concepts to **xv6-riscv**, which uses Sv39 page tables, `walk()`, `PTE_V`, `PTE_U`, and high-half kernel mappings. Do not paste x86-specific code directly into xv6-riscv.


