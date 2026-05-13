# Bayes' Rule and Bayesian Inference

## TL;DR

Bayes' rule is a recipe for updating belief in proportion to evidence: posterior is proportional to likelihood times prior. Reach for this chapter when you have prior knowledge, new data, and need to combine them coherently — diagnostic testing, A/B-test interpretation, fraud scoring, recommender systems, anything where "given what I knew before, what should I believe now?" is the question. After consulting it, you can identify priors, likelihoods, and posteriors in a real problem; choose between exact, conjugate, and approximate inference; and recognize when MCMC or variational methods are warranted.

## Recognition pattern

Three signals.

*You have prior information.* You start with a belief about a parameter or hypothesis — a base rate, a previous experiment's posterior, an expert's elicited probability — and new data should update that belief. Frequentist methods can ignore the prior, but in practice the prior is doing work whether you acknowledge it or not. Bayes makes the work explicit.

*The quantity of interest is a probability, not a point estimate.* You want `P(disease | positive test)`, `P(this version is better | observed conversions)`, `P(model parameter > threshold | training data)`. Bayes returns full posterior distributions; non-Bayesian methods return point estimates with confidence intervals that are routinely misinterpreted.

*Decisions follow from the posterior.* The output of Bayesian reasoning is a probability that feeds a decision — treat or don't, ship the new version or don't, allocate this much budget to that channel. Bayesian decision theory pairs posteriors with utility functions to produce decisions; this is the standard machinery for decision-under-uncertainty across medicine, finance, autonomous systems, and increasingly machine learning.

A signal Bayes is *not* the right tool: you have effectively no prior information and a very large sample. Frequentist and Bayesian answers converge with sample size; with `n = 10⁶` and a flat prior, the difference is negligible. Bayes earns its place when priors carry information or sample size is small.

The misconception engaged in §9 is the practitioner block: "Bayesian methods require a strong prior." They do not. Weak, uninformative, or even improper priors are common and well-understood; the framework gives you the *option* of incorporating prior information, not a requirement to.

## What you need to know first

This chapter assumes basic probability — sample spaces, conditional probability, Bayes' rule mechanically — at the level of an undergraduate statistics course. The probability primer on the companion page covers prerequisites for any reader rusty on the basics. For randomized algorithms whose analysis uses linearity of expectation and concentration inequalities, see Vol. 1 Chapter 12. For decision-theoretic foundations that build on Bayesian posteriors, see Chapter 3 (explore/exploit) and Chapter 4 (game theory).

## The formula and what it means

Bayes' rule, in one line:

```
P(H | E) = P(E | H) · P(H) / P(E)
```

Read it backward to forward.

`P(H)` — the **prior**. Your belief about hypothesis `H` *before* seeing evidence `E`. The base rate of the disease in the population. The fraction of email that is spam. The historical conversion rate before the experiment.

`P(E | H)` — the **likelihood**. The probability of observing the evidence *given* the hypothesis is true. The sensitivity of the test (the probability the test is positive when the patient has the disease). The probability the model assigns to a particular word given a topic.

`P(E)` — the **evidence** or **marginal likelihood**. The total probability of observing the evidence, marginalized over all hypotheses: `P(E) = Σ_h P(E | h) · P(h)`. Often the hardest term to compute.

`P(H | E)` — the **posterior**. Your updated belief about `H` after seeing `E`. The output of the inference.

The formula is a tautology — it follows directly from the definition of conditional probability. The work lives in *applying* it correctly: identifying which quantity is the prior versus the likelihood, computing the marginal, and interpreting the posterior. Most Bayesian errors are bookkeeping errors at one of those four points.

## Conjugate priors — when the math works out

For some likelihood-prior pairings, the posterior has the same functional form as the prior. The math closes; you can update analytically without sampling. These are **conjugate priors**.

Three pairings cover most practitioner needs:

**Beta-Binomial.** Likelihood: binomial (counts of successes in `n` trials). Prior: Beta(α, β). Posterior: Beta(α + successes, β + failures). Used for conversion-rate estimation, A/B testing, sports analytics. Update is one line; posterior mean is `(α + successes) / (α + β + n)`.

