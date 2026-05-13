# Research notes — Chapter 05: Scheduling

## Source folders used
- Primary: `Scheduling/Scheduling.md`

## Source sections kept
- `## Introduction to Scheduling` (3–74)
- `## Theoretical Foundations` (75–181) — classification, optimality criteria, complexity
- `## Scheduling Algorithms` (182–349) — FCFS, SJF, priority, round-robin
- `## Advanced Scheduling Techniques` (350–509) — preemption, multiprocessor, real-time
- `## Scheduling in Operating Systems` (510–638)
- `## Scheduling in Production and Manufacturing` (639–751) — informs Bazel/Make worked example
- `## Scheduling in Distributed Systems` (752–912) — load balancing, task allocation, cloud
- `## Mathematical and Heuristic Methods` (1038–1224) — LP approaches, heuristics
- `## Case Studies → Data Centers` (1296–1361)

## Source sections cut
- `## Scheduling in Networks` (913–1037) — used selectively (decision rules)
- `## Evolutionary Algorithms and ML` — magazine
- `## Challenges and Future Directions` (1225–1295)
- `## Case Studies → Smart Grids, Autonomous Systems` — used selectively
- `## Conclusion`
- `## Exercises and Problems`

## Original Claude content (NOT in source)

### Graham et al. 1979 three-field notation
[verify] specific publication. The notation is widely-canonical in scheduling theory.

### Specific algorithm attributions
- Liu and Layland 1973 (rate-monotonic, EDF optimality)
- Graham 1966 (list scheduling 2-approximation)
- Johnson 1954 (two-machine flow shop)
- Garey-Johnson-Sethi 1976 (J3 NP-hardness)
- Lenstra-Shmoys-Tardos 1990 (unrelated machines 2-approximation)

All marked [verify].

### Bazel internals
Real build system; specific scheduler-internals claims marked [verify].

### Linux CFS
Real scheduler; mentioned briefly. [verify] scheduler internals.

### Worked example — Bazel/Make critical-path analysis
Per outline.md. Specific scheduler details about Bazel and Make are general knowledge of build-system practice; specific internal-scheduler claims would need verification.

### Three-perspective comparison (naive greedy / critical-path / resource-aware)
Framing is Claude's; the underlying scheduling concepts are canonical.

## Factual claims preserved from source
- Scheduling algorithm definitions (FCFS, SJF, priority, round-robin) — direct from source
- LP-based scheduling — from source
- Job-shop, flow-shop frameworks — from source
- Operating system scheduling overview — from source

## [verify] count
8 inline `[verify]` markers:
1. Graham et al. 1979 three-field notation
2. Liu-Layland 1973 EDF optimality
3. Liu-Layland 1973 rate-monotonic utilization bound
4. Graham 1966 list scheduling 2-approximation
5. Lenstra-Shmoys-Tardos 1990 unrelated machines
6. Garey-Johnson-Sethi 1976 J3 NP-hard
7. Johnson 1954 two-machine flow shop
8. Linux CFS (Completely Fair Scheduler) red-black tree internals

(Total: 8 inline `[verify]` tags.)

## Structure-drift checks
- Section 1 titled "Recognition pattern" ✓
- Section 2 titled "What you need to know first" ✓
- Decision rules table present ✓
- Worked example: Bazel/Make build scheduling (named in outline.md) ✓
- Failure modes engages "Scheduling is just sorting by priority" ✓
- Anti-capability paragraph present ✓
- Capability statement closes the chapter ✓
- No exercises ✓
- No learning objectives ✓
- No chapter-opening hook ✓

## Voice-anchoring notes
- The α | β | γ classification in §3 is the chapter's reference move — recognizing that the problem at hand is one of the canonical formulations.
- Resisted re-deriving SJF optimality on the page. Reference convention.
- Worked example uses Bazel/Make per outline.md. Specific internals (Bazel's resource model, Make's `-j N` flag, CFS's red-black-tree implementation) are touched at appropriate depth.
- Failure-modes section uses 8 concrete failures — the most of any chapter so far in Vol. 2 — because the misconception covers many production settings.

## Word count
~3,030 words (target: ~2,800; within +8%)

## Open issues for editor
- All historical attribution dates need verification
- Bazel and Make scheduler-internals claims should be verified against current source code
- Linux CFS implementation details should be verified
- Decision rules table has 13 rows; layout for Kindle to be checked
- Could add a brief sketch of CFS's virtual-time mechanism if length budget permits

## Cross-reference verification
Verified against `books/algorithms-by-bear-vol1/outline.md`:
- Vol. 1 Ch 13 (Linear Programming) ✓
- Vol. 1 Ch 11 (Approximation Algorithms) ✓
- Vol. 1 Ch 10 (NP-Completeness) ✓
- Vol. 1 Ch 3 (Data Structures) ✓ — for heaps and red-black trees
- Vol. 1 Ch 12 (Randomized Algorithms) ✓
- Vol. 1 Ch 5 (Graphs) ✓ — for project networks
- Vol. 1 Ch 2 (Algorithm Analysis) ✓
