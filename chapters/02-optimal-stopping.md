# Chapter 2 — Optimal Stopping

*You will make this kind of decision again today, and probably get it wrong for the same reason everyone does.*

---

There is a problem so simple to state that you can explain it to a child, and so subtle in its solution that mathematicians spent decades arguing about it. Here it is.

You are hiring. Candidates come in one at a time. After you interview each one, you have to decide: offer them the job, or let them go. If you let them go, they accept another offer and you never see them again. If you offer the job, you stop — whoever comes next, you won't meet them. You want to hire the best candidate in the pool. How do you decide?

That's it. That's the whole problem.

When I first encountered this, my instinct was: wait, this can't be that hard. You interview everyone, you pick the best. But that's not the problem. The problem is that you cannot interview everyone and then pick. You must decide *as you go*. The moment you say no to someone, they are gone. The moment you say yes, you stop looking. You are making an irreversible bet, one candidate at a time, against a future you cannot see.

This shape — sequential, irrevocable, uncertain — shows up everywhere. You're driving and need to park; every spot you pass is gone. You're selling a house and offers come in over weeks; the buyer won't wait while you shop around. You're an investor deciding when to exit a position; the price you saw yesterday is gone. The mathematics of these problems is the same mathematics of the hiring problem. And the answer, when you work it out, is one of the most elegant things I know.

![Horizontal timeline showing four real-world stopping problems side](images/02-optimal-stopping-fig-01.png)
*Figure 2.1 — Horizontal timeline showing four real-world stopping problems side*

---

## The thing that makes it hard

Let me be precise about what makes this hard, because it's easy to confuse the difficulty.

It is not hard because you lack information about the candidates. Suppose I told you right now that there are fifty candidates, and they're ordered randomly, and you have a perfectly reliable sense of which is better than which after each interview. The problem is still hard. Not because of uncertainty about quality — that's fully observable — but because of uncertainty about *position*. You don't know whether the person you just interviewed is the third-best out of fifty or the best of fifty. You haven't seen the others yet.

This is the information structure of optimal stopping. At any moment, you know everything about what you've seen. You know nothing about what's coming. The question is: given what you've seen so far, should you accept the current offer, or should you wait?

There are two ways to get this wrong.

You can be too hasty. You accept a candidate early in the process who looks strong, without knowing that the best candidates were still coming. You married the third person you dated, and somewhere out there was someone much better suited to you — you just never met them because you stopped looking.

You can be too patient. You hold out for something better, keep rejecting candidates who were perfectly good, and eventually you're sitting at the end of the pool having turned down everyone, forced to hire whatever's left — or worse, no one.

The optimal strategy threads between these. You use some candidates to learn about the distribution — to calibrate your sense of how good "good" is in this pool, this market, this moment. Then you use that calibration to set a threshold. The first candidate who clears the threshold gets the job.

![Two-zone number line from candidate 1 to n](images/02-optimal-stopping-fig-02.png)
*Figure 2.2 — Two-zone number line from candidate 1 to n*

---

## Working it out

Here is where I want to show you the mathematics, because the answer falls out in a way that feels almost magical once you see it.

Let's say there are $n$ candidates. You decide in advance to let the first $m$ candidates go without hiring, no matter how good they are. These are your *observation candidates*. After $m$, you hire the next candidate who is better than everyone you saw in the observation phase. That's the entire strategy.

Now: what should $m$ be?

Two things have to happen for you to get the best candidate. First, the best candidate has to be *after* position $m$ — otherwise you rejected them and you can't go back. Second, when the best candidate arrives, the current best-of-observed has to be in the first $m$ positions — otherwise some non-best candidate in positions $m+1$ through (best - 1) would have triggered your threshold already, and you'd have hired the wrong person.

Let's compute.

Call the best candidate's position $k$. The probability that $k > m$ (best candidate is in the acceptance window) is $(n - m)/n$. But that's not enough. Given that the best candidate is at position $k$, you'll correctly identify and hire them only if the best candidate among positions 1 through $k-1$ is actually in the first $m$ positions — because that's the only way your threshold doesn't get prematurely tripped. The probability of that is $m/(k-1)$.

So the probability of success — summing over all positions $k$ from $m+1$ to $n$ — is:

$$P(\text{success}) = \sum_{k=m+1}^{n} \frac{1}{n} \cdot \frac{m}{k-1}$$

The $1/n$ comes from the random order: each candidate is equally likely to be at each position. The $m/(k-1)$ is the conditional probability just derived.

This simplifies to:

$$P(\text{success}) = \frac{m}{n} \sum_{k=m+1}^{n} \frac{1}{k-1} = \frac{m}{n} \sum_{j=m}^{n-1} \frac{1}{j}$$

As $n$ gets large, that sum approximates $\ln(n/m)$, which gives us:

$$P(\text{success}) \approx \frac{m}{n} \ln\!\left(\frac{n}{m}\right)$$

To find the optimal $m$, take the derivative with respect to $m/n$ (call it $x$) and set it to zero:

$$\frac{d}{dx}\left[x \ln(1/x)\right] = \ln(1/x) - 1 = 0$$

$$\ln(1/x) = 1 \implies x = 1/e$$

So the optimal observation fraction is $1/e \approx 0.368$. Observe the first 37% of candidates. Then accept the first one who beats all of them.

And what probability of success does this give you? Plugging back in:

$$P(\text{success}) = \frac{1}{e} \cdot \ln(e) = \frac{1}{e} \approx 0.368$$

The same number. You succeed about 37% of the time.

![Smooth curve of P(success) vs](images/02-optimal-stopping-fig-03.png)
*Figure 2.3 — Smooth curve of P(success) vs*

---

## What that 37% actually means

Pause here, because this is where people go wrong.

The 37% is *not* where you stop. You stop whenever you find someone better than the observation phase's best — which might be at candidate 38%, or 70%, or right at the end. The 37% is where you *start accepting*. Before that point, you interview and reject, no matter how good. After that point, you accept the first person who clears the bar.

I've heard the 37% rule described as "interview 37 candidates, then stop." That's exactly wrong. You interview all of them. What changes at 37% is your decision criterion. Before: always reject. After: accept if better than anyone you've seen.

The other thing the number means: you will fail 63% of the time. This is not a strategy that wins often. It is a strategy that wins *as often as possible given the constraints*. No strategy can do better. If you tried to beat 37%, you'd have to either interview without committing (which violates the rules) or commit without observing (which is just guessing). The 37% threshold rule is the best you can do in this situation, and the best you can do is still modest.

This is an honest accounting of the problem. The structure of the problem — sequential, irrevocable — extracts a cost. The cost is irreducible. The optimal strategy minimizes it, but does not eliminate it.

---

## The variants, and why they matter

The problem I just solved has a very specific structure. Real stopping problems usually deviate. Knowing the variants keeps you from applying the wrong rule.

**You observe values, not just ranks.** The classical setup assumes you can only tell that candidate A is better than candidate B, not by how much. If you can observe absolute scores — if you know that this candidate is a 91 out of 100 and the previous best was an 85 — the strategy changes. You don't need a pure observation phase. You use a threshold that decreases over time: early candidates need to be truly exceptional; later candidates can clear a lower bar because fewer options remain. The architecture is the same (threshold rule), but the threshold shifts.

**You want the best expected value, not just the best.** The classical problem is all-or-nothing: you win if you hire the best, lose otherwise. But in most real decisions, the second-best outcome has real value. If you're choosing among apartment offers, an apartment in the 90th percentile of quality is nearly as good as the 95th. When the objective is expected value rather than probability-of-best, the optimal threshold is lower — you accept good candidates rather than holding out for the best. The observation-then-accept architecture survives; the threshold drops.

**You don't know how many candidates there are.** In the classical problem, $n$ is known. If $n$ is uncertain — you're hiring and you don't know how many candidates will come — the analysis changes. The optimal strategy becomes adaptive, using arrival rate and elapsed time to estimate remaining candidates. The 37% rule is an approximation that gets worse as uncertainty about $n$ increases.

**Recall is possible.** If you can go back and re-offer a rejected candidate — they haven't accepted a competing offer yet — the no-recall assumption breaks down. With full recall, the problem collapses: interview everyone, pick the best. The interesting case is *partial* recall: some candidates can be revisited, some can't. This requires tracking which past candidates remain available, which turns the problem into a small dynamic program over the reachable past.

**American options.** The same mathematics governs when to exercise a financial option. You hold the right to buy an asset at a fixed price $K$. The asset's current price evolves randomly. Should you exercise now or wait? The optimal exercise boundary is a threshold — a critical price above which you exercise immediately. Below it, you wait. Computed by backward induction in a binomial tree, or by simulation for high-dimensional cases (Longstaff-Schwartz 2001 [verify]). The parallels to the secretary problem are exact: sequential decision, irrevocable exercise, uncertainty about the future.

The taxonomy matters because the wrong rule gives wrong answers. The classical 37% rule, applied to a problem where the objective is expected value and recall is partial, will make you too patient — you'll hold out for the best when a near-best candidate was right there, and they'll be gone.

