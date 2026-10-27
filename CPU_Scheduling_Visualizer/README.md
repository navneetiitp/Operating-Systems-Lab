# CPU Scheduling Algorithm Visualizer

Responsive front-end Operating Systems project. No install or backend is required.

## Included algorithms

1. FCFS — First Come, First Served
2. SJF — Shortest Job First (non-preemptive)
3. SRTF — Shortest Remaining Time First (preemptive)
4. Priority Scheduling (non-preemptive)
5. Priority Scheduling (preemptive)
6. Round Robin
7. HRRN — Highest Response Ratio Next
8. LJF — Longest Job First (non-preemptive)
9. LRTF — Longest Remaining Time First (preemptive)
10. MLQ — Multilevel Queue
11. MLFQ — Multilevel Feedback Queue

## MLQ/MLFQ assumptions

- **MLQ:** The Priority field represents a fixed queue number; 1 is the highest-priority queue. The highest-priority non-empty queue is selected, and each queue uses Round Robin with the selected quantum. Processes do not move between queues.
- **MLFQ:** Three queues: Q1 uses Round Robin with quantum 2, Q2 uses Round Robin with quantum 4, and Q3 uses FCFS. A process that consumes its full quantum is demoted. A newly arriving process enters Q1; Q1 work can preempt work from lower queues.

These are explicit educational policies; some textbooks define MLQ and MLFQ with different queue policies.

## Metrics

CT = Completion Time; TAT = CT − Arrival Time; WT = TAT − Burst Time; RT = First Start Time − Arrival Time. The page also shows average waiting, turnaround and response times, CPU utilization, and a Gantt chart.

## Run

1. Extract the ZIP.
2. Open `index.html` in a modern browser.
3. Choose an algorithm and add processes or load the sample.
4. Set a time quantum for RR or MLQ.
5. Click **Run scheduling**. Export the table to CSV if needed.

## Files

- `index.html` — page layout
- `style.css` — responsive styling
- `script.js` — scheduling logic and metrics
