# Scheduling

## TL;DR

Scheduling assigns tasks to resources over time subject to constraints — capacity, ordering, deadlines, dependencies. Reach for this chapter when a problem has the shape "what runs when, on what machine, in what order?" — CPU scheduling, build systems, factory floors, cloud workloads, project plans, network packet ordering. After consulting it, you can model a scheduling problem in the standard taxonomy, choose between exact algorithms, heuristics, and approximation, and recognize when the problem reduces to a well-studied special case.

## Recognition pattern

Three signals.

*Tasks, resources, and an objective.* Tasks have running times, deadlines, priorities, dependencies. Resources have capacities (one task at a time, or many in parallel). The objective is some function of completion times — total time (makespan), average waiting time, weighted lateness, throughput, deadline-miss rate. The combination is a scheduling problem.

*Capacity is the bottleneck.* If you had infinite parallelism, scheduling wouldn't matter — run everything immediately. Scheduling earns its place because resources are scarce and decisions about ordering or assignment affect the objective.

*The problem decomposes into well-studied building blocks.* Single-machine, parallel-machine, job-shop, flow-shop, project network — these classical formulations cover most production scheduling. Recognizing your problem as one of them gives you the algorithmic toolkit.

A signal scheduling is *not* the right tool: the problem is so dynamic that planning ahead is wasted effort. Hard real-time systems with unpredictable arrivals use admission control rather than schedules. Reactive load balancers don't pre-schedule; they dispatch on arrival. Where the planning horizon is short and the variance is high, simpler dispatching rules dominate.

The misconception engaged in §9 — "scheduling is just sorting by priority" — gets the easy cases right and the hard cases catastrophically wrong. Priority queues handle single-machine, no-deadline, simple-criterion problems. Real scheduling involves dependencies, deadlines, multiple resources, and objectives that priority sorting cannot encode.

## What you need to know first

This chapter assumes Big O (Vol. 1 Chapter 2), basic graph theory for project networks (Vol. 1 Chapter 5), and approximation-algorithm framing (Vol. 1 Chapter 11). For LP-based scheduling solutions, see Vol. 1 Chapter 13. For NP-hardness of general scheduling, see Vol. 1 Chapter 10. For the heap data structure underlying priority queues, see Vol. 1 Chapter 3 §4.

## Classification — the standard taxonomy

Scheduling theorists use a three-field notation `α | β | γ` (Graham et al. 1979) [verify]:

- `α` — machine environment: single machine (1), identical parallel (P), unrelated parallel (R), flow shop (F), job shop (J), open shop (O).
- `β` — job characteristics: preemption allowed (`pmtn`), precedence constraints (`prec`), release dates (`r_j`), due dates (`d_j`), processing-time properties.
- `γ` — objective: makespan (`C_max`), total completion time (`ΣC_j`), weighted completion time (`Σw_j C_j`), maximum lateness (`L_max`), tardiness, deadline-miss count.

Most production scheduling fits one of the canonical combinations. `1 | | C_max` (single machine, makespan) is trivially solvable in any order. `1 | | ΣC_j` (single machine, total completion time) is solved by Shortest Processing Time first (SPT). `P | | C_max` (parallel machines, makespan) is NP-hard but admits constant-factor approximation.

Recognizing the canonical form is the first analytic step. Most production problems are special cases of well-studied problems.

## Single-machine algorithms

**FCFS (First-Come First-Served).** Tasks executed in arrival order. Simple, fair, no starvation. Average waiting time can be poor if a long task arrives first (the "convoy effect"). Used as a baseline; rarely production-optimal.

**SJF (Shortest Job First).** Task with smallest burst time runs first. Optimal for average waiting time on a single machine with all tasks present at time zero. Requires knowing burst times in advance — usually estimated from history.

**SRTF (Shortest Remaining Time First).** Preemptive variant of SJF. Currently-running task is preempted if a shorter task arrives.

**Priority scheduling.** Each task has a priority; highest-priority task runs first. Can be preemptive or non-preemptive. Risk: low-priority tasks starve unless aging mechanism boosts their priority over time.

