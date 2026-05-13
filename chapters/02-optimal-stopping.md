# Optimal Stopping

## TL;DR

An optimal-stopping problem is a sequential decision: observations arrive one at a time, you must decide each one to *accept* (and stop) or *reject* (and move on, often without recall), and the goal is to maximize the chance of picking the best — or the expected value, depending on the variant. Reach for this chapter when a problem has the shape "evaluate now, decide now, with no return." After consulting it, you can recognize the canonical stopping-problem variants, apply the threshold rule for the secretary class, and distinguish full-information from partial-information cases.

## Recognition pattern

Three signals.

*Sequential observation, irrevocable decision.* Candidates, offers, opportunities, or signals arrive one at a time. Each must be accepted or rejected before the next arrives. Once rejected, no return. Once accepted, no further look. Hiring, house-hunting, parking-spot selection, IPO pricing, when-to-sell decisions — all share this shape.

*The information state is the rank or quality observed so far.* You don't know the future distribution of candidates exactly; you observe relative or absolute quality of those seen. The optimal strategy is a *threshold rule*: observe long enough to learn about the distribution, then accept the next observation that exceeds the threshold.

*The objective is well-defined.* Pick the best (probability of selecting the maximum). Pick the highest-value (expected payoff). Minimize regret. Stop within a deadline. Each objective produces a different stopping rule, sometimes dramatically different.