**Normal-Normal.** Likelihood: normal with known variance. Prior: normal. Posterior: normal with mean and variance computable from the standard formulas. Used for parameter estimation when you assume Gaussian noise.

**Gamma-Poisson.** Likelihood: Poisson (rare-event counts). Prior: Gamma. Posterior: Gamma. Used for arrival-rate estimation, defect counts, click counts.

A **conjugate-prior reference card** lives on the companion page. For most production applications where the model is simple, conjugate updates are all you need. The simplicity is what makes Bayesian A/B testing, for instance, a one-line update per observation rather than a full inference pipeline.

When the likelihood is non-conjugate or the model is hierarchical, conjugate updates fail and you reach for Markov Chain Monte Carlo (MCMC) or variational inference.

## MCMC, variational inference, and approximate Bayesian computation

Three families of approximate methods, used when the posterior cannot be computed analytically.

**MCMC (Markov Chain Monte Carlo).** Construct a Markov chain whose stationary distribution is the posterior; sample from the chain; the samples approximate the posterior. Algorithms: Metropolis-Hastings (general-purpose, can be slow), Gibbs sampling (when conditional posteriors are tractable), Hamiltonian Monte Carlo / NUTS (efficient on continuous parameters, used by Stan and PyMC) [verify]. MCMC is the workhorse for posterior inference when the posterior is high-dimensional and non-conjugate. Diagnostics — trace plots, R-hat, effective sample size — are essential; MCMC can fail silently if the chain has not mixed.

**Variational inference (VI).** Approximate the posterior with a simpler distribution (often a factorized Gaussian) chosen to minimize KL divergence to the true posterior. Faster than MCMC, scales to larger datasets, used in production at scale. The cost: VI may underestimate posterior variance and miss multimodality. Mean-field VI is the standard form; structured VI relaxes the factorization assumption.

**ABC (Approximate Bayesian Computation).** Used when the likelihood is intractable but you can simulate from the model. Sample candidate parameters from the prior, simulate data, accept candidates whose simulated data is "close enough" to observed data. Used in population genetics, epidemiology, and other simulation-driven sciences.

The choice among these is driven by problem structure. Conjugate when possible; MCMC when conjugate fails and accuracy matters; VI when scale matters and approximation is acceptable; ABC when likelihoods are simulation-only.

## Bayesian decision theory

The output of Bayesian inference is a posterior distribution. The decision is what you *do* given the posterior. Bayesian decision theory pairs the posterior with a **utility function** `U(action, outcome)` and chooses the action maximizing **expected utility**:

```
action* = argmax_a Σ_outcome U(a, outcome) · P(outcome | data)
```

The expectation is over the posterior. The framework is general — it covers medical diagnosis (treat or test further), spam classification (filter or deliver), inventory ordering (under demand uncertainty), and bandit decisions (Chapter 3).

The framework's discipline: the action you pick depends on *both* the posterior and the utility function. A 5% posterior probability of a serious disease may justify treatment if the cost of treatment is low and the cost of missing the disease is high. The same 5% may not justify treatment if the cost asymmetry runs the other way. Bayesian decision theory makes the asymmetry explicit.

## Decision rules

| Situation | Approach |
| --- | --- |
| Conjugate model, small data | Analytical update (Beta-Binomial, Normal-Normal, Gamma-Poisson) |
| Non-conjugate, moderate dimension, accuracy matters | MCMC (Stan, PyMC) |
| Non-conjugate, high dimension, scale matters | Variational inference |
| Likelihood intractable, can simulate | ABC |
| Need decisions, not just inference | Pair posterior with utility function |
| Sequential decisions under uncertainty | Bandit framework (Chapter 3) — Thompson sampling is Bayesian |
| Multiple data sources, hierarchical structure | Hierarchical Bayesian model |
| Want to compare models | Bayes factor or marginal likelihood (caveat: sensitive to priors) |
| Very large sample, weak prior | Frequentist often suffices and is faster |
| Reporting to non-technical stakeholders | Posterior probability is more intuitive than confidence interval |

## Worked example — interpreting a positive medical test

