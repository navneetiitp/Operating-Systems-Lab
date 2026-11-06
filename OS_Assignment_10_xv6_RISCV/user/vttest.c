// Q2(c): Test virtual-to-physical address translation.
#include "kernel/types.h"
#include "user/user.h"
#define PGSIZE 4096

int
main(void)
{
  char *p;
  uint64 pa;

  p = sbrk(2 * PGSIZE);
  if(p == (char*)-1){
    printf("vttest: sbrk failed\n");
    exit(1);
  }

  p[0] = 'A';
  p[PGSIZE] = 'B';

  printf("Allocated virtual range: %p - %p\n", p, p + 2 * PGSIZE);

  pa = vtop((uint64)p);
  if(pa == (uint64)-1)
    printf("Translation failed for %p\n", p);
  else
    printf("VA %p -> PA %p\n", p, pa);

  pa = vtop((uint64)(p + PGSIZE + 17));
  if(pa == (uint64)-1)
    printf("Translation failed for %p\n", p + PGSIZE + 17);
  else
    printf("VA %p -> PA %p\n", p + PGSIZE + 17, pa);

  // Deliberately choose an address outside this process's mapped user range.
  pa = vtop((uint64)0x30000000);
  if(pa == (uint64)-1)
    printf("Expected result: %p is unmapped\n", (uint64)0x30000000);
  else
    printf("Unexpected mapping: VA %p -> PA %p\n",
           (uint64)0x30000000, pa);

  exit(0);
}
