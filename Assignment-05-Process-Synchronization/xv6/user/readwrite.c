#include "kernel/types.h"
#include "user/user.h"

#define NUM_READERS 3
#define NUM_WRITERS 2
#define WRITES_PER_WRITER 5
#define READS_PER_READER 5

struct shared_rw {
  int shared_data;
  int read_count;
};

void
reader(struct shared_rw *shared, int mutex, int resource, int queue,
       int output_mutex, int id)
{
  int value;

  for(int i = 0; i < READS_PER_READER; i++){

    // Fairness gate: readers and writers enter in arrival order.
    sem_wait(queue);

    sem_wait(mutex);
    shared->read_count++;

    if(shared->read_count == 1)
      sem_wait(resource);

    sem_signal(queue);
    sem_signal(mutex);

    // Multiple readers can be here simultaneously.
    value = shared->shared_data;

    sem_wait(output_mutex);

     printf("Reader %d (PID %d) [time %d]: READ shared_data = %d, active_readers = %d\n",
       id, getpid(), uptime(), value, shared->read_count);

    sem_signal(output_mutex);

    sleep(2);

    sem_wait(mutex);
    shared->read_count--;

    if(shared->read_count == 0)
      sem_signal(resource);

    sem_signal(mutex);

    sleep(1);
  }

  exit(0);
}

void
writer(struct shared_rw *shared, int resource, int queue,
       int output_mutex, int id)
{
  for(int i = 0; i < WRITES_PER_WRITER; i++){

    // Fairness gate prevents writers from being starved.
    sem_wait(queue);

    sem_wait(resource);

    sem_signal(queue);

    shared->shared_data++;
sem_wait(output_mutex);

printf("Writer %d (PID %d) [time %d]: WRITE shared_data = %d\n",
       id, getpid(), uptime(), shared->shared_data);

sem_signal(output_mutex);
    sleep(2);

    sem_signal(resource);

    sleep(2);
  }

  exit(0);
}

int
main(void)
{
  volatile struct shared_rw *shared;
  int mutex;
  int resource;
  int queue;
  int output_mutex;
  int pid;
  int i;

  shared = (volatile struct shared_rw *)shm_get();

  if(shared == (void *)-1){
    printf("shm_get failed\n");
    exit(1);
  }

  shared->shared_data = 0;
  shared->read_count = 0;

  /*
   * mutex:
   * Protects read_count.
   *
   * resource:
   * Ensures writers have exclusive access and
   * prevents writers from entering while readers read.
   *
   * queue:
   * Fairness gate. Readers and writers must pass
   * through this gate before accessing resource.
   */
  mutex = sem_create(1);
  resource = sem_create(1);
  queue = sem_create(1);
output_mutex = sem_create(1);
  if(mutex < 0 || resource < 0 || queue < 0){
    printf("Semaphore creation failed\n");
    exit(1);
  }

  printf("Readers-Writers started\n");
  printf("Readers = %d, Writers = %d\n",
         NUM_READERS, NUM_WRITERS);

  /*
   * Create 3 reader processes.
   */
  for(i = 0; i < NUM_READERS; i++){
    pid = fork();

    if(pid < 0){
      printf("fork failed\n");
      exit(1);
    }

    if(pid == 0){
reader((struct shared_rw *)shared,
       mutex, resource, queue, output_mutex, i);
    }
  }

  /*
   * Create 2 writer processes.
   */
  for(i = 0; i < NUM_WRITERS; i++){
    pid = fork();

    if(pid < 0){
      printf("fork failed\n");
      exit(1);
    }

    if(pid == 0){
writer((struct shared_rw *)shared,
       resource, queue, output_mutex, i);
    }
  }

  /*
   * Wait for all 5 children.
   */
  for(i = 0; i < NUM_READERS + NUM_WRITERS; i++)
    wait(0);

  printf("Readers-Writers completed successfully.\n");
  printf("Final shared_data = %d\n", shared->shared_data);

  sem_free(mutex);
  sem_free(resource);
  sem_free(queue);
sem_free(output_mutex);
  exit(0);
}