A patient receives a positive result on a screening test for a low-base-rate disease. The test has 99% sensitivity (true-positive rate) and 99% specificity (true-negative rate). The disease affects 1 in 1,000 people in the screened population. What is the probability the patient actually has the disease?

This is the canonical Bayesian-reasoning problem and the one most people get wrong on first encounter. The intuition that the answer is "around 99%" is wrong by an order of magnitude.

**Set up the problem.**

- Prior: `P(D) = 0.001`. Base rate.
- Prior of no disease: `P(¬D) = 0.999`.
- Likelihood given disease: `P(+ | D) = 0.99`. Sensitivity.
- Likelihood given no disease: `P(+ | ¬D) = 0.01`. False-positive rate (1 − specificity).

**Apply Bayes.**

```
P(D | +) = P(+ | D) · P(D) / P(+)

P(+) = P(+ | D) · P(D) + P(+ | ¬D) · P(¬D)
     = 0.99 · 0.001 + 0.01 · 0.999
     = 0.00099 + 0.00999
     = 0.01098

P(D | +) = 0.99 · 0.001 / 0.01098
         ≈ 0.0902
```

**The answer is about 9%, not 99%.** A positive test result on this screening problem moves the posterior from 0.1% to ~9% — a 90× update — but the patient is still over 90% likely *not* to have the disease.

**Why.** The prior is doing the work. With base rate 0.001, the population of 1,000 people contains roughly 1 true case and 999 non-cases. The 99%-sensitive test catches that one case; the 99%-specific test produces about 10 false positives among the 999 non-cases. Among the 11 positive results, only one is a true case — about 9%.

**The practitioner takeaway.** Sensitivity and specificity are properties of the *test*. The posterior probability of disease given a positive result also depends on the **base rate** in the screened population. Screening for a rare disease in an unselected population produces mostly false positives, even with a highly accurate test. The same test applied in a high-prevalence population (symptomatic patients, exposed contacts, high-risk groups) produces a very different posterior.

**Practical applications.**

*Pre-test probability matters.* Clinicians who order a test should have a pre-test probability in mind; the test result updates that probability via Bayes. A positive result with a pre-test probability of 30% gives a posterior of about 98%; a positive result with a pre-test probability of 0.1% gives the 9% above. Same test, different action.

*Confirmatory testing.* When a screening test is positive, follow-up with a more specific (or independent) test. Two independent positive tests with combined sensitivity 0.99 × 0.99 = 0.98 and combined false-positive rate 0.01 × 0.01 = 0.0001 give a posterior in the 90%+ range even at low base rates.

*Threshold setting.* A decision rule "treat if posterior > threshold" depends on the cost asymmetry between treatment and missed diagnosis. Bayesian decision theory makes the threshold explicit; "treat if test is positive" hides the threshold inside the test's operating point.

The lesson: Bayes' rule is one line of arithmetic, but the line gets the right answer only if you correctly identify the prior, the likelihood, and the marginal. The misconception that a 99%-accurate test gives a 99% posterior conflates `P(+ | D)` with `P(D | +)` — the inverse fallacy, the foundational Bayesian error.

## Failure modes — when "Bayesian methods require a strong prior" misleads

The misconception engaged: "Bayesian methods require a strong prior."

The framing has two readings: that Bayesian methods *demand* prior information, and that the prior *dominates* the posterior. Both are wrong on careful examination, with caveats.

**Bayesian methods do not require informative priors.** Uninformative priors are widely used and well-studied. A uniform prior on a probability parameter (Beta(1, 1)) reflects ignorance about the parameter's value while still being a valid prior. Jeffreys priors are constructed to be invariant under reparameterization. Improper priors (those that don't integrate to 1) are sometimes used and can yield proper posteriors as long as the data is informative. The framework is permissive about priors.

**The prior's influence diminishes with data.** As `n → ∞`, the posterior is dominated by the likelihood; the prior's effect decays. The Bernstein-von Mises theorem [verify] formalizes this: under regularity conditions, the posterior converges to a normal distribution centered on the maximum likelihood estimate. With `n = 10⁶` independent observations, the prior is essentially irrelevant.

