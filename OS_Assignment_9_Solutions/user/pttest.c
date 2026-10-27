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

  /* Under lazy allocation, touch each reserved page so it gets mapped. */
  p[0 * 4096] = 1;
  p[1 * 4096] = 2;
  p[2 * 4096] = 3;
  p[3 * 4096] = 4;

  printf("\nPage table after sbrk(4 * 4096) and touching four pages:\n");
  vmprint();
  exit(0);
}
