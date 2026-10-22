#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
  printf("=== page table at program start ===\n");
  vmprint();

  printf("=== page table after sbrk(2 pages) ===\n");
  char *p = sbrk(2 * 4096);
  if(p == (char*)-1) {
    printf("vmprinttest: sbrk failed\n");
    exit(1);
  }
  /* Touch both pages so they become mapped. */
  p[0] = 'x';
  p[4096] = 'y';
  vmprint();

  printf("=== page table after shrinking 2 pages ===\n");
  if(sbrk(-2 * 4096) == (char*)-1)
    printf("vmprinttest: shrink failed\n");
  vmprint();
  exit(0);
}
