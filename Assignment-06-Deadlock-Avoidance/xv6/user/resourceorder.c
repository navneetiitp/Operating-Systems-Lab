#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

void
delay(void)
{
    for (volatile int i = 0; i < 1000000; i++)
        ;
}

void
bad_process_a(int lock1, int lock2)
{
    printf("Process A: acquiring Lock1\n");
    sem_wait(lock1);
    printf("Process A: acquired Lock1\n");

    delay();

    printf("Process A: waiting for Lock2\n");
    sem_wait(lock2);

    printf("Process A: acquired Lock2\n");
    sem_signal(lock2);
    sem_signal(lock1);
    exit(0);
}

void
bad_process_b(int lock1, int lock2)
{
    printf("Process B: acquiring Lock2\n");
    sem_wait(lock2);
    printf("Process B: acquired Lock2\n");

    delay();

    printf("Process B: waiting for Lock1\n");
    sem_wait(lock1);

    printf("Process B: acquired Lock1\n");
    sem_signal(lock1);
    sem_signal(lock2);
    exit(0);
}

void
run_bad(void)
{
    int lock1 = sem_create(1);
    int lock2 = sem_create(1);

    printf("=== BAD ORDER: DEADLOCK DEMONSTRATION ===\n");

    int pid_a = fork();

    if (pid_a == 0)
        bad_process_a(lock1, lock2);

    int pid_b = fork();

    if (pid_b == 0)
        bad_process_b(lock1, lock2);

    printf("Parent: waiting for deadlock to become visible...\n");
    sleep(30);

    printf("Parent: timeout reached.\n");
    printf("Parent: bad-order configuration is DEADLOCKED.\n");
    printf("Parent: manual interrupt/timeout used to stop demonstration.\n");

    exit(0);
}

void
good_process(int id, int lock1, int lock2)
{
    printf("Process %d: acquiring Lock1\n", id);
    sem_wait(lock1);
    printf("Process %d: acquired Lock1\n", id);

    delay();

    printf("Process %d: acquiring Lock2\n", id);
    sem_wait(lock2);
    printf("Process %d: acquired Lock2\n", id);

    printf("Process %d: work completed\n", id);

    sem_signal(lock2);
    sem_signal(lock1);

    printf("Process %d: released Lock2 and Lock1\n", id);

    exit(0);
}

void
run_fixed(void)
{
    int lock1 = sem_create(1);
    int lock2 = sem_create(1);

    printf("=== FIXED ORDER: NO DEADLOCK ===\n");

    int pid_a = fork();

    if (pid_a == 0)
        good_process(0, lock1, lock2);

    int pid_b = fork();

    if (pid_b == 0)
        good_process(1, lock1, lock2);

    wait(0);
    wait(0);

    printf("Both processes completed without deadlock.\n");

    sem_free(lock1);
    sem_free(lock2);

    printf("Resource ordering successfully prevented deadlock.\n");
}

int
main(int argc, char *argv[])
{
    printf("Resource Ordering Deadlock Prevention\n");
    printf("=====================================\n");

    if (argc < 2) {
        printf("Usage: resourceorder bad | fixed\n");
        exit(1);
    }

    if (strcmp(argv[1], "bad") == 0) {
        run_bad();
    } else if (strcmp(argv[1], "fixed") == 0) {
        run_fixed();
    } else {
        printf("Invalid mode. Use: bad or fixed\n");
    }

    exit(0);
}
