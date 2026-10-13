#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define NTHREADS 3
#define ITERATIONS 100000
#define STACK_SIZE 4096

volatile int counter = 0;
char stacks[NTHREADS][STACK_SIZE] __attribute__((aligned(16)));

void worker(void *arg)
{
    int i;
    for(i = 0; i < ITERATIONS; i++)
        counter++;

    exit(0);
}

int main(void)
{
    int i;

    printf("Starting thread test\n");

    for(i = 0; i < NTHREADS; i++) {
        int pid = clone(worker, 0, stacks[i] + STACK_SIZE);
        if(pid < 0) {
            printf("clone failed\n");
            exit(1);
        }
    }

    for(i = 0; i < NTHREADS; i++) {
        if(join(0) < 0) {
            printf("join failed\n");
            exit(1);
        }
    }

    printf("Final counter: %d\n", counter);
    exit(0);
}
