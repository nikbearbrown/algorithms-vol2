# Chapter 5 — Scheduling

*Every system that runs more than one thing has already made a scheduling decision. Most of them are wrong.*

---

Here is a question that sounds administrative but is actually deep.

You have a list of tasks. You have a set of machines to run them on. Each task takes some amount of time. Some tasks can't start until others finish. Some have deadlines. You want to finish everything as fast as possible, or minimize how long people wait, or make sure you never miss a deadline. How do you decide what runs when?

This is scheduling. It shows up in the kernel of your operating system, deciding which process gets the CPU next. It shows up in a build system, deciding which compilation units to run in parallel. It shows up in a factory, deciding which job to load onto which machine. It shows up in your own week, when you're looking at six things that need to happen and trying to figure out what order to do them in. The same mathematics governs all of these — and the naive answer, which almost everyone reaches for first, fails in ways that are both predictable and avoidable.

The naive answer is: sort by priority. Put the most important thing first. Work down the list. This is exactly right for one specific scheduling problem, and wrong for almost every other one. Understanding why it's wrong — and what to do instead — is what this chapter is about.

---

## What makes it a scheduling problem

Let me be precise about the structure, because it's easy to confuse scheduling with related problems that require different tools.

A scheduling problem has three components. Tasks: things that need to happen, each with a processing time, possibly a deadline, possibly a priority, possibly a release date before which they can't start. Resources: machines, workers, CPUs, or anything that can process at most some fixed capacity of tasks at once. An objective: the thing you're trying to optimize — finish everything as quickly as possible, minimize average waiting time, avoid missing deadlines, maximize throughput.

The scheduling problem is to assign tasks to resources over time in a way that satisfies the constraints and optimizes the objective.

This sounds general because it is. The reason to state it carefully is that the objective matters enormously. "Finish everything as fast as possible" (minimizing makespan) produces different optimal schedules than "minimize average waiting time" (minimizing total completion time), even on the same set of tasks. And both are different from "never miss a deadline" (EDF-style objectives). The algorithm you need depends on which problem you're actually trying to solve. Skipping this step — jumping straight to "sort by priority" — is what gets people into trouble.

Scheduling theorists have a notation for this, introduced by Graham and colleagues in 1979 [verify]: three fields separated by vertical bars, written $\alpha \mid \beta \mid \gamma$. The first field describes the machine environment — single machine, identical parallel machines, job shop, flow shop. The second describes job characteristics — whether preemption is allowed, whether there are precedence constraints, whether jobs have release dates or due dates. The third describes the objective — makespan, total completion time, maximum lateness, deadline-miss count. Most production scheduling problems map onto a canonical combination in this notation, and the canonical combination tells you which algorithm to reach for.

| Item | Meaning |
| --- | --- |
| as a reference | A concrete checkpoint for applying the chapter concept. |

---

## The single-machine case: where the intuitions come from

Start with the simplest setting. One machine. $n$ tasks. All tasks available at time zero. No deadlines. You want to minimize total completion time — the sum of the times at which each task finishes.

This is $1 \mid\mid \sum C_j$ in the notation. It has an elegant solution.

Suppose you have three tasks: one takes 10 minutes, one takes 3 minutes, one takes 1 minute. In what order should you run them?

If you run them 10, 3, 1: the first task finishes at time 10; the second finishes at time 13; the third finishes at time 14. Total completion time: $10 + 13 + 14 = 37$.

If you run them 1, 3, 10: the first task finishes at time 1; the second finishes at time 4; the third finishes at time 14. Total completion time: $1 + 4 + 14 = 19$.

The total work is the same either way — 14 minutes of actual processing. What changes is how long each task waits. When you run the long task first, every subsequent task has to wait behind it. The long task acts like a slow car blocking a highway. Running the shortest task first gets most tasks out of the way quickly, even though the last task finishes at the same time.

