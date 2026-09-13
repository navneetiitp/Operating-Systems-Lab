#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define PRINTER 0
#define SCANNER 1
#define DISK 2

void
delay(void)
{
    for (volatile int i = 0; i < 500000; i++)
        ;
}

void
print_event(int print_lock, int id, char *msg)
{
    sem_wait(print_lock);
    printf("Process %d: %s\n", id, msg);
    sem_signal(print_lock);
}

void
acquire_resource(int print_lock, int id, int resource, int sem)
{
    if (resource == PRINTER)
        print_event(print_lock, id, "requesting Printer");
    else if (resource == SCANNER)
        print_event(print_lock, id, "requesting Scanner");
    else
        print_event(print_lock, id, "requesting Disk");

    sem_wait(sem);

    if (resource == PRINTER)
        print_event(print_lock, id, "granted Printer");
    else if (resource == SCANNER)
        print_event(print_lock, id, "granted Scanner");
    else
        print_event(print_lock, id, "granted Disk");
}

void
release_resource(int print_lock, int id, int resource, int sem)
{
    sem_signal(sem);

    if (resource == PRINTER)
        print_event(print_lock, id, "released Printer");
    else if (resource == SCANNER)
        print_event(print_lock, id, "released Scanner");
    else
        print_event(print_lock, id, "released Disk");
}

void
run_process(int id, int first_resource, int second_resource,
            int printer, int scanner, int disk, int print_lock)
{
    int first_sem;
    int second_sem;

    if (first_resource == PRINTER)
        first_sem = printer;
    else if (first_resource == SCANNER)
        first_sem = scanner;
    else
        first_sem = disk;

    if (second_resource == PRINTER)
        second_sem = printer;
    else if (second_resource == SCANNER)
        second_sem = scanner;
    else
        second_sem = disk;

    for (int cycle = 1; cycle <= 2; cycle++) {
        sem_wait(print_lock);
        printf("Process %d: cycle %d starting\n", id, cycle);
        sem_signal(print_lock);

        acquire_resource(print_lock, id, first_resource, first_sem);
        delay();

        acquire_resource(print_lock, id, second_resource, second_sem);

        print_event(print_lock, id, "starting work");
        delay();

        print_event(print_lock, id, "work completed");

        release_resource(print_lock, id, second_resource, second_sem);
        release_resource(print_lock, id, first_resource, first_sem);

        sem_wait(print_lock);
        printf("Process %d: cycle %d completed\n", id, cycle);
        sem_signal(print_lock);

        delay();
    }

    sem_wait(print_lock);
    printf("Process %d: finished all cycles\n", id);
    sem_signal(print_lock);

    exit(0);
}

int
main(int argc, char *argv[])
{
    int printer;
    int scanner;
    int disk;
    int print_lock;

    printf("Combined Synchronization and Deadlock Avoidance\n");
    printf("================================================\n");
    printf("Strategy: Resource Ordering\n");
    printf("Global order: Printer -> Scanner -> Disk\n");
    printf("Resources: 2 Printers, 1 Scanner, 2 Disks\n\n");

    printer = sem_create(2);
    scanner = sem_create(1);
    disk = sem_create(2);
    print_lock = sem_create(1);

    int pid;

    pid = fork();
    if (pid == 0)
        run_process(0, PRINTER, SCANNER,
                    printer, scanner, disk, print_lock);

    pid = fork();
    if (pid == 0)
        run_process(1, SCANNER, DISK,
                    printer, scanner, disk, print_lock);

    pid = fork();
    if (pid == 0)
        run_process(2, PRINTER, DISK,
                    printer, scanner, disk, print_lock);

    pid = fork();
    if (pid == 0)
        run_process(3, PRINTER, DISK,
                    printer, scanner, disk, print_lock);

    pid = fork();
    if (pid == 0)
        run_process(4, PRINTER, SCANNER,
                    printer, scanner, disk, print_lock);

    wait(0);
    wait(0);
    wait(0);
    wait(0);
    wait(0);

    printf("\nAll 5 processes completed successfully.\n");
    printf("No process was permanently blocked.\n");
    printf("No resource was over-allocated.\n");
    printf("Resource ordering successfully prevented deadlock.\n");

    sem_free(printer);
    sem_free(scanner);
    sem_free(disk);
    sem_free(print_lock);

    exit(0);
}
