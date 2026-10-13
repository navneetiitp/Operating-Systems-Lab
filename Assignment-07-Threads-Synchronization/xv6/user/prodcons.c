#include "kernel/types.h"
#include "user/user.h"

#define DEFAULT_CAPACITY 5
#define MAX_BUFFER 16
#define ITEMS 20

struct shared_buffer {
  int buffer[MAX_BUFFER];
  int in;
  int out;
  int capacity;
};

int
main(int argc, char *argv[])
{
  volatile struct shared_buffer *shared;
  int capacity;
  int empty;
  int full;
  int mutex;
  int pid;
  int i;
  int item;
  int expected;

  capacity = DEFAULT_CAPACITY;

  if(argc == 2){
    capacity = atoi(argv[1]);

    if(capacity < 1 || capacity > MAX_BUFFER){
      printf("Buffer size must be between 1 and %d\n", MAX_BUFFER);
      exit(1);
    }
  }
  else if(argc > 2){
    printf("Usage: prodcons [buffer_size]\n");
    exit(1);
  }

  /*
   * Obtain one shared page before fork().
   * The child inherits the same physical shared page.
   */
  shared = (volatile struct shared_buffer *)shm_get();

  if(shared == (void *)-1){
    printf("shm_get failed\n");
    exit(1);
  }

  shared->in = 0;
  shared->out = 0;
  shared->capacity = capacity;

  for(i = 0; i < MAX_BUFFER; i++)
    shared->buffer[i] = 0;

  /*
   * empty = number of free buffer slots
   * full  = number of occupied buffer slots
   * mutex = protects the circular buffer
   */
  empty = sem_create(capacity);
  full = sem_create(0);
  mutex = sem_create(1);

  if(empty < 0 || full < 0 || mutex < 0){
    printf("Semaphore creation failed\n");
    exit(1);
  }

  printf("Producer-Consumer started\n");
  printf("Buffer capacity = %d\n", capacity);

  pid = fork();

  if(pid < 0){
    printf("fork failed\n");
    exit(1);
  }

  /*
   * Parent = producer
   * Child  = consumer
   */
  if(pid != 0){

    for(item = 1; item <= ITEMS; item++){

      /*
       * Producer waits if the buffer is full.
       */
      if(sem_wait(empty) < 0){
        printf("Producer: sem_wait(empty) failed\n");
        exit(1);
      }

      if(sem_wait(mutex) < 0){
        printf("Producer: sem_wait(mutex) failed\n");
        exit(1);
      }

      shared->buffer[shared->in] = item;

      printf("Producer: inserted %d at slot %d\n",
             item, shared->in);

      shared->in = (shared->in + 1) % shared->capacity;

      sem_signal(mutex);
      sem_signal(full);

      /*
       * Brief producer delay.
       */
      sleep(1);
    }

    wait(0);

    sem_free(empty);
    sem_free(full);
    sem_free(mutex);

    printf("Producer-Consumer test completed successfully.\n");

  } else {

    expected = 1;

    /*
     * Initial delay helps demonstrate that the producer
     * can fill the buffer before the consumer starts.
     */
    sleep(3);

    for(i = 0; i < ITEMS; i++){

      /*
       * Consumer waits if the buffer is empty.
       */
      if(sem_wait(full) < 0){
        printf("Consumer: sem_wait(full) failed\n");
        exit(1);
      }

      if(sem_wait(mutex) < 0){
        printf("Consumer: sem_wait(mutex) failed\n");
        exit(1);
      }

      item = shared->buffer[shared->out];

      printf("Consumer: removed %d from slot %d\n",
             item, shared->out);

      /*
       * Verify that items are consumed in order.
       */
      if(item != expected){
        printf("ERROR: expected %d but received %d\n",
               expected, item);
        sem_signal(mutex);
        sem_signal(empty);
        exit(1);
      }

      expected++;

      shared->out = (shared->out + 1) % shared->capacity;

      sem_signal(mutex);
      sem_signal(empty);

      /*
       * Brief consumer delay.
       */
      sleep(2);
    }

    printf("Consumer: verification successful\n");
    printf("Consumer: all %d items consumed in order.\n", ITEMS);

    exit(0);
  }

  exit(0);
}
