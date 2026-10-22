# Push to GitHub

After you integrate and successfully test the changes in your existing xv6-riscv repository:

```sh
git status
git add kernel user Makefile
git commit -m "Add OS Assignment 8 memory management features"
git push
```

If you want to keep the assignment as a subfolder rather than modifying the xv6 source directly, copy this entire package into your repository and commit it. However, the kernel snippets must still be integrated into the xv6 source tree for the features to run.
