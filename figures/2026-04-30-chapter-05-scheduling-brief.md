# Figure brief — Chapter 05: Scheduling

## Recommended figures

### Figure 1 — Three-field α|β|γ classification
**Path:** `../images/chapter-5-three-field-notation.jpg`
**Description:** Tabular reference. α column with machine environments (1, P, R, F, J, O). β column with constraints (preemption, precedence, release dates, due dates). γ column with objectives (C_max, ΣC_j, Σw_j C_j, L_max). Caption: "Most production scheduling fits one of the canonical combinations."
**Use:** referenced in §3 (Classification).

### Figure 2 — Scheduling algorithms on a Gantt chart
**Path:** `../images/chapter-5-gantt-comparison.jpg`
**Description:** Same set of jobs scheduled by FCFS, SJF, EDF, and round-robin. Gantt charts side-by-side showing how each algorithm orders execution. Average waiting time annotated for each.
**Use:** referenced in §4 (Single-machine algorithms).

### Figure 3 — Build dependency graph with critical path
**Path:** `../images/chapter-5-build-critical-path.jpg`
**Description:** DAG of build targets with edge weights (time per task). Critical path highlighted in red. Tasks with slack annotated with their float (slack time). Annotation: "Critical path determines minimum makespan."
**Use:** referenced in §7 (Worked example).

### Figure 4 — List scheduling 2-approximation construction
**Path:** `../images/chapter-5-list-scheduling.jpg`
**Description:** Two-machine example. Tasks arrive one by one, assigned to least-loaded machine. Final makespan compared to optimal. Caption: "Greedy list scheduling achieves makespan ≤ 2 × OPT."
**Use:** referenced in §5 (Parallel-machine and shop scheduling).

### Figure 5 — LP-relaxation time-indexed formulation
**Path:** `../images/chapter-5-lp-time-indexed.jpg`
**Description:** Visual representation of `x_{j,t}` = "is job `j` running at time `t`?" matrix. Constraints (capacity, precedence) annotated. Fractional LP solution shown vs rounded integer solution.
**Use:** referenced in §6 (LP-based and approximation methods).

## Inline figure-call markers
None inserted in current draft.
