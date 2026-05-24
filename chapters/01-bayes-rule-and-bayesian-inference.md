# Chapter 1 — Bayes' Rule and Bayesian Inference

*The one-line formula that gets the right answer only if you know which question you're actually asking.*

---

Imagine a doctor orders a test for a rare disease. The test is 99% accurate — both ways. If you have the disease, it says positive 99% of the time. If you don't have the disease, it says negative 99% of the time. The disease itself affects 1 in 1,000 people in the population being screened.

The test comes back positive.

Most people — including, in documented studies, many physicians — hear "99% accurate" and conclude the patient probably has the disease. Maybe 99% likely. Maybe a little less, accounting for some fuzziness. But high. Very high.

The correct answer is about 9%.

This is not a trick. There's no fine print. The arithmetic is straightforward, and once you see it, you can't unsee it. The patient with the positive test is almost certainly fine — more than 90% likely to be fine — and the same 99%-accurate test will return the correct interpretation every time, if you run the right calculation instead of trusting your intuition.

The calculation is Bayes' rule. One line. The question is why the answer comes out so different from what the intuition says, and what that gap is trying to tell us about probability itself.

---

## The Formula and What It Actually Says

Bayes' rule, in its most compact form:

$$P(H \mid E) = \frac{P(E \mid H) \cdot P(H)}{P(E)}$$

Four quantities. Let me name each one carefully, because half the errors in applied probability come from mixing up which is which.

$P(H)$ is the **prior**. It's your belief about hypothesis $H$ *before* you see any evidence. In the medical example, $H$ is "this patient has the disease," and the prior is 0.001 — the base rate in the population being screened. One in a thousand.

$P(E \mid H)$ is the **likelihood**. It's the probability of observing the evidence $E$ *given that* $H$ is true. Here, $E$ is a positive test result, and the likelihood is 0.99 — the test's sensitivity.

$P(E)$ is the **marginal probability of the evidence**. The total probability of a positive test, regardless of whether the patient is sick or healthy. This is the term most people skip, and it's doing the most work.

$P(H \mid E)$ is the **posterior**. Your updated belief about $H$ *after* seeing the evidence. This is what you actually want: the probability the patient has the disease given the positive test.

The formula is a tautology — it follows directly from the definition of conditional probability. There's no profound physics here, no controversial assumptions. It's arithmetic. The insight isn't in deriving the formula; it's in *applying* it correctly — understanding which term is which, and refusing to confuse the posterior with the likelihood.

That last confusion has a name: the **inverse fallacy**. Conflating $P(E \mid H)$ with $P(H \mid E)$. Confusing "the probability of a positive test given the disease" with "the probability of the disease given the positive test." The test's 99% accuracy is the first quantity. What the doctor and patient need is the second. They are not the same number, and in this case they're not even close.

![Labeled diagram of the four Bayes terms arranged](images/01-bayes-rule-and-bayesian-inference-fig-01.png)
*Figure 1.1 — Labeled diagram of the four Bayes terms arranged*

---

## Running the Arithmetic

Let's do the medical example correctly.

The prior probability of disease: $P(D) = 0.001$.  
The prior probability of no disease: $P(\neg D) = 0.999$.  
The sensitivity (true-positive rate): $P(+ \mid D) = 0.99$.  
The false-positive rate: $P(+ \mid \neg D) = 0.01$.

First, the marginal. How likely is a positive test in this population?

$$P(+) = P(+ \mid D) \cdot P(D) + P(+ \mid \neg D) \cdot P(\neg D)$$

$$P(+) = (0.99)(0.001) + (0.01)(0.999) = 0.00099 + 0.00999 = 0.01098$$

Now the posterior:

$$P(D \mid +) = \frac{P(+ \mid D) \cdot P(D)}{P(+)} = \frac{0.99 \times 0.001}{0.01098} \approx 0.090$$

About 9%.

The intuition wants to say 99%. The arithmetic says 9%. Why?

Picture the population directly. Start with 1,000 people. On average, one has the disease; 999 don't. The test is run on all of them.

The one true case almost certainly tests positive (99% sensitivity): 1 true positive.  
The 999 healthy people: the 99%-specific test still generates a false positive 1% of the time, so roughly 10 false positives.

Among all 11 positive results, only 1 is a true case. That's 1/11, which is about 9%.