**EDF (Earliest Deadline First).** Task with earliest deadline runs first. Optimal for deadline-miss minimization on preemptive single-machine systems if total demand `≤` capacity (Liu and Layland 1973) [verify]. Used in real-time systems.

**Rate-Monotonic Scheduling.** For periodic tasks, assign priority inversely to period (shorter period = higher priority). Optimal for fixed-priority real-time scheduling under the rate-monotonic utilization bound `n(2^(1/n) − 1) ≈ 69%` for `n` tasks (Liu and Layland 1973) [verify].

**Round-Robin.** Time-quantum-based preemption; tasks rotate through CPU. Used in time-sharing systems for fairness. Throughput vs latency depends on quantum length.

## Parallel-machine and shop scheduling

**Identical parallel machines, makespan minimization.** `P | | C_max` is NP-hard. Greedy list scheduling (each arriving task → least-loaded machine) is a 2-approximation in the worst case (Graham 1966) [verify]. Longest-Processing-Time-first (LPT) achieves 4/3 − 1/(3m) approximation. PTAS exists.

**Unrelated parallel machines.** Different machines have different processing times for different jobs. NP-hard; LP rounding gives 2-approximation (Lenstra-Shmoys-Tardos 1990) [verify].

**Job shop.** Jobs visit machines in different orders. NP-hard for `J3 | | C_max` (Garey-Johnson-Sethi 1976) [verify]. Heuristics (shifting bottleneck, simulated annealing, tabu search) and modern MIP solvers handle production instances.

**Flow shop.** All jobs visit machines in the same order. `F2 | | C_max` (two machines) is solved exactly by Johnson's rule in `O(n log n)` (Johnson 1954) [verify]. Three or more machines is NP-hard.

**Open shop.** Jobs visit all machines; order is unrestricted. `O2 | | C_max` is polynomial; `O3 | | C_max` is NP-hard.

**Project scheduling (PERT/CPM).** Tasks with precedence constraints, no resource competition (or unlimited resources). Critical Path Method computes earliest and latest start times; the critical path is the longest path through the precedence graph. Slack on non-critical tasks gives scheduling flexibility. Used in construction, manufacturing, software project planning.

## LP-based and approximation methods

For NP-hard scheduling problems, LP relaxation followed by rounding is a workhorse approximation technique.

**Time-indexed LP.** Variable `x_{j,t}` = "is job `j` running at time `t`?" Constraints encode capacity and precedence. The LP relaxation has fractional `x`'s; rounding to integers gives a feasible schedule with bounded approximation. Used for many `1 | r_j | Σw_j C_j` and `P | | ΣC_j` problems.

**LP-rounding for unrelated parallel machines.** Lenstra-Shmoys-Tardos 1990 [verify] gives the 2-approximation. The technique extends to many related problems.

**Primal-dual scheduling.** Build the schedule and the dual certificate of optimality simultaneously. Used in network packet scheduling (Smoothed Round Robin, Deficit Round Robin).

**Configuration LP.** Variables for each "configuration" (set of jobs that fit on one machine). Exponentially many variables but solvable by column generation. Tight LP relaxations for bin packing and scheduling.

For the LP foundations underlying these methods, see Vol. 1 Chapter 13. For approximation analysis (PTAS, FPTAS, ratio definitions), see Vol. 1 Chapter 11.

## Decision rules

| Situation | Approach |
| --- | --- |
| Single machine, all tasks at time zero, total completion time | SJF (Shortest Job First) |
| Single machine, deadline-driven | EDF (Earliest Deadline First) |
| Periodic real-time tasks, fixed priorities | Rate-Monotonic Scheduling |
| Parallel machines, makespan, simple | List scheduling (LPT for better ratio) |
| Parallel machines, makespan, optimal | LP relaxation + rounding |
| Job shop, real production | Shifting bottleneck heuristic + MIP solver |
| Flow shop, two machines | Johnson's rule (`O(n log n)`, exact) |
| Project network, no resource constraint | CPM (critical path method) |
| Project with resource constraint | RCPSP heuristics or MIP solver |
| Network packet scheduling | DRR, WFQ, or hierarchical token bucket |
| Cloud workload, autoscaling | Bin packing + load-balancing dispatch |
| Highly dynamic, unpredictable arrivals | Online algorithms; competitive ratio analysis |
| Strict deadlines, hard real-time | EDF with admission control |

