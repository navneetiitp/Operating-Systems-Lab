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

static int
run_fifo(int refs[], int nrefs, int nframes, int verbose)
{
  int frames[MAXFRAMES], faults = 0, next = 0, used = 0;
  for (int i = 0; i < nframes; i++)
    frames[i] = -1;

  if (verbose)
    printf("\nFIFO with %d frames\n", nframes);
  for (int r = 0; r < nrefs; r++) {
    int hit = contains(frames, used, refs[r]);
    if (hit < 0) {
      faults++;
      if (used < nframes)
        frames[used++] = refs[r];
      else {
        frames[next] = refs[r];
        next = (next + 1) % nframes;
      }
    }
    if (verbose) {
      printf("ref %d: ", refs[r]);
      for (int j = 0; j < nframes; j++) {
        if (frames[j] == -1) printf("- ");
        else printf("%d ", frames[j]);
      }
      printf("%s\n", hit >= 0 ? "HIT" : "FAULT");
    }
  }
  if (verbose)
    printf("FIFO faults=%d hits=%d hit-ratio=%d%%\n",
           faults, nrefs - faults, ((nrefs - faults) * 100) / nrefs);
  return faults;
}

static int
run_lru(int refs[], int nrefs, int nframes, int verbose)
{
  int frames[MAXFRAMES], last[MAXFRAMES], faults = 0, used = 0;
  for (int i = 0; i < nframes; i++) {
    frames[i] = -1;
    last[i] = -1;
  }

  if (verbose)
    printf("\nLRU with %d frames\n", nframes);
  for (int r = 0; r < nrefs; r++) {
    int hit = contains(frames, used, refs[r]);
    if (hit >= 0) {
      last[hit] = r;
    } else {
      faults++;
      int slot;
      if (used < nframes) {
        slot = used++;
      } else {
        slot = 0;
        for (int j = 1; j < nframes; j++)
          if (last[j] < last[slot])
            slot = j;
      }
      frames[slot] = refs[r];
      last[slot] = r;
    }
    if (verbose) {
      printf("ref %d: ", refs[r]);
      for (int j = 0; j < nframes; j++) {
        if (frames[j] == -1) printf("- ");
        else printf("%d ", frames[j]);
      }
      printf("%s\n", hit >= 0 ? "HIT" : "FAULT");
    }
  }
  if (verbose)
    printf("LRU faults=%d hits=%d hit-ratio=%d%%\n",
           faults, nrefs - faults, ((nrefs - faults) * 100) / nrefs);
  return faults;
}

int
main(int argc, char *argv[])
{
  int refs[MAXREF] = {7, 0, 1, 2, 0, 3, 0, 4, 2, 3,
                      0, 3, 2, 1, 2, 0, 1, 7, 0, 1};
  int nrefs = 20;

  if (argc > 1) {
    nrefs = 0;
    for (int i = 1; i < argc && nrefs < MAXREF; i++)
      refs[nrefs++] = atoi(argv[i]);
  }
  if (nrefs <= 0) {
    printf("pagerepl: reference string cannot be empty\n");
    exit(1);
  }

  printf("Reference string (%d pages):", nrefs);
  for (int i = 0; i < nrefs; i++)
    printf(" %d", refs[i]);
  printf("\n\nDetailed trace follows.\n");

  printf("\nSUMMARY TABLE\n");
  printf("Frames Algorithm Faults Hits Hit-ratio\n");
  for (int f = 3; f <= 5; f++) {
    int fifo = run_fifo(refs, nrefs, f, 0);
    int lru = run_lru(refs, nrefs, f, 0);
    printf("%d      FIFO      %d      %d    %d%%\n",
           f, fifo, nrefs - fifo, ((nrefs - fifo) * 100) / nrefs);
    printf("%d      LRU       %d      %d    %d%%\n",
           f, lru, nrefs - lru, ((nrefs - lru) * 100) / nrefs);
  }

  for (int f = 3; f <= 5; f++) {
    run_fifo(refs, nrefs, f, 1);
    run_lru(refs, nrefs, f, 1);
  }
  exit(0);
}