This generalizes. The optimal strategy for $1 \mid\mid \sum C_j$ is Shortest Job First (SJF): order tasks from shortest to longest processing time. This is provably optimal — no other ordering produces a smaller total completion time. The proof is a simple exchange argument: suppose any two adjacent tasks are out of order (a longer one before a shorter one). Swapping them reduces the total completion time. Therefore any schedule with an out-of-order pair can be improved by swapping, so the optimal schedule has no out-of-order pairs, meaning it is sorted shortest-to-longest.

SJF requires knowing processing times in advance. In practice, they're estimated from historical data. In the operating-systems setting, the estimates come from the previous burst time of the process — a crude but often effective heuristic.

Now add deadlines. Each task has a due date $d_j$, and you want to minimize maximum lateness — how badly the worst-case task misses its deadline. The right algorithm is Earliest Deadline First (EDF): always run the task with the earliest deadline. Liu and Layland proved in 1973 [verify] that EDF is optimal for preemptive single-machine scheduling under deadline constraints: if any feasible schedule exists (one that meets all deadlines), EDF will find one. The intuition is similar to SJF — you minimize regret by addressing the most urgent constraint first — but the objective and the criterion are different.

The lesson from these two algorithms is important: the optimal strategy is sensitive to the objective. SJF is wrong if you care about deadlines. EDF is wrong if you care about total completion time. Sorting by priority is wrong for both, unless "priority" happens to encode exactly the right ordering for your specific objective. It usually doesn't.

![Two side-by-side Gantt charts for the same three](images/05-scheduling-fig-01.png)
*Figure 5.1 — Two side-by-side Gantt charts for the same three*

---

## Multiple machines: where it gets hard

One machine is solved. The moment you have more than one machine, most problems become NP-hard.

Consider the simplest multi-machine problem: $m$ identical parallel machines, $n$ tasks, minimize makespan. Called $P \mid\mid C_{\max}$ in the notation. You want all tasks done as quickly as possible, assigning each task to any machine, with no machine running two tasks at once.

This is essentially the question: can you partition $n$ numbers (the processing times) into $m$ groups so that the maximum group sum is minimized? That's the Multiprocessor Scheduling problem, which is NP-hard. No polynomial-time algorithm is known that finds the optimal assignment in general.

What can you do? Two things: approximate, or special-case.

The simplest approximation is greedy list scheduling: process tasks in some order; when a task is ready, assign it to the least-loaded machine. Graham proved in 1966 [verify] that this is a 2-approximation — the makespan is at most twice optimal. Not great, but guaranteed.

A better heuristic is LPT (Longest Processing Time first): sort tasks longest-to-shortest, then apply list scheduling. This is counterintuitive — for the single-machine total-completion-time problem, you ran shortest first. Here you run longest first. The reason: in the parallel setting, the dangerous outcome is finishing with one machine that's still running a long task while all others are idle. Running long tasks first distributes the heavy work early, while short tasks fill in the gaps. LPT achieves a $4/3 - 1/(3m)$ approximation ratio — within 33% of optimal, and better as $m$ grows.

![Two side-by-side parallel-machine Gantt charts with 3 machines](images/05-scheduling-fig-02.png)
*Figure 5.2 — Two side-by-side parallel-machine Gantt charts with 3 machines*

If you need exact solutions, LP relaxation followed by rounding works for many variants. Formulate a variable $x_{j,t}$ indicating whether task $j$ is running at time $t$; write constraints encoding capacity and precedence; solve the LP relaxation; round. The LP relaxation provides a lower bound on the optimal makespan; the rounded solution is a feasible schedule; the gap is the approximation quality. For the unrelated parallel machines variant (where different machines have different speeds for different tasks), Lenstra, Shmoys, and Tardos showed in 1990 [verify] that LP rounding achieves a factor-2 approximation — and no polynomial-time algorithm is known to do better.

---

## Dependencies: the structure that priority sorting cannot encode

