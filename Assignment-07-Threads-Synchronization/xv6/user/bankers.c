#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define N 5
#define M 3

int allocation[N][M] = {
    {0, 1, 0},
    {2, 0, 0},
    {3, 0, 2},
    {2, 1, 1},
    {0, 0, 2}
};

int max[N][M] = {
    {7, 5, 3},
    {3, 2, 2},
    {9, 0, 2},
    {2, 2, 2},
    {4, 3, 3}
};

int available[M] = {3, 3, 2};

void
calculate_need(int need[N][M])
{
    for (int i = 0; i < N; i++)
        for (int j = 0; j < M; j++)
            need[i][j] = max[i][j] - allocation[i][j];
}

int
is_safe(int print_sequence)
{
    int need[N][M];
    int work[M];
    int finish[N];
    int sequence[N];
    int count = 0;

    calculate_need(need);

    for (int j = 0; j < M; j++)
        work[j] = available[j];

    for (int i = 0; i < N; i++)
        finish[i] = 0;

    while (count < N) {
        int found = 0;

        for (int i = 0; i < N; i++) {
            if (finish[i])
                continue;

            int possible = 1;

            for (int j = 0; j < M; j++) {
                if (need[i][j] > work[j]) {
                    possible = 0;
                    break;
                }
            }

            if (possible) {
                for (int j = 0; j < M; j++)
                    work[j] += allocation[i][j];

                finish[i] = 1;
                sequence[count++] = i;
                found = 1;
            }
        }

        if (!found)
            break;
    }

    if (count != N) {
        if (print_sequence)
            printf("System is NOT in a safe state.\n");
        return 0;
    }

    if (print_sequence) {
        printf("System is in a SAFE state.\n");
        printf("Safe sequence: ");

        for (int i = 0; i < N; i++) {
            printf("P%d", sequence[i]);
            if (i != N - 1)
                printf(" -> ");
        }

        printf("\n");
    }

    return 1;
}

int
request_resources(int process, int request[M])
{
    int need[N][M];

    calculate_need(need);

    printf("\nRequest from P%d: [%d %d %d]\n",
           process, request[0], request[1], request[2]);

    for (int j = 0; j < M; j++) {
        if (request[j] > need[process][j]) {
            printf("Request denied - exceeds Need.\n");
            return 0;
        }

        if (request[j] > available[j]) {
            printf("Request denied - resources are not Available.\n");
            return 0;
        }
    }

    for (int j = 0; j < M; j++) {
        available[j] -= request[j];
        allocation[process][j] += request[j];
    }

    printf("Request temporarily granted. Checking safety...\n");

    if (is_safe(0)) {
        printf("Request GRANTED - system remains safe.\n");
        return 1;
    }

    for (int j = 0; j < M; j++) {
        available[j] += request[j];
        allocation[process][j] -= request[j];
    }

    printf("Request denied - would lead to unsafe state.\n");
    return 0;
}

void
print_state(void)
{
    int need[N][M];

    calculate_need(need);

    printf("\nAllocation Matrix:\n");

    for (int i = 0; i < N; i++)
        printf("P%d: %d %d %d\n",
               i, allocation[i][0], allocation[i][1], allocation[i][2]);

    printf("\nMax Matrix:\n");

    for (int i = 0; i < N; i++)
        printf("P%d: %d %d %d\n",
               i, max[i][0], max[i][1], max[i][2]);

    printf("\nNeed Matrix:\n");

    for (int i = 0; i < N; i++)
        printf("P%d: %d %d %d\n",
               i, need[i][0], need[i][1], need[i][2]);

    printf("\nAvailable: [%d %d %d]\n",
           available[0], available[1], available[2]);
}

int
main(int argc, char *argv[])
{
    int safe_request[M] = {1, 0, 2};
    int unsafe_request[M] = {3, 3, 0};

    printf("Banker's Algorithm Simulation\n");
    printf("==============================\n");

    print_state();

    printf("\n--- Initial Safety Check ---\n");
    is_safe(1);

    printf("\n--- Scenario 1: Safe Request ---\n");
request_resources(1, safe_request);

/* Reset the system to the original state for Scenario 2. */
int original_allocation[N][M] = {
    {0, 1, 0},
    {2, 0, 0},
    {3, 0, 2},
    {2, 1, 1},
    {0, 0, 2}
};

int original_available[M] = {3, 3, 2};

for (int i = 0; i < N; i++)
    for (int j = 0; j < M; j++)
        allocation[i][j] = original_allocation[i][j];

for (int j = 0; j < M; j++)
    available[j] = original_available[j];

printf("\n--- Scenario 2: Unsafe Request ---\n");
request_resources(4, unsafe_request);

    printf("\nBanker's Algorithm test completed successfully.\n");

    exit(0);
}
