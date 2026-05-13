# Figure brief — Chapter 01: Bayes' Rule and Bayesian Inference

## Recommended figures

### Figure 1 — Prior, likelihood, posterior visualized
**Path:** `../images/chapter-1-prior-likelihood-posterior.jpg`
**Description:** Three stacked density plots over the same parameter axis. Top: prior (broad, weakly peaked). Middle: likelihood (data-driven, sharper). Bottom: posterior (combination of the two, narrower than prior, shifted toward likelihood). Caption: "Posterior ∝ Likelihood × Prior."
**Use:** referenced in §3 (The formula).

### Figure 2 — Medical test natural-frequency tree
**Path:** `../images/chapter-1-medical-test-tree.jpg`
**Description:** Population of 100,000 people (or 1,000) split by tree branches. First split: 0.1% have disease vs 99.9% don't. Second split: test result given disease status. Final boxes show the four groups (TP, FN, FP, TN) with counts. Annotation: "Among positive results, only ~9% are true positives."
**Use:** referenced in §8 (Worked example).

### Figure 3 — Posterior dependence on prior strength
**Path:** `../images/chapter-1-posterior-vs-prior.jpg`
**Description:** Sequence of posteriors for the same likelihood with priors of varying strength. Weak/uniform prior → posterior dominated by likelihood. Strong informative prior → posterior near the prior. Same data, different posteriors.
**Use:** referenced in §9 (Failure modes — engaging the misconception).

### Figure 4 — MCMC trace and diagnostics
**Path:** `../images/chapter-1-mcmc-trace.jpg`
**Description:** Two-panel: Left, trace plot of three MCMC chains (well-mixed, R-hat ≈ 1.00, converged). Right, trace plot of poorly-mixed chains (drifting, R-hat > 1.1, not converged). Caption notes how to read the diagnostic.
**Use:** referenced in §6 (MCMC, VI, ABC).

### Figure 5 — Bayesian decision flow
**Path:** `../images/chapter-1-bayesian-decision-flow.jpg`
**Description:** Block diagram. Data → posterior (computed via Bayes) → utility function applied → expected utility per action → action choice. Caption: "Bayesian decision theory: posterior + utility = decision."
**Use:** referenced in §7 (Bayesian decision theory).

## Inline figure-call markers
None inserted in current draft.
