# Operating Systems Assignment 9 — Short Report

## Question 1: Printing the Page Table
A recursive Sv39 page-table traversal was added for the xv6-RISC-V version. It follows valid non-leaf page-table entries, prints each valid user leaf mapping's virtual and physical address and P/W/U flags, and reports the number of user mappings and page-table pages (including the root page). The user test calls `vmprint()` before and after increasing the process's address-space size. Because this version also implements lazy allocation, the four pages must be accessed before they appear as mapped pages in the second output.

## Question 2: Lazy Allocation
Positive `sbrk()` increments reserve virtual address space without allocating physical pages. A user load/store page fault inside the process's reserved size allocates a zero-filled page, maps it with user/read/write permissions, and increments the process's page-fault counter. Invalid addresses or allocation failures mark the process as killed. The test reserves 32 pages and writes to five distinct pages; the expected count is five.

## Question 3: Page Replacement
A user program simulates FIFO and LRU for the supplied reference string. It prints each reference's frame state and hit/fault status, then summarizes faults, hits, and hit ratio for 3, 4, and 5 frames. Expected fault counts are FIFO/LRU: 15/12 with 3 frames, 10/8 with 4 frames, and 9/7 with 5 frames.

## Testing note
Fill in actual build/test results after running the programs in the target xv6 repository. Do not claim a successful build or attach fabricated screenshots. This implementation bundle targets xv6-RISC-V, while the assignment handout describes xv6 x86.