## Worked example — task scheduling in a build system

Bazel and Make are build systems. They take a graph of build targets (nodes) with dependencies (edges), and execute targets in an order that respects dependencies. The objective: minimize total build time. The constraints: parallelism (number of available cores), I/O capacity, memory.

This is parallel-machine scheduling with precedence constraints — `P | prec | C_max` in the Graham notation. NP-hard in general.

**Naive greedy.** Topological sort the dependency graph, then assign each ready task to any free worker. Works correctly (respects dependencies) but doesn't optimize makespan. Critical-path tasks may be delayed by less-important tasks running first.

**Critical-path-aware scheduling.** Compute the critical path through the dependency DAG. When multiple tasks are ready, prefer those on the critical path or with longer downstream chains. The LPT heuristic adapted to precedence: process tasks in order of remaining critical-path length from each task to a sink.

**Resource-aware scheduling.** Tasks have memory or I/O requirements. Don't schedule two memory-heavy tasks on the same node simultaneously even if cores are free. Bazel's resource model includes CPU, RAM, and custom resources. The scheduler is a multi-dimensional bin packing problem run continuously.

**The production reality.** Bazel uses a priority queue ordered by a heuristic combining critical-path length and available resources. Make's `-j N` flag uses a much simpler scheduler — tasks are launched as soon as ready, up to `N` parallel processes, no critical-path awareness. For small builds the difference is negligible; for large builds (Google's monorepo, large open-source projects) the optimization matters in real time.

**Why naive greedy fails.** Suppose the dependency graph has a long chain (each task depending on the previous, total length 100 minutes) and a wide shallow component (50 independent 1-minute tasks). Naive greedy may assign workers to the wide component first, leaving the long chain to run sequentially at the end with idle workers. Critical-path scheduling launches the chain immediately and runs the wide component in parallel with it.

**Where LP relaxation helps.** For complex precedence graphs with resource constraints, formulate as time-indexed LP with `x_{j,t}` = "is task `j` running at time `t`?" Constraints: precedence, resource capacity. Solve LP, round. The fractional solution provides a lower bound on optimal makespan; the rounded solution is a feasible schedule with bounded suboptimality. Bazel internally uses simpler heuristics; production MIP solvers can find optimal schedules for moderately-sized builds.

**Linux CPU scheduler comparison.** The Linux CFS (Completely Fair Scheduler) [verify] uses a weighted virtual-time mechanism on a red-black tree (Vol. 1 Chapter 3 §5) to choose the next task to run. CFS is *not* a priority sort or a deadline-driven scheduler — it tries to give each task a proportional share of CPU based on weights. Real-time tasks (under `SCHED_FIFO` or `SCHED_RR`) are scheduled with strict priorities and bypass CFS. The scheduler's structure reflects multiple objectives that can't be captured by simple priority ordering.

The lesson: scheduling is not "sort by priority" in any production system. The priority is one input; resource awareness, dependency structure, real-time constraints, and fairness all enter. Naive priority sorting handles toy problems and breaks at scale.

## Failure modes — when "scheduling is just sorting by priority" misleads

The misconception engaged: "Scheduling is just sorting by priority."

The reading captures the simplest scheduling problem and misses everything else. Concrete failure modes.

**Ignoring dependencies.** Priority sorting orders independent tasks. With dependencies, the order is constrained — a downstream task cannot run before its upstream prerequisites. Build systems, project schedules, and any pipeline have dependencies; pure priority sorting is incorrect.

**Ignoring multiple resources.** Priority gives an order. With multiple resources (CPUs, memory, I/O bandwidth), the question is also "which resource does this task use?" Bin packing combined with priority is the right framing for cloud workload scheduling.

