// Q4(a-c): Compare FIFO, LRU, and Optimal page replacement.
#include "kernel/types.h"
#include "user/user.h"

#define NREF 20
#define MAXF 5

int refs[NREF] = {
  7, 0, 1, 2, 0, 3, 0, 4, 2, 3,
  0, 3, 2, 1, 2, 0, 1, 7, 0, 1
};

struct Result {
  int faults;
  int hits;
};

static int
find_page(int frames[], int nf, int page)
{
  for(int i = 0; i < nf; i++)
    if(frames[i] == page)
      return i;
  return -1;
}

static void
print_frames(int frames[], int nf)
{
  printf("[");
  for(int i = 0; i < nf; i++){
    if(frames[i] == -1)
      printf(" -");
    else
      printf(" %d", frames[i]);
  }
  printf(" ]");
}

static struct Result
fifo(int nf, int verbose)
{
  int frames[MAXF], next = 0;
  struct Result r = {0, 0};
  for(int i = 0; i < nf; i++) frames[i] = -1;

  if(verbose) printf("\nFIFO with %d frames\n", nf);
  for(int i = 0; i < NREF; i++){
    int hit = find_page(frames, nf, refs[i]) >= 0;
    if(hit) r.hits++;
    else {
      r.faults++;
      frames[next] = refs[i];
      next = (next + 1) % nf;
    }
    if(verbose){
      printf("%d: ", refs[i]);
      print_frames(frames, nf);
      printf(" %s\n", hit ? "HIT" : "FAULT");
    }
  }
  return r;
}

static struct Result
lru(int nf, int verbose)
{
  int frames[MAXF], last_used[MAXF];
  struct Result r = {0, 0};
  for(int i = 0; i < nf; i++){
    frames[i] = -1;
    last_used[i] = -1;
  }

  if(verbose) printf("\nLRU with %d frames\n", nf);
  for(int i = 0; i < NREF; i++){
    int slot = find_page(frames, nf, refs[i]);
    int hit = slot >= 0;
    if(hit) r.hits++;
    else {
      r.faults++;
      slot = -1;
      for(int j = 0; j < nf; j++)
        if(frames[j] == -1){ slot = j; break; }
      if(slot == -1){
        slot = 0;
        for(int j = 1; j < nf; j++)
          if(last_used[j] < last_used[slot]) slot = j;
      }
      frames[slot] = refs[i];
    }
    last_used[slot] = i;
    if(verbose){
      printf("%d: ", refs[i]);
      print_frames(frames, nf);
      printf(" %s\n", hit ? "HIT" : "FAULT");
    }
  }
  return r;
}

static struct Result
optimal(int nf, int verbose)
{
  int frames[MAXF];
  struct Result r = {0, 0};
  for(int i = 0; i < nf; i++) frames[i] = -1;

  if(verbose) printf("\nOptimal with %d frames\n", nf);
  for(int i = 0; i < NREF; i++){
    int slot = find_page(frames, nf, refs[i]);
    int hit = slot >= 0;
    if(hit) r.hits++;
    else {
      r.faults++;
      slot = -1;
      for(int j = 0; j < nf; j++)
        if(frames[j] == -1){ slot = j; break; }
      if(slot == -1){
        int farthest = -1;
        slot = 0;
        for(int j = 0; j < nf; j++){
          int next_use = NREF + 1;
          for(int k = i + 1; k < NREF; k++)
            if(refs[k] == frames[j]){ next_use = k; break; }
          if(next_use > farthest){ farthest = next_use; slot = j; }
        }
      }
      frames[slot] = refs[i];
    }
    if(verbose){
      printf("%d: ", refs[i]);
      print_frames(frames, nf);
      printf(" %s\n", hit ? "HIT" : "FAULT");
    }
  }
  return r;
}

static void
summary(int nf, char *name, struct Result r)
{
  printf("%s  %d frames: faults=%d hits=%d hit_ratio=%d%% fault_ratio=%d%%\n",
         name, nf, r.faults, r.hits,
         (r.hits * 100) / NREF, (r.faults * 100) / NREF);
}

int
main(void)
{
  struct Result r;
  int frame_counts[] = {3, 4, 5};

  printf("Reference string: ");
  for(int i = 0; i < NREF; i++) printf("%d ", refs[i]);
  printf("\n");

  r = fifo(3, 1);
  printf("FIFO (3 frames): faults=%d hits=%d\n", r.faults, r.hits);
  r = lru(3, 1);
  printf("LRU (3 frames): faults=%d hits=%d\n", r.faults, r.hits);
  r = optimal(3, 1);
  printf("Optimal (3 frames): faults=%d hits=%d\n", r.faults, r.hits);

  printf("\nComparison for 3, 4 and 5 frames:\n");
  for(int i = 0; i < 3; i++){
    int nf = frame_counts[i];
    summary(nf, "FIFO", fifo(nf, 0));
    summary(nf, "LRU", lru(nf, 0));
    summary(nf, "Optimal", optimal(nf, 0));
  }
  exit(0);
}
