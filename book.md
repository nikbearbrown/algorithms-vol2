# Algorithms by Bear, Vol. 2

An 8-chapter Kindle reference handbook for algorithms that help with decisions under uncertainty, competition, and constraint. Volume 2 of the *Algorithms by Bear* series. Companion to *Algorithms by Bear, Vol. 1*. Published by Bear Brown LLC, edited by Nik Bear Brown.

## Identity

**Type:** Practitioner handbook / reference. NOT a course textbook, NOT an AI/ML textbook (despite topic adjacency), NOT operations research theory.

**Distribution:** Kindle at $0.99 plus Kindle Unlimited, with promotional free-distribution windows.

**Edition cycle:** Snapshot editions every 2 years (faster refresh than Vol. 1, because applications drift faster than the underlying methods).

## Reason for existing

> *Algorithms by Bear, Vol. 2* is the practitioner-shaped, Kindle-priced, plain-language reference for algorithms that help you decide, choose, schedule, match, and reason under uncertainty — for the working data scientist or operations engineer who needs Bayesian inference, optimal stopping, game-theoretic reasoning, and scheduling methods on the same shelf, written for fast lookup rather than sequential study.

The book exists because the decision-algorithm canon is fragmented across operations research textbooks, AI textbooks, microeconomics texts, and statistics references. *Algorithms to Live By* (Christian & Griffiths) sits in the popular shelf above this slot. *Russell-Norvig* sits in the AI-textbook slot above. Production-OR books sit in the textbook slot. No current Kindle-priced reference brings the methods together for the practitioner.

## Audience

**Primary reader:** Working data scientist, ML engineer, or operations analyst. Encounters Bayesian-flavored problems, scheduling problems, A/B-testing-as-bandits problems, and game-theoretic reasoning in their work and wants a single reference covering the methods.

**Secondary readers:**
- Quantitative researchers in finance, healthcare, logistics — same lookup needs, different domains.
- Engineers building recommendation, matching, or auction systems.
- Self-learners filling in OR / decision-theory gaps without a formal course.

**Non-targets:** AI textbook adopters. OR PhD students. Game theory researchers.

## Architecture

8 chapters, one per source folder. No strict cluster grouping (the methods don't form clean clusters), but loose ordering by complexity of reasoning required:

- **Foundations of decision-making** (1–2): Bayes' rule, optimal stopping.
- **Sequential decisions under uncertainty** (3): Explore/exploit (multi-armed bandits).
- **Decisions involving other agents** (4): Game theory (includes auction and mechanism-design coverage).
- **Decisions involving allocation and timing** (5–6): Scheduling, stable matching (includes matching-market mechanism design).
- **Decisions on networks** (7–8): Randomness and networking, social networks.

Auction and mechanism-design content lives inside Chapters 4 and 6 rather than in a separate capstone chapter — the source material is organized that way and a standalone capstone would synthesize without primary source. If a future edition adds standalone mechanism-design source, the chapter slot reopens.

## Series architecture

This book is one of three vehicles in the *Algorithms by Bear* line:

1. **Algorithms by Bear, Vol. 1** — classical canon, 4–5 year refresh.
2. **Algorithms by Bear, Vol. 2** (this book) — decision-making methods, 2-year refresh.
3. **[Magazine Name]** — quarterly deep-dive serial.

The companion page indexes magazine issues by chapter, hosts the errata page, and provides extended code, benchmarks, and visualizations.

## Preface — explicit scope statement

> This book covers classical decision-making methods. Reinforcement learning — which is the dominant modern method for sequential decision-making under uncertainty — is out of scope for this reference and is covered in the *Algorithms by Bear* magazine series. Readers who want RL should treat this book as the foundations and the magazine as the modern methods.

The preface also names which chapters are most useful as standalone consultations (Bayes' rule, scheduling) versus which assume more decision-theoretic vocabulary (game theory, mechanism design).

## Implicit arguments

The book carries five implicit arguments parallel to Vol. 1's:

1. Decision rules matter as much as algorithms.
2. The right model matters more than the right solver.
3. Worked examples should be real, not pedagogical.
4. Failure modes are first-class content.
5. Classical decision theory is durable; the applications drift.