A signal optimal stopping is *not* the right tool: candidates can be revisited (recall is allowed). The problem is multi-step and previous accepted choices can be revised. The reward for choosing depends on future actions in a way that creates feedback loops (that's a Markov decision process or full reinforcement learning, not classical stopping).

The misconception engaged in §8 — "the 37% rule means stop at 37% of candidates" — gets the mechanic exactly wrong. The 37% rule is *observe* the first 37%, then *accept* the first one better than all observed. The "stop at 37%" reading misses both halves of the algorithm.

## What you need to know first

This chapter assumes basic probability (companion-page primer) and Bayesian reasoning at the level of Chapter 1. The classical stopping problems use frequentist analysis but the variants with partial information get Bayesian quickly. For the dynamic-programming framing of stopping (Bellman equations on the value function), see Vol. 1 Chapter 8. For sequential decisions with feedback (the bandit framework), see Chapter 3.

## The classic secretary problem

The canonical optimal-stopping problem.

**Setup.** `n` candidates apply for a position, arriving in random order. After interviewing each, you must accept or reject immediately. You observe only relative ranks (this candidate is better than the third one but worse than the first). Goal: maximize the probability of hiring the *best* candidate.

**Optimal strategy.** Observe the first `n/e ≈ 0.368n` candidates without hiring. Then hire the next candidate who is better than all previously observed. Equivalently: the threshold is the best of the first 37% of candidates; accept the first subsequent candidate exceeding it.

**Probability of selecting the best.** This strategy succeeds with probability approaching `1/e ≈ 0.368` as `n → ∞`. About 37%.

**Why `n/e`.** Two probabilities trade off as `m` (the observation phase length) varies. Make `m` too small: you haven't seen enough to set a good threshold; you'll accept too early. Make `m` too large: the best candidate is likely already observed during the rejection phase, leaving you to settle for second-best in the acceptance phase. The product of these two probabilities — that the best candidate is in the acceptance phase, *and* that you correctly identify them given your observation — is maximized at `m = n/e`.

The 1/e probability is the same on both axes — the chance the best candidate is in the optimal acceptance window, and the chance the algorithm picks them given they're there, both work out to about 37%. That coincidence is what gives the rule its memorability and its repeated mis-statement.

## Variants — full-information, value-maximization, and partial-information

The classic secretary problem is one specific objective on one specific information setting. Real applications usually deviate.

**Full-information secretary.** You observe absolute values rather than ranks. The classic strategy doesn't apply; instead, the optimal strategy is a sequence of decreasing thresholds. With known distribution, you accept the first candidate exceeding the threshold for the current step.

**Value-maximization (rather than best-or-nothing).** The objective is *expected payoff*, not the probability of picking the best. Strategy changes: accept candidates whose value exceeds the expected best-of-remaining. The threshold drops as fewer candidates remain.

**House-buying / Cardinal value with known distribution.** You observe an iid draw from a known distribution at each step. Each rejection costs you a search fee. Optimal strategy: accept the first house exceeding a threshold determined by the search cost, the discount factor, and the value distribution. The threshold is *constant* across steps in the infinite-horizon version with no deadline.

**Multiple offers, no recall.** Like classic secretary but accept the `k`-th-best, not the best.

**Partial information / Bayesian updating.** The distribution is unknown; observation updates the distribution estimate as well as the running maximum. The strategy becomes a Bellman equation on `(t, max_so_far, posterior)` — a small dynamic-programming problem that runs in real time as observations arrive.

**Optimal stopping in finance — American options.** Options that can be exercised at any time before expiration. The optimal exercise strategy is an optimal stopping rule on the option's intrinsic value relative to its expected continuation value. Computed by backward induction in the binomial tree model or via Monte Carlo with regression for higher-dimensional state spaces (Longstaff-Schwartz 2001) [verify].

**Optimal stopping with deadlines.** A deadline truncates the problem. The strategy is a sequence of thresholds, decreasing to the lowest acceptable value as the deadline approaches.

The taxonomy matters because the production problem is rarely the canonical 37%-rule case. Recognizing the variant is half the work.

## The dynamic-programming framing

Optimal stopping reduces to dynamic programming on the value function.

Define `V(t, state)` = the expected value of optimal play starting at time `t` with the current state. The Bellman equation:

```
V(t, state) = max(
    accept(state),                                  # stop now
    E_next_state[V(t+1, next_state) | state]        # continue
)
```

Solve backward from the deadline. At the deadline, `V(T, state) = accept(state)` for all states. Roll backward: at each step, compare the value of accepting now to the expected value of continuing, take the max, and store the optimal action.

For the classic secretary, the state is the rank of the current candidate (best so far or not). For the house-buying problem, the state is the highest offer observed. For American options, the state is the underlying asset price.

DP makes the strategy explicit and lets you compute it for any well-specified variant. The framework is general; the specific stopping rules in §3–§5 are special cases that admit closed-form thresholds.

## Decision rules

| Problem signature | Stopping rule |
| --- | --- |
| Pick the best, observe ranks only, no recall | Classic secretary: observe `n/e`, then accept first improvement |
| Pick the best, observe absolute values, known distribution | Sequence of decreasing thresholds |
| Maximize expected value, observe values | Threshold = expected best-of-remaining |
| Search with cost per look, known value distribution | Constant threshold from search cost |
| Pick the `k`-th-best | Generalized secretary with adjusted threshold |
| Distribution unknown, partial info | Bayesian DP on (time, max, posterior) |
| American option pricing | Backward induction in binomial tree or Longstaff-Schwartz |
| Hard deadline | Decreasing threshold sequence |
| Finite, small `n` | Compute exact DP rather than asymptotic threshold |
| Real-world hiring with recall and partial info | Heuristic; classical theory is a backstop, not a recipe |

## Worked example — hiring at a startup

A startup is hiring its first engineering manager. The CEO interviews candidates in serial; offers must be made promptly because strong candidates have competing offers. The pool is roughly 50 candidates over three months, sourced from referrals and recruiting outreach.

The CEO's instinct: "I've heard about the 37% rule. So I should interview 18 candidates without hiring, then hire the next one who beats all of them."

This is the classic secretary problem applied directly. It has flaws as a model. Examining them is the chapter's pedagogical move.

**What the model assumes.**

- Random order of arrival. Mostly true for cold outreach; less true if the strongest referrals come early in the cycle.
- Decisions must be irrevocable. Mostly true — strong candidates accept other offers within 1–2 weeks.
- Only relative ranks observable. False — a real interview yields a multi-dimensional signal (technical skill, communication, leadership, culture fit) where absolute scores are at least partially comparable.
- Best-or-nothing payoff. False — hiring the second-best candidate is much better than not hiring at all.

**What the model gets right.**

- Observation phase is essential. Hiring the first candidate without comparison is almost always bad. The observation phase calibrates the manager to the market.
- Acceptance threshold should rise during observation, then plateau. By the end of the observation phase, the threshold is the best candidate seen so far.
- Late candidates face a higher bar than early candidates. Acceptable.

**The practitioner heuristic.**

A reasonable real-world adaptation: observe ~15 candidates over the first month (slightly less than `n/e ≈ 18` because the model's deadline assumption is shaky and the cost of waiting too long is high). After the observation phase, accept any candidate ranking in the top 15% of the observed pool, weighted by absolute strengths. Maintain a backup threshold: if no candidate exceeds the bar by the deadline, hire the strongest candidate seen, even if they don't clear the original threshold — value-maximization, not best-or-nothing.

**Where the canonical theory fails.**

*Recall is partial.* Some past candidates can be revisited if they haven't accepted competing offers. The CEO can occasionally circle back. This breaks the no-recall assumption.

*Partial information about quality.* The CEO observes interview signals, not true quality. Top candidates can interview poorly; weak candidates can perform well in interviews. The variance between observed signal and true quality is non-trivial.

*The pool is not iid.* Recruiter-sourced candidates differ systematically from referrals; senior candidates differ from junior. The model's iid assumption is a simplification.

*The pool size is uncertain.* The CEO doesn't know exactly `n`; it depends on outreach success and retention of candidates in the pipeline. Optimal stopping with unknown horizon is a different problem than the classic version.

The lesson: the 37% rule is a *guide*, not a *recipe*. The CEO who applies it literally hires worse than one who applies the underlying logic — observation phase, rising threshold, willingness to settle for value rather than best — adapted to the actual problem structure. Classical optimal-stopping theory is the foundation; production decisions live one or two structural assumptions away.

## Failure modes — when "the 37% rule means stop at 37%" misleads

The misconception engaged: "The 37% rule means stop at 37% of candidates."

The 37% rule does not say stop at 37%. It says observe the first 37%, *then* keep going and accept the first improvement. The conflation of observation with stopping is the canonical misreading and produces strategies that miss the entire point.

**Other failure modes worth naming.**

*Applying classical theory to non-classical problems.* The 37% rule is for the strict best-or-nothing objective with no recall and full random order. Most real problems violate one or more of these. Real-options problems, value-maximization, and Bayesian variants have *different* thresholds and rules.

*Forgetting the assumption of random order.* If the order is informative — strongest candidates likely arrive first because they're proactive, or last because the recruiter saved them — the classical strategy is wrong. The threshold should adapt to the expected position of strong candidates.

*Treating the threshold as static.* In the value-maximization version, the threshold *decreases* as time runs out. A strategy that holds the same threshold throughout misses good-but-not-best candidates as the deadline approaches.

*Misidentifying the "no recall" constraint.* If recall is possible (offers can be reopened, deals can be revisited), the optimal strategy involves substantial backtracking and the no-recall analysis underestimates the achievable expected payoff.

*Partial information masquerading as full information.* The 37% rule assumes you know the relative rank of each candidate without uncertainty. Real interviews are noisy. With noisy observations, the optimal threshold is higher (you need to be more confident about a candidate's true position before accepting) and the achievable success probability is lower.

*Optimizing for a metric the practitioner doesn't actually care about.* The 37% rule maximizes the probability of picking the best. Most hiring managers want expected value, not best-or-nothing. The objectives are different; the strategies are different.

The corrective heuristic: before applying any stopping rule, state the objective (best, expected value, deadline-constrained), the information available (ranks, values, distribution), the recall structure (none, partial, full), and the order (random, biased, learnable). The classical theory has a rule for each combination; "the 37% rule" is the answer to one specific combination, not all of them.

## Cross-references

For Bayesian updating used in partial-information stopping, see Chapter 1. For sequential decisions with feedback (the bandit framework, where stopping doesn't end the problem), see Chapter 3. For dynamic programming as the general framework underlying optimal-stopping solutions, see Vol. 1 Chapter 8. For the role of randomness in the random-order assumption, see Vol. 1 Chapter 12. For Bellman equations and value-function recursion, see Vol. 1 Chapter 8 and Chapter 5 of this volume.

## Companion-page handoffs

Variants of the secretary problem with code; real-world stopping-time examples (parking, house-buying, quitting-while-ahead); American options pricing implementation (binomial tree and Longstaff-Schwartz Monte Carlo); Bayesian secretary-problem walkthrough; threshold-rule visualization for a range of objectives. Available at bearbrown.co/algorithms-by-bear-vol2/chapter-2.

## What this chapter does not enable

This chapter does not give a treatment of optimal control beyond the classical optimal-stopping case. Continuous-time stochastic control, Hamilton-Jacobi-Bellman equations, and partial-differential-equation methods for optimal control deserve dedicated coverage; Bertsekas's *Dynamic Programming and Optimal Control* is the canonical reference. The chapter also does not cover the full apparatus of stochastic processes (martingale theory, stopping times in the strict measure-theoretic sense, Wald's identity); for that, consult a graduate-level probability text.

## Capability statement

You can now recognize when a problem has the optimal-stopping shape; identify which variant of the canonical theory applies (secretary class, value-maximization, partial-information, finance-options); apply the threshold rule correctly with the observation phase as the first half of the strategy; and avoid the failure modes that come from treating "the 37% rule" as if it were a recipe rather than a single point in a wide taxonomy of stopping problems. The next time a sequence of irrevocable decisions arrives — hiring, parking, house-hunting, exit timing — the path from problem to threshold rule is in your hands.


---

## LLM Exercise — Chapter 2: A Stopping Decision

**Project:** *Decision Diary*.

**What you're building this chapter:** A diary entry on one real decision in your life that has the structure "evaluate now, decide now, no return" — analyzed under the threshold rule from the chapter.

**Tool:** Claude Project (your *Decision Diary*, continuing from Chapter 1).

**The prompt** (send this in your *Decision Diary* project; it will reference your domain and style from the system prompt):

```
Chapter 2 entry — Optimal Stopping.

The decision I'm thinking through: [one or two sentences naming a
sequential decision with no recall — accepting one of N job offers
arriving over weeks, choosing one of N candidates from a hiring
funnel, picking among N apartment showings before the lease expires,
deciding when to sell a position or commit to a vendor. The hallmark:
once you say no, the option is gone; once you say yes, you stop.]

Help me work through this as an optimal-stopping problem. The chapter
warned that the most common misreading of the 37% rule is "stop at
37%." The actual rule is: **observe the first 37%, then accept the
next observation that beats everything you saw in the observation
phase**. Make sure I apply the right version.

Walk me through:

1. **Which variant of the stopping problem am I in?**
   - Full information (I know the distribution of quality)?
   - No information (only relative rankings)?
   - Partial information (some priors on what good looks like)?
   - With recall (I can revisit rejected options)?
   - With a deadline / hard cap on N?
   Be specific. Variants change the optimal threshold materially.

2. **What is N — how many options will I see, in expectation?**
   If N is uncertain, what's my honest estimate and how wide is the
   uncertainty? If I'm pretending N is fixed when it isn't, surface
   that.

3. **Where am I in the sequence now?** How many have I already seen,
   and how good was the best so far?

4. **Apply the threshold rule for my variant.** If I'm in the
   classical no-information secretary problem, observe ~N/e ≈ 37% of
   N, then accept the first one that exceeds everything in the
   observation set. If I'm in a variant, name it and apply the
   variant's rule.

5. **Pressure-test my "best so far."** Am I anchoring on a single
   strong candidate from early in the process because it felt good
   then, or because it actually beat everything else I've seen on
   the criteria that matter for the decision?

6. **Name the misconception I'm at risk of.** The chapter names
   "37% rule means stop at 37%." Am I at risk of misreading the
   rule? Or am I at risk of the deeper failure — treating a non-
   stopping problem (where recall is possible) as if it were one?

Output: a structured diary entry. Headings: *The decision*,
*Variant*, *N and where I am*, *Threshold and observed best*,
*What the rule says to do*, *Where the model breaks for me*,
*What I'll do next*, *What would change my mind*,
*Outcome (to fill in later)*.

Reference my Chapter 1 entry if any of the priors I worked out there
bear on this decision — they often do.
```

**What this produces:** A diary entry that distinguishes which stopping variant you're in, applies the correct threshold, and — most usefully — names where your decision is misshapen as a stopping problem (e.g., you have recall, or N is uncertain, or the criteria you said you'd use changed after the early observations).

**How to adapt this prompt:**

- *For your own project:* The system prompt already personalizes the project. The bracketed slot is where you pour the decision.
- *For ChatGPT / Gemini:* Both work. The threshold-rule arithmetic is the same; the conversational style is the only thing that differs.
- *For Claude Code:* Not the right fit for this entry.
- *For a Claude Project:* Native fit. The accumulated context from Chapter 1's entry is doing real work — let the project notice patterns ("you tend to undershoot N").

**Connection to previous chapters:** The Bayesian habits from Chapter 1 carry forward — your priors on "how good is good enough" inform the threshold. If Chapter 1's entry was about a decision adjacent to this one, the project will reference it.

**Preview of next chapter:** Chapter 3 (Multi-Armed Bandits) addresses the *plural* version of optimal stopping — when there are several options and you'll allocate trials across them over time, balancing learning against earning. A/B testing, ad creatives, where to invest career energy, which side projects to keep alive.