Everything above assumed tasks were independent — any task could run on any machine at any time, subject only to capacity. The moment tasks have *dependencies* — task B cannot start until task A finishes — the problem changes character.

Dependency-constrained scheduling is the natural model for build systems, project plans, and any pipeline where data flows from one stage to the next. The dependency structure is a directed acyclic graph (DAG): tasks are nodes, edges encode "must finish before." The scheduling problem is to execute all tasks respecting the edge constraints, using $m$ machines, minimizing total completion time.

This is $P \mid \text{prec} \mid C_{\max}$. NP-hard.

The key concept for dependency-constrained scheduling is the critical path. The critical path is the longest path through the dependency DAG from any source (no predecessors) to any sink (no successors). It has two important properties.

First, the critical path length is a lower bound on makespan — no matter how many machines you have, you cannot finish faster than the critical path, because the tasks on it must execute sequentially in order. Even with infinite parallelism, you're bounded below by the longest chain.

Second, the critical path tells you where to focus. Tasks on the critical path have zero slack — any delay to a critical-path task delays the entire project. Tasks off the critical path have positive slack — they can be delayed by up to their slack without affecting the final finish time. This is the insight behind the Critical Path Method (CPM), developed independently in the late 1950s for construction and engineering project management: compute the critical path, and protect it. When resources are limited and you must prioritize, critical-path tasks get the machine first.

The PERT/CPM calculation is straightforward. For each task, compute earliest start (the latest finish time of all predecessors) and latest start (deadline minus the time needed to complete the task and all its successors). The difference is slack. Tasks with zero slack are on the critical path.

![DAG of 7–8 tasks with durations labeled on](images/05-scheduling-fig-03.png)
*Figure 5.3 — DAG of 7–8 tasks with durations labeled on*

When you add resource constraints — multiple machines, limited memory, workers who can only do certain tasks — the problem is Resource-Constrained Project Scheduling (RCPSP), which is strongly NP-hard even for two resource types. Production systems use heuristics (shifting bottleneck, priority rules adapted to resource levels) or MIP solvers.

---

## Shop scheduling: multiple machines, multiple operations

The most general classical setting is the job shop. Each job is a sequence of operations, each operation requiring a specific machine, and different jobs visit machines in different orders. The question is: in what order should each machine process the jobs assigned to it?

The two-machine job shop is solvable. The three-machine job shop with makespan objective — $J3 \mid\mid C_{\max}$ — is NP-hard (Garey, Johnson, and Sethi, 1976 [verify]). Industrial scheduling with dozens of machines and hundreds of jobs is solved heuristically: shifting bottleneck (identify the machine with the heaviest load and schedule it first, then schedule the rest treating it as fixed), simulated annealing, tabu search, or modern MIP solvers that can find provably near-optimal solutions for moderately-sized instances.

The flow shop is a structured special case: all jobs visit all machines in the same order (job 1 goes machine A → B → C; job 2 goes machine A → B → C; and so on). The two-machine flow shop, $F2 \mid\mid C_{\max}$, is solved exactly by Johnson's rule: schedule first the jobs whose first operation is shorter than their second operation (in order of first-operation time), then the jobs whose second operation is shorter (in reverse order of second-operation time). This elegant $O(n \log n)$ algorithm is optimal. Three or more machines — NP-hard.

---

## A build system

Let me make this concrete with an example that most software engineers have used without necessarily thinking about the scheduling problem inside it.

