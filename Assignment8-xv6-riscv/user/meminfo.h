#ifndef _USER_MEMINFO_H_
#define _USER_MEMINFO_H_

#include "kernel/types.h"

/* Keep this layout identical in kernel/meminfo.h. */
struct meminfo {
  uint64 total_pages;
  uint64 free_pages;
  uint64 process_pages;
  uint64 page_table_pages;
};

#endif