**Where the misconception is partially right.** With small samples, the prior matters and the choice of prior should be defensible. Reporting Bayesian results without disclosing the prior is bad practice. Sensitivity analysis — running the inference with several reasonable priors — is the corrective; if the conclusion changes with the prior, the data is not strong enough to support a confident conclusion regardless of methodology.

**Where the misconception is dangerous.** A practitioner who avoids Bayes for fear of "needing a strong prior" defaults to frequentist methods that have implicit priors (the maximum likelihood estimator's point assumption, the choice of significance threshold) without acknowledging them. Bayes makes the assumptions visible; refusing Bayes does not eliminate the assumptions, only hides them.

**Other Bayesian failure modes worth naming.**

*Misidentifying the prior, likelihood, or marginal.* Most Bayesian errors are at the formula-application step, especially the inverse fallacy (`P(+ | D)` confused with `P(D | +)`).

*MCMC convergence issues.* MCMC can produce wrong answers if the chain has not mixed. Diagnostics (trace plots, R-hat, effective sample size) catch most cases; running multiple chains and comparing is good practice. Production Bayesian inference without diagnostics is a quiet failure mode.

*Improper priors leading to improper posteriors.* Improper priors require care; certain combinations produce posteriors that don't integrate, making the inference meaningless. Verify propriety before deploying.

*Hierarchical models with non-identifiable parameters.* Two parameters that always appear in the data only as a sum cannot be separately identified; the prior is what determines the posterior split. This is a feature in some applications (the prior carries the structural information) and a bug in others (the conclusion is more about the prior than the data).

The corrective heuristic: state the prior, the likelihood, and how the posterior is being computed. Use diagnostics. Run sensitivity analysis when the prior has any chance of mattering. The framework is rigorous; the failures are bookkeeping and discipline.

## Cross-references

For randomized algorithms, the role of randomness in computation, and probability theory underlying both Bayesian and randomized methods, see Vol. 1 Chapter 12. For Thompson sampling — Bayesian explore/exploit in bandits — see Chapter 3. For Bayesian games (game theory with prior beliefs about types), see Chapter 4. For optimal stopping with Bayesian updating, see Chapter 2.

## Companion-page handoffs

Conjugate prior reference card; PyMC and Stan worked examples (Beta-Binomial, hierarchical models, Bayesian linear regression); MCMC diagnostics primer (trace plots, R-hat, ESS); ABC tutorial; variational inference walkthrough; Bayesian A/B testing implementation; Bayesian network structure-learning examples. Available at bearbrown.co/algorithms-by-bear-vol2/chapter-1.

## What this chapter does not enable

This chapter does not give a treatment of probabilistic programming or Bayesian deep learning. Probabilistic programming languages (PyMC, Stan, Pyro, NumPyro, Edward) deserve dedicated treatment beyond reference scope; for that, consult the languages' documentation and tutorials. Bayesian deep learning — variational autoencoders, Bayesian neural networks, normalizing flows for posterior approximation — lives in the *Algorithms by Bear* magazine. Bayesian nonparametrics (Dirichlet processes, Gaussian processes for nonparametric regression) is touched but not developed; Rasmussen and Williams's *Gaussian Processes for Machine Learning* is the canonical reference.

## Capability statement

You can now identify priors, likelihoods, and posteriors in a real Bayesian problem; apply Bayes' rule analytically when conjugate priors fit; choose between MCMC, variational inference, and ABC when conjugate updates fail; pair posteriors with utility functions for decision-making; and avoid the inverse fallacy that sinks most first-pass Bayesian reasoning. The next time a problem arrives that combines prior knowledge with new evidence — diagnostic, A/B, fraud-scoring, recommender — the path from data to posterior to decision is in your hands.


---

## LLM Exercise — Chapter 1: Open the Decision Diary

**Project:** *Decision Diary* — a personal markdown journal of real decisions analyzed under each chapter's method, built one entry at a time over the 8 chapters of *Algorithms by Bear, Vol. 2*. By the end, you have your own decisions worked through under the canon, with outcomes attached six months later.

**What you're building this chapter:** The diary itself — a Claude Project that will accumulate your entries — plus the first entry, where you analyze a real decision you're facing under Bayes' rule.

**Tool:** Claude Project (the best fit for this project — persistent context across all eight entries, with your domain and decision-making style in the system prompt).

**One-time setup before the prompt:**

1. Create a new Claude Project named *Decision Diary*.
2. Set the project's system prompt to something like:
   *"You are my structured-thinking partner for a decision diary. I am [your role] in [your domain]. The decisions I make routinely involve [briefly: pricing, hiring, prioritization, model choice, capital allocation, whatever applies]. My decision-making style tends toward [overthinking / undershooting on prior data / consensus-seeking / decisive / quantitative-first / intuition-first — be honest]. For each entry, help me work through one real decision using a specific method from* Algorithms by Bear, Vol. 2*. Do not flatten my judgment. Do not pretend my prior beliefs are weaker than they are. Push back when my framing of the decision is hiding the real question."*
3. Create the first entry file inside the project: `2026-XX-XX-ch01-bayes.md`.

**The prompt** (send this in the project after setup):

```
Chapter 1 entry — Bayes' Rule.

The decision I'm thinking through: [one or two sentences naming the
actual decision you face, including the timeframe — "by Friday I have
to decide whether to ship feature X" or "I'm trying to decide whether
to take the job at Y by month's end" or "should I trust this customer-
churn signal enough to escalate to the CEO this week."]

Help me work through this as a Bayesian inference problem. The chapter's
core moves:

1. **State the prior.** What did I believe about this decision *before*
   the most recent evidence arrived? Be specific about probability — not
   "I'm leaning toward yes," but "I'd have said maybe 60/40 in favor."
   Argue with me if my stated prior feels like post-hoc rationalization
   of where I already wanted to land.

2. **Name the likelihood.** What's the evidence I now have, and what's
   P(evidence | hypothesis) versus P(evidence | NOT hypothesis)? If I
   can't articulate both sides of that ratio, the evidence is doing
   less than I think it is.

3. **Compute or estimate the posterior.** Bayes' rule. Don't let me
   skip this step into vibes. If the math is hard, walk me through a
   tree diagram or a rough numerical computation.

4. **Calibrate against the base rate.** What's the prior probability
   of this kind of decision turning out well across the population of
   similar decisions I (or people like me) have faced? Force me to
   notice if I'm anchoring on a tiny n.

5. **Surface the misconception I'm at risk of.** The chapter's named
   misconception is "Bayesian methods require a strong prior." Am I
   refusing to commit to a prior because I think I "don't have one"?
   I always have one. Help me name it.

Output: a structured diary entry I'll save to the project. Use these
section headings: *The decision*, *Prior*, *Likelihood*, *Posterior*,
*Base-rate check*, *What I'll do next*, *What would change my mind*,
*Outcome (to fill in later)*.

Keep the tone direct. This is a journal, not a memo.
```

**What this produces:** Your first diary entry — a 500–1,500 word markdown file analyzing one real decision under Bayes' rule, with explicit prior, likelihood, posterior, and the "What would change my mind" commitment that lets you check yourself when the outcome arrives.

**How to adapt this prompt:**

- *For your own project:* The prompt is already personalized via the system prompt. Just substitute the actual decision into the bracketed slot.
- *For ChatGPT / Gemini:* Both work. Use a Custom GPT (ChatGPT) or a Gem (Gemini) instead of a Claude Project — same idea. Note that Gemini's tighter Google Drive integration may let you write entries directly to a Drive folder.
- *For Claude Code:* Not the right fit unless you want the diary saved as code-managed markdown files with git history (a legitimate option if you like version-controlled introspection — set up a repo, let Claude Code commit each entry).
- *For Claude chat (no project):* Works but you lose continuity. Each entry stands alone. Recommend the project version.

**Connection to previous chapters:** None — this is the seed.

**Preview of next chapter:** Chapter 2 (Optimal Stopping) asks you to analyze a "when do I commit?" decision — a job offer, a candidate, an apartment, an investment — under the threshold rule. The Bayesian habits from this entry carry forward; the new question is *not* what you believe, but when you should stop deliberating.
