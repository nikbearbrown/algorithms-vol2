<!--
00-introduction.md — Book-level introduction.

The Introduction does different work than the Preface:
  - Preface  = why the book exists, why you wrote it (author's voice)
  - Introduction = what the book argues and how it is organized (reader's roadmap)

This file is a stub. Sections 1–10 and 12–13 are placeholders for a later pass.
Section 11 (A note about AI) is substantive and written.

A good model for the full version: Pearl's "The Mind Over Data" introduction,
Molnar's Interpretable ML introduction. Both are argument-first and tell the
reader exactly what to expect from each chapter.
-->

# Introduction

<!-- [1] COLD OPEN
     A specific named scene with real stakes.
     No "this book will...", no throat-clearing.
     Open on a sentence that contains the whole problem.
     Like the Swedish triage case in computational-skepticism-for-ai. -->

[COLD OPEN PLACEHOLDER]

<!-- [2] THE CENTRAL CLAIM — one sentence.
     "This book is about the gap between [X] and [Y]." -->

[CENTRAL CLAIM PLACEHOLDER]

<!-- [3] THE CENTRAL ARGUMENT — a testable, contestable claim
     about what the book is doing. -->

[CENTRAL ARGUMENT PLACEHOLDER]

<!-- [4] AUDIENCE LOCATION — one sentence locating who this is for. -->

[AUDIENCE PLACEHOLDER]

---

## What This Book Is

<!-- [5] Scope. The work the book names. Vocabulary it teaches. -->

[SCOPE PLACEHOLDER]

## What This Book Is Not

<!-- [6] Explicit exclusions. Prerequisites. -->

[EXCLUSIONS PLACEHOLDER]

---

## A Central Concept That Runs Throughout

<!-- [7] A recurring idea readers should watch for across chapters.
     Like "the fluency trap" in computational-skepticism-for-ai. -->

[CENTRAL CONCEPT PLACEHOLDER]

<!-- [8] (OPTIONAL) A RUNNING NARRATIVE THREAD
     A case that recurs across chapters as a worked example.
     Like "Ash" in computational-skepticism-for-ai.
     Delete this section if not using a running thread. -->

## A Running Narrative Thread

[NARRATIVE THREAD PLACEHOLDER — delete this section if not using one]

---

## How This Book Is Organized

<!-- [9] Chapter-by-chapter map. Group into movements (clusters of 3–5)
     if applicable. One sentence per chapter is enough. -->

[CHAPTER MAP PLACEHOLDER]

## How to Read This Book

<!-- [10] Order. Prerequisites for skipping around.
     Self-contained chapters. Chapter-closing features
     (e.g., "What would change my mind", "Still puzzling", exercises). -->

[READING GUIDE PLACEHOLDER]

---

## A Note about AI

This volume covers decision-making algorithms — Bayesian inference, optimal stopping, multi-armed bandits, game theory, scheduling, stable matching, randomized algorithms, social networks. Every chapter is about choosing under uncertainty, and uncertainty is exactly the place where the model is most fluently and most confidently wrong.

The model has read every textbook on every topic in this volume. It will explain Bayes' rule, derive the secretary problem solution, and recite Gittins indices on request. The fluency is the teaching asset. What the model cannot do is the specific decision the algorithm is designed to support — because the decision depends on prior beliefs, payoff structures, and time horizons that are yours, not the model's.

Where the model genuinely helps: walking through the derivation of a result (the 1/e threshold for the secretary problem, the Lai–Robbins regret bound, the proof of stability for Gale–Shapley), producing worked numerical examples with the parameters varied so you can feel how the optimum moves, simulating a small instance so you can compare your intuition against the algorithm's recommendation, and stress-testing your problem formulation by asking which assumptions are doing the work.

Where the model does damage: producing the actual recommendation — which option to choose, which arm to pull, which match to make, which strategy to play. The recommendation depends on prior beliefs the model is happy to assume and the operator should specify, payoffs the model is happy to assume and the operator should measure, and a time horizon the model is happy to assume and the operator should know. Producing the recommendation also obscures the model's structural failure mode: confident pattern-matching to a textbook case that does not quite fit your case.

A specific failure mode worth naming in this volume: the model treats game-theoretic equilibria as predictions about what will happen, when the better reading is that equilibria are predictions about what cannot happen — they are constraints on the space of outcomes, not selections within it. The model will produce a confident answer to "what will player B do?" when the algorithm only supports "here is what player B cannot rationally do."

The rule that covers all three: the algorithms in this volume tell you what to do *given* a model of the world. The model of the world is yours. The algorithm does not know your priors, your payoffs, or your horizon, and the model that explains the algorithm does not know them either. Use the model to understand the algorithm; use the algorithm to make the decision; use your own honest specification of the world to make either of those moves trustworthy.

---

## Closing

<!-- [12] Callback to the opening scene. End with a directive. -->

[CLOSING PLACEHOLDER]

---

**Tags:** <!-- [13] 5–8 discoverability tags --> [TAGS PLACEHOLDER]
