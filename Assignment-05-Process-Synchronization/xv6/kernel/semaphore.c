#include "types.h"
#include "param.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"

#define NSEM 16

struct semaphore {
  struct spinlock lock;
  int value;
  int used;
};

struct {
  struct spinlock lock;
  struct semaphore sem[NSEM];
} semtable;

void
seminit(void)
{
  int i;

  initlock(&semtable.lock, "semtable");

  for(i = 0; i < NSEM; i++){
    initlock(&semtable.sem[i].lock, "semaphore");
    semtable.sem[i].value = 0;
    semtable.sem[i].used = 0;
  }
}

int
sem_create(int value)
{
  int i;

  if(value < 0)
    return -1;

  acquire(&semtable.lock);

  for(i = 0; i < NSEM; i++){
    if(!semtable.sem[i].used){
      semtable.sem[i].used = 1;
      semtable.sem[i].value = value;
      release(&semtable.lock);
      return i;
    }
  }

  release(&semtable.lock);
  return -1;
}

int
sem_wait(int id)
{
  struct semaphore *sem;

  if(id < 0 || id >= NSEM)
    return -1;

  sem = &semtable.sem[id];

  acquire(&sem->lock);

  while(sem->value == 0){
    sleep_prepare(sem);
    release(&sem->lock);
    sleep();
    acquire(&sem->lock);
  }

  sem->value--;

  release(&sem->lock);

  return 0;
}

int
sem_signal(int id)
{
  struct semaphore *sem;

  if(id < 0 || id >= NSEM)
    return -1;

  sem = &semtable.sem[id];

  acquire(&sem->lock);

  sem->value++;

  wakeup(sem);

  release(&sem->lock);

  return 0;
}

int
sem_free(int id)
{
  struct semaphore *sem;

  if(id < 0 || id >= NSEM)
    return -1;

  sem = &semtable.sem[id];

  acquire(&semtable.lock);
  acquire(&sem->lock);

  if(!sem->used){
    release(&sem->lock);
    release(&semtable.lock);
    return -1;
  }

  sem->used = 0;
  sem->value = 0;

  release(&sem->lock);
  release(&semtable.lock);

  return 0;
}