![1,000-person icon grid ](images/01-bayes-rule-and-bayesian-inference-fig-02.png)
*Figure 1.2 — 1,000-person icon grid *

The base rate is doing the work. The prior — the 1-in-1,000 prevalence — is so low that even a highly accurate test is mostly detecting nothing. The denominator $P(+)$ is dominated by the false-positive term because there are so many more healthy people to generate false positives from.

This is not a bug in the test. It's not a bug in Bayes' rule. It's what happens when you apply a screening tool to a low-prevalence population and forget to account for the base rate. The identical test applied in a high-prevalence population — symptomatic patients, exposed contacts, a high-risk group where maybe 30% have the disease — gives a completely different posterior, well above 90%.

Same test. Same sensitivity. Same specificity. Different population, different prior, different answer.

---

## What the Prior Actually Represents

The word "prior" makes people nervous. It sounds like an opinion — like you're being asked to bake your prejudices into the math. This nervousness has a name in the methodology wars: it's the objection that "Bayesian methods require a strong prior."

The objection is mistaken, and it matters to say why.

A prior is not a strong opinion. It's any probability distribution you assign to the hypothesis before seeing the data. That distribution can be flat — a uniform distribution that says "I have no idea" — or it can be peaked, representing genuine prior knowledge from previous experiments or domain expertise. The framework accepts both. An uninformative prior is a valid prior. It's just a statement that the data should do all the work.

What the framework does not let you do is have *no* prior at all. Every analysis embeds assumptions about the baseline. Frequentist analyses have them too — they're just implicit, hiding in the choice of significance threshold, the assumption of equal prior probability, the selection of which hypotheses to test. Bayesian analysis forces the assumption into the open where you can examine and argue with it. That's not a weakness; it's a feature. Making assumptions visible is how you can check whether they're justified.

The prior's influence also diminishes as data accumulates. With 10 observations, a strong prior dominates. With a thousand observations, the likelihood drowns it out. With a million observations, virtually any reasonable prior leads to the same posterior. This convergence is formalized in a result called the Bernstein-von Mises theorem: under regularity conditions, as the sample grows large, the posterior distribution converges to a normal centered on the maximum likelihood estimate, regardless of the prior. The prior washes out. This is why Bayesian and frequentist methods reach the same conclusions in large-sample settings and diverge in small-sample settings — the regime where the prior actually carries information.

If you have very little data and a sensible prior, use it. If you have enormous data and a weak prior, it barely matters. The framework is not telling you to trust your guesses over evidence; it's telling you to combine whatever you know before the data arrives with whatever the data says, in exactly the proportion that each deserves.

---

## The Update as a Machine

One of the most useful things to understand about Bayes' rule is that it composes.

Today's posterior becomes tomorrow's prior. Each new piece of evidence updates your belief, and the update is the same formula applied again to the new starting point. This is sequential updating, and it's how the framework was designed to work.

Suppose after the first positive test, the doctor orders a second, independent test — different technology, same sensitivity and specificity. Yesterday's posterior (9%) becomes today's prior. A second positive result runs through Bayes' rule again.

New prior: $P(D) = 0.09$.  
Second test positive: $P(+ \mid D) = 0.99$, $P(+ \mid \neg D) = 0.01$.

$$P(+) = (0.99)(0.09) + (0.01)(0.91) = 0.0891 + 0.0091 = 0.0982$$

$$P(D \mid +, +) = \frac{0.99 \times 0.09}{0.0982} \approx 0.91$$

Two independent positive tests moves the posterior from 0.1% to ~9% to ~91%. The base rate problem is solved not by a better test but by a second data point — a second independent likelihood update. The machine is composable.

This is why confirmatory testing works. It's not a ritual. It's a consequence of the mathematics: independent evidence multiplies. A single positive result on a low-base-rate disease is weak; two independent positives are decisive.

![Horizontal bar or stepped chart showing posterior probability](images/01-bayes-rule-and-bayesian-inference-fig-03.png)
*Figure 1.3 — Horizontal bar or stepped chart showing posterior probability*

---

## From Posteriors to Decisions

Inference gives you a posterior. A posterior is a probability distribution over some hypothesis or parameter. That's useful for understanding the world. It becomes useful for acting in the world only when paired with a decision rule.

