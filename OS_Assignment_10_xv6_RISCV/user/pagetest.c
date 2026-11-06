// Q3(c): Inspect a page, remove write permission, and trigger a store fault.
#include "kernel/types.h"
#include "user/user.h"
#define PGSIZE 4096

int
main(void)
{
  char *p;

  p = sbrk(PGSIZE);
  if(p == (char*)-1){
    printf("pagetest: sbrk failed\n");
    exit(1);
  }

  p[0] = 'R';
  printf("Before changing permissions:\n");
  pageinfo((uint64)p);

  if(setreadonly((uint64)p) < 0){
    printf("setreadonly failed\n");
    exit(1);
  }

  printf("After removing write permission:\n");
  pageinfo((uint64)p);

  printf("Attempting a write to the read-only page; a store page fault is expected.\n");
  p[0] = 'W';

  // Normally unreachable: the process should be terminated by the page fault.
  printf("ERROR: write unexpectedly succeeded\n");
  exit(1);
}
