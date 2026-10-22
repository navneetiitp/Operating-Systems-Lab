#ifndef _KERNEL_MEMINFO_H_
#define _KERNEL_MEMINFO_H_

#include "types.h"

struct meminfo {
  uint64 total_pages;
  uint64 free_pages;
  uint64 process_pages;
  uint64 page_table_pages;
};

#endif