---

## A decision table

| What you know | What you want | Recall? | Rule |
|---|---|---|---|
| Only relative ranks | Probability of best | None | Observe $n/e$, accept first improvement |
| Absolute values, known distribution | Probability of best | None | Decreasing threshold sequence |
| Absolute values, known distribution | Expected value | None | Accept first candidate above continuation value |
| Values, search costs known | Expected value | None | Constant threshold (search-cost-adjusted) |
| Ranks, $n$ unknown | Probability of best | None | Adaptive threshold using arrival rate |
| Absolute values, partial information | Expected value | None | Bayesian DP: update prior, recompute threshold |
| Asset price, known dynamics | Expected option value | N/A | Backward induction or Monte Carlo |
| Hard deadline | Any | None | Decreasing threshold; accept anyone at the wire |
| Small, finite $n$ | Any | None | Compute exact DP; asymptotic approximation is rough |

| Item | Meaning |
| --- | --- |
| rendered with a "when to use" column added | each row gets a one-line real-world trigger ("you're buying a house with a budget and known local comp prices" → decreasing threshold |
| "you're hiring and candidates can rescind" → partial recall DP | A concrete checkpoint for applying the chapter concept. |
| helps readers pattern-match their actual situation to the right row | A concrete checkpoint for applying the chapter concept. |

---

## The startup CEO

Let me work through a concrete example, because abstraction only gets you so far.

A startup is hiring its first engineering manager. The CEO plans to interview roughly fifty candidates over three months. Offers expire quickly — strong candidates have competing offers and won't wait a week for an answer. The CEO has heard about the 37% rule and decides to apply it directly: "I'll interview the first eighteen candidates without hiring, then hire the next one who's better than all of them."

This is not wrong, exactly. But it is applied to a problem whose structure differs from the classical setup in several ways, and the CEO should know where the model strains.

*The order is not random.* The strongest referrals tend to come early, because the CEO's best contacts reach out first. The classical 37% rule assumes random order — any candidate is equally likely to be at any position. If strong candidates cluster early, the optimal observation window is shorter. You've seen more of the good candidates by the time you've interviewed 20% of the pool than the random-order model would predict.

*The objective is not best-or-nothing.* Hiring the second-best engineering manager is much better than extending the search for another three months while the company operates without one. The CEO cares about expected value, not probability of absolute best. The optimal threshold for expected-value problems is lower — you accept good candidates that the best-or-nothing rule would reject.

*The quality signal is noisy.* The classical rule assumes you can perfectly rank each candidate against all previous ones. Real interviews are not perfect signals. A nervous candidate who interviews poorly might be better than a confident one who interviews well. With noisy signals, you should require a larger margin — someone has to be clearly better, not just marginally better — before you accept.

*Recall is partial.* A candidate rejected two weeks ago might still be available. The CEO can call back. This breaks the no-recall assumption in one direction: the effective pool is slightly larger than the sequential model suggests. But it's not full recall — candidates who've accepted other offers are gone.

What should the CEO actually do? Something like this: observe fifteen candidates instead of eighteen (shorter window, because strong referrals cluster early). Use a value-maximization threshold rather than best-or-nothing (accept a candidate who's clearly excellent, not just marginally better than the observation phase's best). Build in a deadline rule: if no candidate clears the threshold by candidate forty, hire the best seen regardless.

The CEO who applies the 37% rule rigidly will make decisions that are slightly wrong in four compounding ways. The CEO who understands the rule — who knows why $1/e$ drops out, what assumptions it encodes, where those assumptions fail — can adapt the strategy to the actual problem. That's the difference between knowing the name of a theorem and understanding what it says.

![Two-column "assumption audit" for the startup CEO example](images/02-optimal-stopping-fig-04.png)
*Figure 2.4 — Two-column "assumption audit" for the startup CEO example*

---

## The failure mode everyone makes

I want to name the central mistake cleanly, because it propagates.

The failure is this: hearing "37% rule" and thinking "I should stop after 37% of candidates." It's understandable — the number sounds like a stopping point. But the stopping-point reading misses both halves of the algorithm. The observation phase is *not stopping*. You are interviewing and learning and building the threshold. You will interview all $n$ candidates if you have to. What changes at 37% is not whether you interview, but whether you are willing to hire.

The subtler failure is applying the rule to problems where the rule does not apply. "I've heard you should look at 37% of options before committing" is reasonable intuition for a problem that is actually the classical no-information, no-recall, best-or-nothing secretary problem. It is bad advice for a problem where you observe absolute values, or where recall is possible, or where you care about expected value.

Optimal stopping theory is a family of results, not a single rule. The 37% threshold is the solution to one specific member of that family — the one with the tightest constraints. Most real decisions live in a different member of the family. Identifying which one is the actual work.

---

## What you can now do

You can recognize when a decision has the stopping structure: sequential observation, irrevocable choice, uncertain future. You know the classical threshold rule — observe $n/e \approx 37\%$, then accept the first improvement — and you know why it falls out of the mathematics. You can identify which variant of the classical problem you are actually in: full-information, value-maximizing, partial-recall, unknown-horizon. And you can adapt the threshold logic to the actual structure of the problem rather than applying the canonical formula to situations it was not built for.

The next time you face a sequence of irrevocable decisions, you will not be able to do better than 37% success on the canonical problem. That is the honest math. What you can do is not make it worse by applying the wrong rule, holding the threshold too high, or confusing the observation phase for the stopping point.

The problem is elegant because the constraints are brutal. The strategy is elegant for the same reason.

---

## Exercises

### Warm-up

**1.** You are choosing among 20 apartments, viewing them one per day. Once you decline a showing, the landlord rents to someone else. You only know which apartments are better or worse relative to those you've already seen — no published price index exists for this neighborhood. Applying the classical secretary setup: how many apartments should you view before entering the acceptance phase? What is the probability you end up with the best apartment if you follow this rule exactly?

*Tests: recognition of the classical secretary structure; mechanical application of the n/e threshold.*

**2.** The derivation showed that $P(\text{success}) \approx \frac{m}{n} \ln(n/m)$. Confirm that this expression equals zero at both $m = 0$ and $m = n$. Explain in one sentence why each extreme gives zero probability of success — without referring to the formula.

*Tests: understanding of why both boundary cases fail, not just the algebraic result.*

**3.** A friend says: "I read about the 37% rule. I've seen 37 out of my 100 candidates, so I'm going to stop interviewing now." Identify the error. State in one sentence what they should do instead.

*Tests: the canonical misconception — distinguishing the observation phase from a stopping point.*

---

### Application

**4.** You are selling your car privately. You've posted the listing and expect roughly 30 inquiries over the next two weeks; each potential buyer needs an answer within 24 hours or they move on. You have a rough sense of what a fair price is (you've checked three comparison sites), so you can judge each offer as above or below your estimated fair value — not just better or worse than previous offers.

