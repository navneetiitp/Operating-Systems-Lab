#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int global_value = 12345;

static void
show_mapping(char *name, uint64 va)
{
  uint64 pa = va2pa(va);
  if(pa == (uint64)-1)
    printf("%s: VA %p -> PA -1 (unmapped or not user-accessible)\n",
           name, (void*)va);
  else
    printf("%s: VA %p -> PA %p\n", name, (void*)va, (void*)pa);
}

int
main(void)
{
  int local_value = 6789;
  char *heap_value = malloc(32);
  if(heap_value == 0) {
    printf("vatest: malloc failed\n");
    exit(1);
  }
  heap_value[0] = 'A';

  printf("=== virtual-to-physical address test ===\n");
  show_mapping("global", (uint64)&global_value);
  show_mapping("local", (uint64)&local_value);
  show_mapping("heap", (uint64)heap_value);
  show_mapping("invalid", 0x7fffffffULL);

  int pid = fork();
  if(pid < 0) {
    printf("vatest: fork failed\n");
    free(heap_value);
    exit(1);
  }
  if(pid == 0) {
    printf("child global VA=%p PA=%p\n",
           (void*)&global_value, (void*)va2pa((uint64)&global_value));
    free(heap_value);
    exit(0);
  }

  wait(0);
  printf("parent global VA=%p PA=%p\n",
         (void*)&global_value, (void*)va2pa((uint64)&global_value));
  free(heap_value);
  exit(0);
}
