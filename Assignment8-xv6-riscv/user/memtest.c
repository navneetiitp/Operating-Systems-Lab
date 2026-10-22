#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "meminfo.h"

static void
report(char *label)
{
  struct meminfo m;
  if(getmeminfo(&m) < 0) {
    printf("%s: getmeminfo failed\n", label);
    return;
  }
  printf("%s: total=%d free=%d process=%d pages page-table=%d pages\n",
         label, (int)m.total_pages, (int)m.free_pages,
         (int)m.process_pages, (int)m.page_table_pages);
}

int
main(void)
{
  printf("=== physical memory statistics test ===\n");
  report("before");

  char *p = sbrk(4 * 4096);
  if(p == (char*)-1) {
    printf("memtest: sbrk failed\n");
    exit(1);
  }
  /* Touch each page so lazy allocation has to allocate physical frames. */
  for(int i = 0; i < 4; i++)
    p[i * 4096] = (char)(i + 1);
  report("after touching 4 pages");

  int pid = fork();
  if(pid < 0) {
    printf("memtest: fork failed\n");
    exit(1);
  }
  if(pid == 0) {
    report("child");
    exit(0);
  }
  wait(0);
  report("after child exit");

  if(sbrk(-4 * 4096) == (char*)-1)
    printf("memtest: shrink failed\n");
  report("after shrink");
  exit(0);
}
