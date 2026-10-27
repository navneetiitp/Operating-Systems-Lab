#include "kernel/types.h"
#include "user/user.h"

#define MAXREF 128
#define MAXFRAMES 32

static int
contains(int frames[], int n, int page)
{
  for (int i = 0; i < n; i++)
    if (frames[i] == page)
      return i;
  return -1;
}

static void
run_fifo(int refs[], int nrefs, int nframes, int verbose)
{
  int frames[MAXFRAMES], faults = 0, hits = 0, next = 0, used = 0;
  for (int i = 0; i < nframes; i++) frames[i] = -1;
  printf("\nFIFO with %d frames\n", nframes);
  for (int r = 0; r < nrefs; r++) {
    int hit = contains(frames, used, refs[r]);
    if (hit >= 0) hits++;
    else {
      faults++;
      if (used < nframes) frames[used++] = refs[r];
      else { frames[next] = refs[r]; next = (next + 1) % nframes; }
    }
    if (verbose) {
      printf("ref %d: ", refs[r]);
      for (int j = 0; j < nframes; j++)
        if (frames[j] == -1) printf("- "); else printf("%d ", frames[j]);
      printf("%s\n", hit >= 0 ? "HIT" : "FAULT");
    }
  }
  printf("FIFO faults=%d hits=%d hit-ratio=%.2f%%\n", faults, hits,
         100.0 * hits / nrefs);
}

static void
run_lru(int refs[], int nrefs, int nframes, int verbose)
{
  int frames[MAXFRAMES], last[MAXFRAMES], faults = 0, hits = 0, used = 0;
  for (int i = 0; i < nframes; i++) { frames[i] = -1; last[i] = -1; }
  printf("\nLRU with %d frames\n", nframes);
  for (int r = 0; r < nrefs; r++) {
    int hit = contains(frames, used, refs[r]);
    if (hit >= 0) { hits++; last[hit] = r; }
    else {
      faults++;
      int slot;
      if (used < nframes) slot = used++;
      else {
        slot = 0;
        for (int j = 1; j < nframes; j++)
          if (last[j] < last[slot]) slot = j;
      }
      frames[slot] = refs[r];
      last[slot] = r;
    }
    if (verbose) {
      printf("ref %d: ", refs[r]);
      for (int j = 0; j < nframes; j++)
        if (frames[j] == -1) printf("- "); else printf("%d ", frames[j]);
      printf("%s\n", hit >= 0 ? "HIT" : "FAULT");
    }
  }
  printf("LRU faults=%d hits=%d hit-ratio=%.2f%%\n", faults, hits,
         100.0 * hits / nrefs);
}

int
main(int argc, char *argv[])
{
  int refs[] = {7,0,1,2,0,3,0,4,2,3,0,3,2,1,2,0,1,7,0,1};
  int nrefs = sizeof(refs) / sizeof(refs[0]);
  int verbose = 1;
  if (argc > 1) {
    nrefs = 0;
    for (int i = 1; i < argc && nrefs < MAXREF; i++) refs[nrefs++] = atoi(argv[i]);
  }
  printf("Reference count: %d\n", nrefs);
  for (int f = 3; f <= 5; f++) {
    run_fifo(refs, nrefs, f, verbose);
    run_lru(refs, nrefs, f, verbose);
  }
  exit(0);
}