**Ignoring deadlines.** Priority is a single number. Deadlines are time-bounded constraints. EDF (deadline-aware) and priority scheduling can produce different orders; using priority where EDF is required produces deadline misses.

**Ignoring fairness.** Strict priority causes starvation — low-priority tasks never run. Aging (boosting priorities over wait time), proportional sharing (CFS-style), and other fairness mechanisms exist to prevent starvation. Pure priority is unfair by construction.

**Ignoring preemption decisions.** Priority orders tasks; preemption decides whether to interrupt a running task when a higher-priority task arrives. Preemption has cost (context switch, cache invalidation). The optimal policy is non-trivial.

**Ignoring the problem's complexity class.** General job-shop scheduling is NP-hard. No priority rule will solve it optimally. Heuristics, LP relaxation, MIP solvers, and approximation algorithms (Vol. 1 Chapter 11) are necessary.

**Ignoring uncertainty.** Stochastic scheduling problems (where job durations are random) require different machinery than deterministic priority scheduling. Stochastic shortest-processing-time variants exist; the analysis is more complex.

**Treating online scheduling as offline.** Online algorithms see jobs as they arrive and must commit immediately. Competitive analysis (worst-case ratio against an offline optimum) is the right framework. Naive priority queues without admission control or deferred-decision logic perform poorly online.

The corrective heuristic: state the scheduling problem in `α | β | γ` notation, identify whether it's a polynomial-time-solvable special case or NP-hard, choose the matching algorithm. Priority sorting is the answer to one specific combination — single machine, no dependencies, simple criterion, no deadlines, no preemption. Production scheduling is rarely that combination.

## Cross-references

For LP and integer programming for exact and approximate scheduling, see Vol. 1 Chapter 13. For approximation algorithms with provable ratios on NP-hard scheduling, see Vol. 1 Chapter 11. For NP-hardness of scheduling problems, see Vol. 1 Chapter 10. For priority queues underlying EDF and SJF, see Vol. 1 Chapter 3 §4. For randomized scheduling and competitive analysis of online algorithms, see Vol. 1 Chapter 12.

## Companion-page handoffs

Scheduling solver comparisons (OR-Tools, IBM CPLEX CP Optimizer, Gurobi); real OS scheduler tracebacks (Linux CFS, Windows scheduler, FreeRTOS); Bazel and Make scheduler internals; PERT/CPM examples with worked critical-path analysis; configuration-LP tutorial for bin-packing-style scheduling. Available at bearbrown.co/algorithms-by-bear-vol2/chapter-5.

## What this chapter does not enable

This chapter does not give a treatment of stochastic scheduling beyond a brief pointer. Stochastic shortest processing time, stochastic order scheduling, and queue-theoretic analyses of scheduling under randomness deserve dedicated coverage; consult Pinedo's *Scheduling: Theory, Algorithms, and Systems* and queue-theoretic references. Online scheduling — competitive analysis, list-scheduling competitive ratios, online bin packing — is touched but not developed; for that, consult Borodin and El-Yaniv's *Online Computation and Competitive Analysis*. Job-shop scheduling at industrial scale uses commercial solvers (Gurobi, CPLEX) whose internals exceed reference scope.

## Capability statement