Bayesian decision theory is the machinery for that pairing. The setup: you have a set of possible actions, a set of outcomes, and a utility function $U(a, \omega)$ that scores how good action $a$ is when outcome $\omega$ occurs. The Bayesian decision is the one that maximizes expected utility:

$$a^* = \operatorname{argmax}_a \sum_\omega U(a, \omega) \cdot P(\omega \mid \text{data})$$

The expectation is over the posterior. You're averaging the utility of each action over all possible outcomes, weighted by how probable each outcome is given what you've seen.

The framework makes something explicit that intuition tends to collapse: the optimal action depends on *both* the posterior *and* the utility function. A 9% probability of a serious, treatable disease may justify treatment if the cost of treatment is low and the cost of a missed case is catastrophic. A 9% probability of a minor condition may not justify treatment if the intervention has meaningful side effects. Same posterior, different utility function, different action. The asymmetry between the cost of false positives and false negatives is not a detail — it's the whole decision.

This is where much real-world reasoning fails. People look at a posterior and reason from the number alone, forgetting that numbers don't have opinions about consequences. A probability tells you what's likely. A utility function tells you what matters. You need both.

---

## When the Posterior Can't Be Computed Analytically

The formula is clean. The computation is sometimes not.

For certain pairings of likelihood and prior — called **conjugate pairings** — the posterior has the same mathematical form as the prior, just with updated parameters. The Beta-Binomial pairing is the most useful: if you start with a Beta prior over a probability parameter and observe binomial data (counts of successes in trials), the posterior is another Beta, with parameters updated by adding the observed successes and failures. One line of arithmetic. No sampling, no approximation.

The Normal-Normal pairing works similarly for continuous observations with Gaussian noise. The Gamma-Poisson pairing covers arrival-rate estimation, defect counts, and click-through rates. These three pairings handle a large fraction of practical Bayesian inference in production systems.

