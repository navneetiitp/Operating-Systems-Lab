#include "kernel/types.h"
#include "user/user.h"

#define PGSIZE 4096

int
main(void)
{
  char *p = sbrk(32 * PGSIZE);
  if (p == (char *)-1) {
    printf("faulttest: sbrk failed\n");
    exit(1);
  }

  // Touch exactly five distinct pages; lazy allocation should fault once per page.
  p[0 * PGSIZE] = 11;
  p[3 * PGSIZE] = 22;
  p[7 * PGSIZE] = 33;
  p[15 * PGSIZE] = 44;
  p[31 * PGSIZE] = 55;

  printf("Expected faults for these five first-touch writes: 5\n");
  printf("Handled page faults reported by kernel: %d\n", getfaults());
  exit(0);
}