Which variant of the stopping problem are you in? Write two sentences: one naming the variant, one explaining how the optimal strategy differs from the classical 37% rule.

*Tests: variant recognition; full-information vs. rank-only distinction.*

**5.** Repeat the optimization in "Working it out" for the case $n = 10$ (small and finite). Instead of using the continuous approximation $\ln(n/m)$, compute the exact success probability for each possible observation phase length $m \in \{1, 2, \ldots, 9\}$ using the exact sum $\frac{m}{n} \sum_{j=m}^{n-1} \frac{1}{j}$. Which $m$ maximizes success? How does it compare to the asymptotic prediction of $m^* = \lfloor 10/e \rfloor = 3$?

*Tests: exact vs. asymptotic comparison; comfort with the finite case where the approximation is imprecise.*

**6.** You are an early-stage investor choosing which of $n = 50$ startups to fund over a six-month period. You see one pitch per week; each founder needs a decision within one week. You do not care about picking the single best startup — you care about expected return, and a startup in the 80th percentile of quality is nearly as valuable as the 95th.

How does the optimal threshold change relative to the classical rule, and in which direction? State whether you would use a shorter observation phase, a longer one, or the same — and why.

*Tests: value-maximization variant; directional reasoning about threshold adjustment.*

**7.** Now suppose recall is partial in the investor scenario above: any startup you declined in the last two weeks can still be re-approached (they haven't closed a round yet), but earlier declines are gone. Does this partial recall make you more patient or less patient in the acceptance phase, relative to the no-recall case? Explain the mechanism in two sentences.

*Tests: recall structure and its directional effect on optimal patience.*

---

### Synthesis

**8.** A hiring manager at a mid-size company is filling a senior role. She has identified four ways her problem deviates from the classical secretary setup: (a) referrals cluster early so the order is not random; (b) she can occasionally circle back to candidates from the last three weeks; (c) she cares about expected quality, not just picking the best; (d) she is uncertain whether the pool will be 30 or 50 candidates.

For each deviation, state its directional effect on the optimal observation window (shorter, longer, or ambiguous) and its directional effect on the acceptance threshold (lower, higher, or ambiguous). Then give an overall recommendation: should she observe more or fewer candidates than the classical $n/e$ rule suggests?

*Tests: integration of all four variants from the chapter; directional reasoning under compound deviations.*

**9.** The Bellman equation for optimal stopping is:

$$V(t, s) = \max\bigl(\text{accept}(s),\ \mathbb{E}[\,V(t+1, s')\mid s\,]\bigr)$$

where $s$ is the current state and $t$ is the current step. Explain in plain language what each of the two terms inside the max represents, and describe the direction in which you solve this equation (forward from $t=1$, or backward from the deadline $T$). Why does the direction matter?

*Tests: DP framing of optimal stopping; the role of backward induction.*

---

### Challenge

**10.** Design an optimal stopping strategy for a problem that violates the random-order assumption in a specific and known way: you are hiring for a role where the recruiting agency always submits their weakest candidates first and their strongest candidates last (they want to end the relationship on a high note). You expect 20 candidates total.

Describe qualitatively how the optimal observation window changes relative to the classical rule, and what information you would need to compute the exact threshold. You do not need to derive a closed-form answer — but you should identify which parameters of the arrival distribution matter.

*Tests: application of optimal stopping logic beyond the classical assumptions; thinking about how non-random order propagates into the threshold calculation.*

**11.** The chapter notes that American option pricing uses optimal stopping, with the exercise boundary computed by backward induction in a binomial tree. Describe the analogy precisely: what plays the role of the "candidate pool," what plays the role of "observing a candidate's quality," what plays the role of the "threshold," and what plays the role of "irrevocable decision"? Identify one way the financial setting differs structurally from the hiring setting that makes the analogy imperfect.

*Tests: cross-domain transfer of the stopping framework; precision in identifying where analogies break.*

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
37%." The actual rule is: observe the first 37%, then accept the
next observation that beats everything you saw in the observation
phase. Make sure I apply the right version.

Walk me through:

1. Which variant of the stopping problem am I in?
   - Full information (I know the distribution of quality)?
   - No information (only relative rankings)?
   - Partial information (some priors on what good looks like)?
   - With recall (I can revisit rejected options)?
   - With a deadline / hard cap on N?
   Be specific. Variants change the optimal threshold materially.

2. What is N — how many options will I see, in expectation?
   If N is uncertain, what's my honest estimate and how wide is the
   uncertainty? If I'm pretending N is fixed when it isn't, surface
   that.

3. Where am I in the sequence now? How many have I already seen,
   and how good was the best so far?

4. Apply the threshold rule for my variant. If I'm in the classical
   no-information secretary problem, observe ~N/e ≈ 37% of N, then
   accept the first one that exceeds everything in the observation
   set. If I'm in a variant, name it and apply the variant's rule.

5. Pressure-test my "best so far." Am I anchoring on a single strong
   candidate from early in the process because it felt good then, or
   because it actually beat everything else I've seen on the criteria
   that matter for the decision?

6. Name the misconception I'm at risk of. The chapter names "37%
   rule means stop at 37%." Am I at risk of misreading the rule? Or
   am I at risk of the deeper failure — treating a non-stopping
   problem (where recall is possible) as if it were one?

Output: a structured diary entry. Headings: The decision, Variant,
N and where I am, Threshold and observed best, What the rule says
to do, Where the model breaks for me, What I'll do next, What would
change my mind, Outcome (to fill in later).

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

**Preview of next chapter:** Chapter 3 (Multi-Armed Bandits) addresses the plural version of optimal stopping — when there are several options and you'll allocate trials across them over time, balancing learning against earning. A/B testing, ad creatives, where to invest career energy, which side projects to keep alive.

---

## AI Wayback Machine

The ideas in this chapter didn't appear from nowhere. **Yuan Shih Chow** co-wrote *Great Expectations: The Theory of Optimal Stopping* in 1971 — the textbook that organized half a century of probability theory around the question this chapter is built on: when do you commit, and when do you keep looking?

**Run this:**

```
Who was Yuan Shih Chow, and how does his work on the theory of optimal stopping connect to the secretary problem and stopping rules we covered in this chapter? Keep it to three paragraphs. End with the single most surprising thing about his career or ideas.
```

→ Search **"Yuan Shih Chow"** on Wikipedia. See what the model got right, got wrong, or left out.

**Now make the prompt better.** Try one of these:

- Ask it to explain the martingale formulation of optimal stopping in plain language, using the secretary problem as the concrete instance.
- Ask it to compare Chow's continuous-time formulation with the discrete decisions you actually had to make in this chapter — when do they agree?

What changes? What gets better? What gets worse?