Bazel is a build system. It takes a dependency graph of build targets and executes them in an order that respects dependencies, using as many parallel workers as you specify. The objective is makespan — finish the build as fast as possible. The constraints are dependencies (you can't compile a file before the files it imports are compiled) and resource limits (memory, I/O, CPU).

This is $P \mid \text{prec} \mid C_{\max}$ — parallel machines with precedence constraints — which is NP-hard. What does Bazel actually do?

A naive greedy scheduler would use topological order: whenever a task is ready (all predecessors complete), assign it to any free worker. This is correct — it always produces a valid build — but it is not optimal for makespan. It ignores the critical path.

Consider a build with a long sequential chain (each target depending on the previous, total compilation time 100 minutes) and a wide independent set (50 targets that can compile in parallel, each taking 1 minute). A naive scheduler might launch many of the independent targets first, filling all workers with 1-minute tasks, while the first task in the long chain waits for a free worker. By the time the chain starts, you've wasted time. A critical-path-aware scheduler identifies the long chain immediately and starts it on the first available worker, running the independent targets in parallel alongside it. The total build time approaches 100 minutes rather than 150.

Bazel uses a heuristic that incorporates critical-path information: when choosing which ready task to schedule next, prefer the task with the longest critical path to completion. Make's simpler scheduler — launch any ready task up to $N$ parallel processes — does not do this. For small builds, the difference is negligible. For large builds (Google's internal monorepo, large open-source projects with deep dependency chains), critical-path awareness saves real time.

The Linux kernel's CPU scheduler, CFS (Completely Fair Scheduler) [verify], is a different kind of scheduling problem entirely. It is not trying to minimize makespan or meet hard deadlines for most tasks. It is trying to give each task a proportional share of CPU time based on its weight — a fairness objective. The implementation uses a red-black tree ordered by virtual runtime: the task that has received the least CPU time (adjusted for weight) runs next. Real-time tasks bypass CFS entirely, running under `SCHED_FIFO` or `SCHED_RR` with strict priority preemption.

The point is that CFS is not "sort by priority." It's a proportional-share scheduler with a specific fairness objective, implemented as a balanced tree for $O(\log n)$ scheduling decisions. Priority is one input; the machinery is more sophisticated.

![Two-column comparison of Bazel vs](images/05-scheduling-fig-04.png)
*Figure 5.4 — Two-column comparison of Bazel vs*

---

## The decision table

| What you have | What you want | Algorithm |
|---|---|---|
| Single machine, all tasks ready, minimize total completion time | $\sum C_j$ | Shortest Job First (SJF) |
| Single machine, tasks with deadlines | Minimize maximum lateness | Earliest Deadline First (EDF) |
| Periodic real-time tasks, fixed priorities | Guarantee schedulability | Rate-Monotonic Scheduling |
| Identical parallel machines, minimize makespan | $C_{\max}$ | LPT heuristic; LP rounding for exact |
| Parallel machines, unrelated speeds | $C_{\max}$ | LP rounding (2-approximation) |
| Two-machine flow shop | $C_{\max}$ | Johnson's rule, $O(n \log n)$, exact |
| Project network, no resource constraint | Minimize duration | Critical Path Method (CPM) |
| Project network with resource constraints | Minimize duration | RCPSP heuristics or MIP solver |
| Job shop, production scale | $C_{\max}$ | Shifting bottleneck + MIP solver |
| Build system with dependency DAG | $C_{\max}$ | Critical-path-aware list scheduling |
| Cloud workload with autoscaling | Throughput | Bin packing + load-balancing dispatch |
| Online arrivals, unpredictable | Competitive ratio | Online algorithms with admission control |
| Hard real-time, strict deadlines | Zero misses | EDF with admission control |

---

## The failure mode

I said at the start that the naive answer — sort by priority — fails in predictable ways. Let me be specific.

Priority sorting is the correct algorithm for $1 \mid\mid \sum w_j C_j$ with weights encoding priority (weighted shortest job first). That's it. In every other setting, it either produces suboptimal results or breaks entirely.

With dependencies, priority sorting is wrong because it doesn't know that task B must wait for task A. A priority sort might schedule B before A, producing an infeasible schedule.

With multiple resources, priority gives an order but not an assignment. Knowing that task 1 is higher priority than task 2 doesn't tell you which of the three machines to put task 1 on. You need a bin-packing component alongside the priority ordering.