You can now model a scheduling problem in the standard `α | β | γ` taxonomy; choose between exact algorithms (LP-based, Johnson's rule, EDF), heuristics (list scheduling, LPT, shifting bottleneck), and approximation (LP relaxation + rounding); distinguish single-machine from parallel-machine from shop scheduling; recognize when the problem reduces to a polynomial-time special case; and avoid the failure modes that come from treating scheduling as a single priority queue. The next time tasks need to be assigned to resources over time — CPU, build, factory, project, network — the path from problem to algorithm is in your hands.


---

## LLM Exercise — Chapter 5: A Scheduling Decision

**Project:** *Decision Diary*.

**What you're building this chapter:** A diary entry on one real scheduling problem in your life — your team's sprint, your own week, an allocation of finite engineering capacity, a project plan with dependencies, a series of competing deadlines.

**Tool:** Claude Project (your *Decision Diary*).

**The prompt:**

```
Chapter 5 entry — Scheduling.

The decision I'm thinking through: [one or two sentences naming a
real scheduling problem. Examples: how to sequence the next sprint's
work given five engineers and a hard deadline; how to plan my own
week given six competing commitments and known fatigue patterns; how
to schedule a product launch given marketing, engineering, and
support dependencies; how to allocate research time across grants
with different deadlines; how to order interviews against on-call
shifts.]

Help me work through this as a scheduling problem. The chapter's
central misconception is "scheduling is just sorting by priority" —
which is right for trivial cases and catastrophically wrong for any
problem with dependencies, deadlines, or multiple resources.

Walk me through:

1. **Classify the problem in the standard taxonomy.**
   - Single-machine? (one resource, sequence the tasks)
   - Parallel-machine? (multiple identical resources)
   - Job-shop? (multiple distinct resources, each task needs a
     specific one)
   - Flow-shop? (tasks pass through resources in a fixed order)
   - Project network? (tasks have precedence dependencies, the
     question is total duration)
   Be specific. The class determines the algorithm.

2. **State the objective.** What's the cost function?
   - Makespan (finish everything as fast as possible)?
   - Average completion time / weighted completion time?
   - Maximum lateness / number of late tasks?
   - Throughput?
   - Some combination?
   If I can't name the cost function, I can't pick the algorithm.

3. **Name the constraints.**
   - Deadlines (hard or soft)?
   - Dependencies (this task before that one)?
   - Resource conflicts (this engineer can't do A and B at once)?
   - Setup costs / context-switching costs?
   - Calendar holes (no work on weekends)?

4. **Pick an approach.**
   - Heuristic (list scheduling, EDF, SPT/SRT): fast, no guarantee.
     Most production scheduling lives here.
   - Critical-path analysis: best for project networks; identifies
     where slack exists.
   - LP-based exact: for small problems with linear structure.
   - Approximation: for known-hard cases (parallel-machine
     makespan is NP-hard; LPT is a 4/3-approximation).

5. **What does the critical path look like?** Even if I'm not
   formally running CPM, identifying the longest dependency chain
   often reveals the actual bottleneck — and what I should
   protect or unblock.

6. **Surface the priority-sort failure mode.** Am I sorting by
   priority and then assigning to slots? That works for
   single-machine, no-deadline cases. Where does it break for me?

7. **Where does my plan have hidden assumptions?** Schedules
   often hide assumptions about task duration certainty, about
   resource availability, about whether anyone gets sick.

Output: a structured diary entry. Headings: *The scheduling
problem*, *Classification*, *Objective*, *Constraints*, *Approach
chosen*, *Critical path (or bottleneck)*, *Hidden assumptions*,
*What I'll do next*, *What would change my mind*, *Outcome (to
fill in later)*.
```

**What this produces:** A diary entry that classifies your scheduling problem in the standard taxonomy, names the objective explicitly, and (most usefully) surfaces the assumptions about duration and availability that your plan has been quietly making.

**How to adapt this prompt:**

- *For your own project:* The system prompt personalizes it. For team-scheduling problems, the entry is often a useful artifact to share with the team after writing.
- *For ChatGPT / Gemini:* Both work. Either can produce a Gantt-style markdown table or an ASCII timeline for the project plan.
- *For Claude Code:* Worth a sidecar if your problem is large or formal — ask Claude Code to formulate the scheduling problem in OR-Tools and solve it. The diary entry is the human reasoning; the solver gives the exact assignment.
- *For a Claude Project:* Native fit. Recurring scheduling entries reveal your team's chronic bottleneck.

**Connection to previous chapters:** LP for scheduling traces back to Vol. 1 Chapter 13; approximation framing to Vol. 1 Chapter 11. The bandit framing (Chapter 3) reappears when you treat *which task to start next* as an information-acquisition decision under uncertainty.

**Preview of next chapter:** Chapter 6 (Stable Matching) returns to two-sided problems — but instead of strategy and competition, the question is *pairing* with stability. Hiring matches, school choice, partner-finding, vendor-engineer assignments, residency-style markets.
