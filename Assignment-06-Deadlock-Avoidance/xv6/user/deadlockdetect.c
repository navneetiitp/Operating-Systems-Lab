#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define N 5
#define R 3

int allocation[N][R];
int request[N][R];
int graph[N][N];

int visited[N];
int stack[N];
int path[N];
int path_len;

void
build_graph(void)
{
    for (int i = 0; i < N; i++)
        for (int j = 0; j < N; j++)
            graph[i][j] = 0;

    for (int i = 0; i < N; i++) {
        for (int r = 0; r < R; r++) {
            if (!request[i][r])
                continue;

            for (int j = 0; j < N; j++) {
                if (allocation[j][r]) {
                    graph[i][j] = 1;
                }
            }
        }
    }
}

void
print_graph(void)
{
    printf("Wait-for Graph:\n");

    for (int i = 0; i < N; i++)
        for (int j = 0; j < N; j++)
            if (graph[i][j])
                printf("P%d -> P%d\n", i, j);
}

int
dfs(int u)
{
    visited[u] = 1;
    stack[u] = 1;
    path[path_len++] = u;

    for (int v = 0; v < N; v++) {
        if (!graph[u][v])
            continue;

        if (!visited[v]) {
            if (dfs(v))
                return 1;
        } else if (stack[v]) {
            printf("Deadlock cycle: ");

            int i = 0;
            while (i < path_len && path[i] != v)
                i++;

            for (; i < path_len; i++)
                printf("P%d -> ", path[i]);

            printf("P%d\n", v);
            return 1;
        }
    }

    stack[u] = 0;
    path_len--;
    return 0;
}

int
detect_deadlock(void)
{
    for (int i = 0; i < N; i++) {
        visited[i] = 0;
        stack[i] = 0;
    }

    path_len = 0;

    for (int i = 0; i < N; i++) {
        if (!visited[i] && dfs(i))
            return 1;
    }

    printf("No deadlock detected.\n");
    return 0;
}

void
scenario_no_deadlock(void)
{
    printf("\n=== Scenario 1: No Deadlock ===\n");

    int a[N][R] = {
        {1, 0, 0},
        {0, 1, 0},
        {0, 0, 1},
        {0, 0, 0},
        {0, 0, 0}
    };

    int q[N][R] = {
        {0, 1, 0},
        {0, 0, 1},
        {0, 0, 0},
        {1, 0, 0},
        {0, 0, 0}
    };

    for (int i = 0; i < N; i++)
        for (int r = 0; r < R; r++) {
            allocation[i][r] = a[i][r];
            request[i][r] = q[i][r];
        }

    build_graph();
    print_graph();
    detect_deadlock();
}

void
scenario_deadlock(void)
{
    printf("\n=== Scenario 2: Deadlock ===\n");

    int a[N][R] = {
        {1, 0, 0},
        {0, 1, 0},
        {0, 0, 1},
        {0, 0, 0},
        {0, 0, 0}
    };

    int q[N][R] = {
        {0, 1, 0},
        {0, 0, 1},
        {1, 0, 0},
        {0, 0, 0},
        {0, 0, 0}
    };

    for (int i = 0; i < N; i++)
        for (int r = 0; r < R; r++) {
            allocation[i][r] = a[i][r];
            request[i][r] = q[i][r];
        }

    build_graph();
    print_graph();
    detect_deadlock();
}

int
main(int argc, char *argv[])
{
    printf("Deadlock Detection using Resource Allocation Graph\n");
    printf("===================================================\n");

    scenario_no_deadlock();
    scenario_deadlock();

    printf("\nDeadlock detection test completed successfully.\n");

    exit(0);
}