With deadlines, priority is a single scalar. Deadlines are time-bounded constraints. EDF and priority scheduling produce different orderings; in the worst case, priority scheduling misses every deadline while EDF misses none.

With fairness requirements, strict priority causes starvation — low-priority tasks never run if high-priority tasks keep arriving. Operating systems address this with aging (priority increases with wait time) or proportional-share mechanisms (CFS). Neither is "just sort by priority."

With NP-hard problem structure, no priority rule finds the optimal solution. Job-shop scheduling requires LP relaxation, MIP solvers, or sophisticated heuristics. Sorting by priority is a heuristic with no approximation guarantee in the general case.

The corrective move is the one I described at the start: state the problem in the three-field notation, identify whether it's a polynomial-time special case or NP-hard, choose the matching algorithm. $1 \mid\mid \sum C_j$: SJF. $1 \mid\mid L_{\max}$: EDF. $F2 \mid\mid C_{\max}$: Johnson's rule. $P \mid\mid C_{\max}$: LPT or LP rounding. The taxonomy is the discipline; "sort by priority" is the shortcut that fails when the problem structure is anything other than the simplest.

---

## What you can now do

You can recognize a scheduling problem — tasks, resources, objective, constraints. You can classify it in the three-field notation and identify the appropriate algorithm for the canonical cases. You know why SJF is optimal for single-machine total-completion-time but wrong for deadline problems, why EDF is optimal for preemptive deadline scheduling, why LPT is a practical approximation for parallel-machine makespan, and why Johnson's rule exactly solves the two-machine flow shop in $O(n \log n)$.

You know what the critical path is, why it is a lower bound on makespan, and why critical-path-aware scheduling dominates naive greedy in build systems and project plans. And you know the precise boundary of "sort by priority" — where it works, what it optimizes, and the five ways it fails when the problem is more complex than its simplest case.

Scheduling is not sorting. It is the problem of assigning work to resources over time, subject to constraints and objectives that interact in ways that simple rules cannot capture. The algorithms exist; recognizing which one fits is the work.

---

## Exercises

### Warm-up

**1.** You have four tasks with processing times 2, 5, 1, and 8 minutes. You are on a single machine with no deadlines and want to minimize total completion time. Write out the optimal order and compute the total completion time. Then write out the worst possible order and compute its total completion time. What is the ratio between worst and optimal?

*Tests: mechanical application of SJF; intuition for how much the ordering matters.*

**2.** Repeat the same four tasks, but now each task has a deadline: task A (duration 2) is due at $t = 3$, task B (duration 5) is due at $t = 10$, task C (duration 1) is due at $t = 2$, task D (duration 8) is due at $t = 20$. Apply EDF: write out the schedule and compute the maximum lateness. Then apply SJF to the same tasks and compute the maximum lateness. Which is worse, and by how much?

*Tests: contrast between SJF and EDF on the same task set; why the objective determines the algorithm.*

**3.** A student says: "I always schedule my most important task first — that's just good practice." Identify the precise conditions under which this is (a) optimal, (b) suboptimal but harmless, and (c) actively counterproductive. Use the $\alpha \mid \beta \mid \gamma$ notation to name the cases.

*Tests: boundaries of the priority-sort heuristic; using the three-field notation as a classification tool.*

---

### Application

**4.** You are managing a three-engineer team for a two-week sprint. Tasks arrive with estimated durations (in days); some tasks have hard delivery deadlines within the sprint; some tasks block other tasks. Write the $\alpha \mid \beta \mid \gamma$ classification for this problem. Is it polynomial-time solvable or NP-hard? Which algorithm or heuristic would you reach for, and why?

*Tests: classification of a realistic scheduling scenario; mapping a real problem onto the taxonomy.*

