# Verification and screenshot checklist

After applying the overlay to xv6-RISC-V:

```sh
make clean
make qemu
```

Run each program separately and capture the terminal:

- [ ] `memtest` — initial, after-allocation, and after-deallocation statistics.
- [ ] `vttest` — two mapped addresses and one unmapped address.
- [ ] `pagetest` — page information before/after protection and expected store page fault.
- [ ] `pagereplace` — per-reference frame states and 3/4/5-frame comparison.

Update `docs/report.md` with observed counts and add screenshots to the submission.
