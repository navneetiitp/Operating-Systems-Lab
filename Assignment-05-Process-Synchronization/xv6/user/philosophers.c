#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define NPHIL 5
#define CYCLES 5

void
philosopher(int id, int forks[NPHIL])
{
    int left = id;
    int right = (id + 1) % NPHIL;

    // Pick the lower-numbered fork first to prevent circular wait.
    int first = left < right ? left : right;
    int second = left < right ? right : left;

    for (int cycle = 0; cycle < CYCLES; cycle++) {
        printf("Philosopher %d: THINKING (cycle %d)\n",
               id, cycle + 1);
        sleep(2);

        printf("Philosopher %d: HUNGRY (cycle %d)\n",
               id, cycle + 1);

        sem_wait(forks[first]);
        sem_wait(forks[second]);

        printf("Philosopher %d: EATING (cycle %d)\n",
               id, cycle + 1);
        sleep(3);

        sem_signal(forks[second]);
        sem_signal(forks[first]);

        printf("Philosopher %d: THINKING (forks released)\n", id);
        sleep(2);
    }

    printf("Philosopher %d: completed all cycles\n", id);
}

int
main(int argc, char *argv[])
{
    int forks[NPHIL];

    printf("Dining Philosophers started\n");
    printf("Philosophers = 5, Cycles = %d\n", CYCLES);

    // One binary semaphore for each fork.
    for (int i = 0; i < NPHIL; i++) {
        forks[i] = sem_create(1);
        if (forks[i] < 0) {
            printf("Failed to create fork semaphore %d\n", i);
            exit(1);
        }
    }

    // Create five philosopher processes.
    for (int i = 0; i < NPHIL; i++) {
        int pid = fork();

        if (pid < 0) {
            printf("fork failed\n");
            exit(1);
        }

        if (pid == 0) {
            philosopher(i, forks);
            exit(0);
        }
    }

    // Wait for all philosophers.
    for (int i = 0; i < NPHIL; i++)
        wait(0);

    for (int i = 0; i < NPHIL; i++)
        sem_free(forks[i]);

    printf("Dining Philosophers completed successfully.\n");

    exit(0);
}