| likelihood type | prior family | posterior family | update rule in one line | typical use case |
| --- | --- | --- | --- | --- |
| conjugate prior reference card | three rows (Beta-Binomial, Normal-Normal, Gamma-Poisson | A concrete checkpoint for applying the chapter concept. | A concrete checkpoint for applying the chapter concept. | A concrete checkpoint for applying the chapter concept. |

When the model is more complex — a hierarchical structure, a non-standard likelihood, multiple parameters with dependencies — conjugate updates fail. The posterior exists in principle but can't be written in closed form. This is where approximate methods enter.

**MCMC** (Markov Chain Monte Carlo) constructs a sequence of random samples whose long-run distribution is the target posterior. The most widely used variant today is Hamiltonian Monte Carlo, implemented in probabilistic programming systems like Stan and PyMC. The samples approximate the posterior; more samples, better approximation. The cost is computational — MCMC is slow for large models or large datasets — and requires diagnostics to verify the chain has actually converged to the right distribution. A chain that hasn't mixed produces confidently wrong answers.

**Variational inference** takes a different approach: approximate the posterior with a simpler distribution — often a factorized Gaussian — and tune that approximation to minimize the gap to the true posterior. Faster than MCMC, scales to large datasets, but may underestimate uncertainty and miss multimodality. It's the method of choice when you need Bayesian inference at scale and can tolerate some approximation error.

**Approximate Bayesian Computation** (ABC) is for the case where even evaluating the likelihood is intractable — the model is too complex to write down a probability of the data. Instead: sample candidate parameters from the prior, simulate data from the model with those parameters, accept the candidate if the simulated data is close enough to the real data. The result is samples from an approximate posterior. Slower than both MCMC and VI, but applicable to simulation-based models in epidemiology, population genetics, and agent-based settings where there's no other option.

The decision among methods is driven by the problem structure: conjugate when the model permits, MCMC when accuracy is paramount, variational when scale matters, ABC when the likelihood is simulation-only.

![Decision flowchart ](images/01-bayes-rule-and-bayesian-inference-fig-04.png)
*Figure 1.4 — Decision flowchart *

---

## The Failure Modes

Most Bayesian errors are bookkeeping errors. The formula is short enough to fit on a napkin; the mistakes live in the application.

**The inverse fallacy.** Confusing $P(E \mid H)$ with $P(H \mid E)$. The sensitivity of the test is not the probability of the disease. The probability of a match given innocence is not the probability of innocence given the match. This single confusion has sent people to prison and driven clinical decisions the math doesn't support. The corrective is mechanical: write out all four terms of Bayes' rule before drawing any conclusion.

**Forgetting the base rate.** The marginal $P(E)$ reflects the prior probability of seeing the evidence at all. Skip it, and the posterior is wrong. The medical example shows exactly how badly wrong: a factor of ten.

**MCMC convergence failure.** A Markov chain that hasn't mixed produces samples from the wrong distribution. The samples look like samples — numbers, distributions, credible intervals — and nothing flags the failure automatically. Diagnostics are not optional: trace plots, the R-hat statistic (values near 1.0 suggest convergence), effective sample size. Running multiple chains from different starting points and checking that they agree is the simplest check. If they don't agree, the chain hasn't converged.

**Improper priors producing improper posteriors.** Some "uninformative" priors don't integrate to 1 — they're improper. An improper prior doesn't invalidate the framework, but it requires checking that the posterior *is* proper (that it integrates to 1) before interpreting the results. Certain likelihood-prior combinations produce improper posteriors that can't be normalized, which makes the inference meaningless.

**Using Bayes where sample size makes it irrelevant.** With $n = 10^6$ and a flat prior, the Bayesian and frequentist answers are essentially identical. The full posterior-inference machinery adds complexity without adding information. Bayes earns its place when priors carry real information or sample size is small. Applying it everywhere because it's principled is a waste of compute.

---

## The Capability You Now Have

The next time you see a diagnostic test, a model performance metric, a screening result, or any conditional probability presented without its base rate — you'll know something is missing.

You can write out $P(H \mid E) = P(E \mid H) \cdot P(H) / P(E)$ and identify which quantities you have and which you need. You can recognize when the inverse fallacy is hiding in someone's conclusion. You can judge whether a conjugate update is available or whether you need the heavier machinery. You can pair a posterior with a utility function and understand why the decision is not determined by the probability alone.

That's what this chapter is actually about. Not the formula — the formula is four symbols. What's harder, and what's worth developing, is the habit of asking: *which probability, exactly, are you claiming to know?*

---

## Exercises

### Warm-Up

**1.** A spam filter flags 2% of legitimate email as spam (false-positive rate) and misses 5% of actual spam (false-negative rate). Spam makes up 30% of all incoming email. A message is flagged. What is the probability it is actually spam? *(Tests: correct identification of prior, likelihood, and marginal; direct application of Bayes' rule.)*

**2.** A factory produces widgets with a 1% defect rate. A quality-control test correctly identifies a defective widget 95% of the time, and incorrectly flags a good widget 3% of the time. A randomly selected widget tests positive for defect. What is the probability it is actually defective? *(Tests: same mechanics as the medical example in a production context; reader should notice the same base-rate structure.)*

**3.** You estimate a coin is fair with 80% confidence and biased (60% heads) with 20% confidence. You flip the coin five times and get four heads. Use Bayes' rule to update your probability that the coin is biased. *(Tests: discrete hypothesis version of Bayes; reader must correctly compute the likelihood of four heads under each hypothesis.)*

### Application

**4.** A city screens residents for a disease with prevalence 0.5%. The test has 98% sensitivity and 97% specificity. Your friend tests positive and calls you in a panic, saying "the test is 98% accurate, so I almost certainly have it." Walk through the correct calculation and explain where your friend's reasoning went wrong. Then recalculate: what prevalence would make a positive test indicate at least 50% probability of disease, holding test accuracy fixed? *(Tests: inverse fallacy identification; algebraic inversion to find the threshold prevalence.)*

**5.** You run an A/B test. Variant B gets 52 conversions out of 1,000 visits; Variant A gets 48 conversions out of 1,000 visits. Using a Beta-Binomial conjugate update with a uniform prior Beta(1,1) on each variant's conversion rate, compute the posterior mean conversion rate for each variant. Does the data support concluding B is better? What would change your confidence? *(Tests: conjugate update mechanics; posterior mean formula; interpretation of small observed differences.)*

**6.** You believe a job candidate has a 40% prior probability of succeeding in the role. You conduct a structured interview; historically, successful candidates pass this interview 70% of the time, and unsuccessful candidates pass it 30% of the time. The candidate passes. Update your posterior. Then the candidate completes a work sample; successful candidates complete it well 80% of the time, unsuccessful candidates 20% of the time. The candidate does well. Apply a second sequential update using the first posterior as the new prior. *(Tests: sequential updating; posterior-as-prior composition; practical decision-making context.)*

### Synthesis

**7.** A fraud-detection model flags a transaction as suspicious. The base rate of fraud in your payment system is 0.2%. The model has 90% sensitivity and 99% specificity. (a) What is the posterior probability that a flagged transaction is fraudulent? (b) Your operations team can investigate 100 flagged transactions per day. Given the posterior, how many of those investigations will find actual fraud? (c) A second independent signal — the card is being used in an unusual location — has a likelihood ratio of 5:1 (five times more likely given fraud than not). Use this as a second Bayesian update. What is the new posterior? *(Tests: end-to-end inference plus operational consequence plus sequential update with a likelihood ratio rather than raw probabilities.)*

**8.** You are using MCMC to fit a Bayesian model and run four chains. Three chains converge to similar posterior means; the fourth wanders. (a) What does this pattern suggest about the inference? (b) Name two diagnostics you would check and describe what a failing value looks like. (c) What would you try to fix the problem? *(Tests: MCMC failure mode recognition; practical diagnostics; no calculation required — tests conceptual understanding of convergence.)*

### Challenge

**9.** The prosecutor's fallacy occurs when $P(\text{evidence} \mid \text{innocence})$ is presented in court as if it were $P(\text{innocence} \mid \text{evidence})$. (a) Explain precisely which term in Bayes' rule the fallacy omits, and why omitting it produces a dramatically wrong answer in low-base-rate scenarios. (b) Construct a numerical example: a DNA match occurs with probability 1 in 10,000 by chance. The suspect is drawn from a database of 500,000 people with no other evidence linking them to the crime. What is the actual posterior probability of guilt? (c) What prior information, if added, would most rapidly change the posterior — a better DNA test or stronger circumstantial evidence placing the suspect at the scene? Justify your answer quantitatively. *(Tests: deep integration of base rate, likelihood ratio, and the inverse fallacy in a high-stakes application; requires constructing the full Bayesian argument from scratch.)*

---

## LLM Exercise — Chapter 1: Open the Decision Diary

**Project:** *Decision Diary* — a personal markdown journal of real decisions analyzed under each chapter's method, built one entry at a time over the 8 chapters of *Algorithms by Bear, Vol. 2*. By the end, you have your own decisions worked through under the canon, with outcomes attached six months later.

**What you're building this chapter:** The diary itself — a Claude Project that will accumulate your entries — plus the first entry, where you analyze a real decision you're facing under Bayes' rule.

**Tool:** Claude Project (the best fit for this project — persistent context across all eight entries, with your domain and decision-making style in the system prompt).

**One-time setup before the prompt:**

1. Create a new Claude Project named *Decision Diary*.
2. Set the project's system prompt to something like: *"You are my structured-thinking partner for a decision diary. I am [your role] in [your domain]. The decisions I make routinely involve [briefly: pricing, hiring, prioritization, model choice, capital allocation, whatever applies]. My decision-making style tends toward [overthinking / undershooting on prior data / consensus-seeking / decisive / quantitative-first / intuition-first — be honest]. For each entry, help me work through one real decision using a specific method from* Algorithms by Bear, Vol. 2*. Do not flatten my judgment. Do not pretend my prior beliefs are weaker than they are. Push back when my framing of the decision is hiding the real question."*
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

---

## AI Wayback Machine

The ideas in this chapter didn't appear from nowhere. **David Blackwell** built much of the modern theory of Bayesian decision-making in the 1950s — including the Rao–Blackwell theorem, which sharpens any estimator into a better one. He was the first Black scholar elected to the National Academy of Sciences.

**Run this:**

```
Who was David Blackwell, and how does his work on Bayesian decision theory and sufficient statistics connect to the Bayes-rule inference we used in this chapter? Keep it to three paragraphs. End with the single most surprising thing about his career or ideas.
```

→ Search **"David Blackwell"** on Wikipedia. See what the model got right, got wrong, or left out.

**Now make the prompt better.** Try one of these:

- Ask it to walk through one example of the Rao-Blackwell theorem in plain language — connect it to the idea of updating a prior with evidence.
- Add a constraint: "Answer as the foreword to a Bayesian statistics textbook published in 1955."

What changes? What gets better? What gets worse?
