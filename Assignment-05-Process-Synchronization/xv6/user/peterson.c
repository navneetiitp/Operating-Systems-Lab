#include "kernel/types.h"
#include "user/user.h"

#define ITERATIONS 10

struct shared_data {
  int flag[2];
  int turn;
  int counter;
};

static inline void
memory_fence(void)
{
  asm volatile("fence rw, rw" ::: "memory");
}

int
main(void)
{
  volatile struct shared_data *shm;
  int pid;
  int id;
  int other;
  int i;

  shm = (volatile struct shared_data *)shm_get();

  if (shm == (void *)-1) {
    printf("shm_get failed\n");
    exit(1);
  }

  shm->flag[0] = 0;
  shm->flag[1] = 0;
  shm->turn = 0;
  shm->counter = 0;

  memory_fence();

  pid = fork();

  if (pid < 0) {
    printf("fork failed\n");
    exit(1);
  }

  if (pid == 0) {
    id = 1;
    other = 0;
  } else {
    id = 0;
    other = 1;
  }

  for (i = 0; i < ITERATIONS; i++) {

    /* Peterson entry section */
    shm->flag[id] = 1;
    shm->turn = other;
    memory_fence();

    while (shm->flag[other] && shm->turn == other)
      ;

    memory_fence();

    /* Critical section */
    shm->counter++;

    printf("Process %d in CS, counter = %d\n",
           id, shm->counter);

    pause(1);

    /* Peterson exit section */
    memory_fence();
    shm->flag[id] = 0;
    memory_fence();

    pause(1);
  }

  if (pid != 0) {
    wait(0);
    memory_fence();
    printf("Final counter = %d\n", shm->counter);
  }

  exit(0);
}