**5.** You have five tasks with processing times 6, 6, 5, 4, and 3, to be scheduled on two identical parallel machines. Apply LPT: show the assignment step by step. What is the makespan? Now try the reverse order (SPT — Shortest Processing Time first). What is the makespan? Compare both to the theoretical lower bound $\lceil \text{total work} / m \rceil$ and compute each schedule's approximation ratio.

*Tests: mechanical application of LPT and SPT on parallel machines; understanding the lower bound and approximation ratio.*

**6.** A software project has the following dependency structure: task A (3 days) must complete before tasks B (2 days) and C (5 days) can start; task D (4 days) must complete before task E (1 day); tasks B, D, and E can all run in parallel with each other once their predecessors finish; task F (2 days) depends on both C and E. Draw the dependency DAG, identify the critical path, and compute the minimum possible project duration assuming unlimited parallel resources.

*Tests: DAG construction; critical path identification; understanding that the critical path is a lower bound regardless of parallelism.*

**7.** In the build-system example, the chapter describes a dependency graph with a long sequential chain (100 minutes total) and a wide independent component (50 tasks × 1 minute each). Suppose you have 4 parallel workers. Under naive greedy scheduling (assign any ready task to any free worker), estimate the worst-case makespan. Under critical-path-aware scheduling, what is the optimal makespan? Explain why the difference exists.

*Tests: concrete application of critical-path-aware vs. naive scheduling; understanding the mechanism behind the gap.*

---

### Synthesis

**8.** You are scheduling jobs in a two-machine flow shop. Six jobs have the following operation times:

| Job | Machine 1 time | Machine 2 time |
|-----|---------------|---------------|
| A   | 3             | 7             |
| B   | 8             | 2             |
| C   | 5             | 5             |
| D   | 1             | 6             |
| E   | 9             | 3             |
| F   | 4             | 8             |

Apply Johnson's rule to find the optimal sequence. Compute the makespan of your sequence. Then compute the makespan of the reverse sequence and compare.

*Tests: mechanical application of Johnson's rule; understanding that it produces an exact optimum for F2 || C_max.*

**9.** A student claims: "The three-field notation is just academic — in practice you sort by priority, maybe weighted by deadline, and it's fine." Construct a concrete counterexample with no more than five tasks and two machines where weighted-priority scheduling produces a schedule that is at least 50% worse than optimal makespan. Specify the task durations, priorities, and the two schedules.

*Tests: constructing adversarial examples; understanding where priority-based heuristics structurally fail.*

---

### Challenge

**10.** The Resource-Constrained Project Scheduling Problem (RCPSP) extends CPM by adding resource limits. Suppose you have a project network of 6 tasks, each consuming some amount of a shared resource (e.g., developer-days), and you have a total of 3 resource units per day. Describe how resource constraints can force you to serialize tasks that would otherwise run in parallel, and explain why this can push the actual project duration beyond the critical path length. What does this imply for the critical path as a lower bound in the resource-constrained case?

*Tests: understanding the gap between CPM and RCPSP; why resource constraints break the critical-path lower bound argument.*

**11.** Linux CFS is described as a proportional-share scheduler, not a priority scheduler. Explain the difference between these two objectives, and describe why CFS's implementation as a red-black tree ordered by virtual runtime achieves proportional sharing rather than strict priority. What would go wrong if you replaced the virtual-runtime ordering with a static priority ordering? Connect your answer to the starvation failure mode named in the chapter.

*Tests: understanding fairness objectives in scheduling; connecting implementation mechanism to the objective it achieves.*

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

1. Classify the problem in the standard taxonomy.
   - Single-machine? (one resource, sequence the tasks)
   - Parallel-machine? (multiple identical resources)
   - Job-shop? (multiple distinct resources, each task needs a
     specific one)
   - Flow-shop? (tasks pass through resources in a fixed order)
   - Project network? (tasks have precedence dependencies, the
     question is total duration)
   Be specific. The class determines the algorithm.

