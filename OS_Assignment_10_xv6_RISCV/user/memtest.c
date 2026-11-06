// Q1(c): Test physical page allocation and deallocation statistics.
#include "kernel/types.h"
#include "user/user.h"
#define PGSIZE 4096

int
main(void)
{
  int bytes = 3 * PGSIZE;
  char *p;

  printf("\n--- Initial memory statistics ---\n");
  memstats();

  p = sbrk(bytes);
  if(p == (char*)-1){
    printf("memtest: sbrk allocation failed\n");
    exit(1);
  }

  // Touch each page to force physical allocation.
  for(int i = 0; i < 3; i++)
    p[i * PGSIZE] = 'A' + i;

  printf("\nAllocated and touched 3 pages.\n");
  printf("--- After allocation ---\n");
  memstats();

  if(sbrk(-bytes) == (char*)-1){
    printf("memtest: sbrk deallocation failed\n");
    exit(1);
  }

  printf("\nReleased 3 pages.\n");
  printf("--- After deallocation ---\n");
  memstats();
  exit(0);
}
