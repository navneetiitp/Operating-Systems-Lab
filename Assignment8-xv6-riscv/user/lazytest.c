#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "meminfo.h"

static void
report(char *label)
{
  struct meminfo m;
  if(getmeminfo(&m) == 0)
    printf("%s: free pages=%d, process pages=%d\n",
           label, (int)m.free_pages, (int)m.process_pages);
  else
    printf("%s: getmeminfo failed\n", label);
}

int
main(void)
{
  printf("=== lazy allocation test ===\n");
  report("before");

  int bytes = 32 * 1024 * 1024;
  char *p = sbrk(bytes);
  if(p == (char*)-1) {
    printf("lazytest: large sbrk failed\n");
    exit(1);
  }
  report("after reserving 32 MiB (not touched)");

  /* Touch only a few pages spread through the reserved range. */
  p[0] = 'A';
  p[4 * 1024 * 1024] = 'B';
  p[16 * 1024 * 1024] = 'C';
  p[31 * 1024 * 1024] = 'D';
  report("after touching four pages");

  int pid = fork();
  if(pid < 0) {
    printf("lazytest: fork failed\n");
    exit(1);
  }
  if(pid == 0) {
    printf("child: touching an inherited lazy hole\n");
    p[8 * 1024 * 1024] = 'E';
    /* A syscall that reads from an untouched user buffer exercises copyin. */
    char *buf = p + 12 * 1024 * 1024;
    if(write(1, buf, 1) < 0)
      printf("lazytest: write from untouched buffer failed\n");
    exit(0);
  }
  wait(0);
  report("after child exit");

  if(sbrk(-bytes) == (char*)-1)
    printf("lazytest: shrink failed\n");
  report("after shrinking 32 MiB");
  exit(0);
}