2. State the objective. What's the cost function?
   - Makespan (finish everything as fast as possible)?
   - Average completion time / weighted completion time?
   - Maximum lateness / number of late tasks?
   - Throughput?
   - Some combination?
   If I can't name the cost function, I can't pick the algorithm.

3. Name the constraints.
   - Deadlines (hard or soft)?
   - Dependencies (this task before that one)?
   - Resource conflicts (this engineer can't do A and B at once)?
   - Setup costs / context-switching costs?
   - Calendar holes (no work on weekends)?

4. Pick an approach.
   - Heuristic (list scheduling, EDF, SPT/SRT): fast, no guarantee.
     Most production scheduling lives here.
   - Critical-path analysis: best for project networks; identifies
     where slack exists.
   - LP-based exact: for small problems with linear structure.
   - Approximation: for known-hard cases (parallel-machine
     makespan is NP-hard; LPT is a 4/3-approximation).

5. What does the critical path look like? Even if I'm not formally
   running CPM, identifying the longest dependency chain often
   reveals the actual bottleneck — and what I should protect or
   unblock.

6. Surface the priority-sort failure mode. Am I sorting by priority
   and then assigning to slots? That works for single-machine,
   no-deadline cases. Where does it break for me?

7. Where does my plan have hidden assumptions? Schedules often hide
   assumptions about task duration certainty, about resource
   availability, about whether anyone gets sick.

Output: a structured diary entry. Headings: The scheduling problem,
Classification, Objective, Constraints, Approach chosen, Critical
path (or bottleneck), Hidden assumptions, What I'll do next, What
would change my mind, Outcome (to fill in later).
```

**What this produces:** A diary entry that classifies your scheduling problem in the standard taxonomy, names the objective explicitly, and (most usefully) surfaces the assumptions about duration and availability that your plan has been quietly making.

**How to adapt this prompt:**

- *For your own project:* The system prompt personalizes it. For team-scheduling problems, the entry is often a useful artifact to share with the team after writing.
- *For ChatGPT / Gemini:* Both work. Either can produce a Gantt-style markdown table or an ASCII timeline for the project plan.
- *For Claude Code:* Worth a sidecar if your problem is large or formal — ask Claude Code to formulate the scheduling problem in OR-Tools and solve it. The diary entry is the human reasoning; the solver gives the exact assignment.
- *For a Claude Project:* Native fit. Recurring scheduling entries reveal your team's chronic bottleneck.

**Connection to previous chapters:** LP for scheduling traces back to Vol. 1 Chapter 13; approximation framing to Vol. 1 Chapter 11. The bandit framing (Chapter 3) reappears when you treat *which task to start next* as an information-acquisition decision under uncertainty.

**Preview of next chapter:** Chapter 6 (Stable Matching) returns to two-sided problems — but instead of strategy and competition, the question is *pairing* with stability. Hiring matches, school choice, partner-finding, vendor-engineer assignments, residency-style markets.

---

## AI Wayback Machine

The ideas in this chapter didn't appear from nowhere. **Eugene Lawler** helped found combinatorial optimization at Berkeley in the 1960s — co-authoring the canonical book on machine scheduling and proving complexity results that decide which scheduling problems are tractable and which aren't. His three-field notation still classifies scheduling problems today.

**Run this:**

```
Who was Eugene Lawler, and how does his work on combinatorial scheduling
and the three-field classification connect to the scheduling algorithms
we used in this chapter? Keep it to three paragraphs. End with the
single most surprising thing about his career or ideas.
```

→ Search **"Eugene Lawler"** on Wikipedia. See what the model got right, got wrong, or left out.

**Now make the prompt better.** Try one of these:

- Ask it to explain Lawler's three-field notation using one specific scheduling problem from this chapter as the example.
- Add a constraint: "Answer as Lawler's 1970s lecture notes on integer programming for scheduling."

What changes? What gets better? What gets worse?
