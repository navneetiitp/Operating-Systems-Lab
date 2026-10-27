#include "kernel/types.h"
#include "user/user.h"

int
main(void)
{
  printf("Page table before sbrk():\n");
  vmprint();

  char *p = sbrk(4 * 4096);
  if (p == (char *)-1) {
    printf("pttest: sbrk failed\n");
    exit(1);
  }

  printf("\nPage table after sbrk(4 * 4096):\n");
  vmprint();
  exit(0);
}
