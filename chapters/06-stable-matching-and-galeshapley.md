# Chapter 6 — Stable Matching and Gale-Shapley

*The market that works is the one nobody has reason to leave.*

---

## The Problem With Decentralized Markets

In the 1940s, American medical schools were producing a problem nobody had planned for.

Hospitals needed residents. Medical students needed placements. Both sides had preferences. And because there was no central coordinator, hospitals started doing what you'd expect: they made offers early to lock in good candidates before competing hospitals could. By the late 1940s, offers were going out to students in their second year of medical school — years before graduation — with acceptance windows measured in hours. Students were committing to programs they'd barely evaluated, before they knew what their options were. Programs were committing to students who hadn't finished their training.

The market was *unraveling*. Early commitment was individually rational for each hospital, but collectively ruinous for everyone. A student who waited to see her full range of options risked losing offers that evaporated while she thought. A hospital that waited to evaluate its candidates risked losing them to competitors who moved faster. The equilibrium was a race to the bottom.

This is the problem stable matching solves — and understanding why it solves it is the whole chapter.

<!-- → CHART: Timeline showing the unraveling of the medical residency market 1930–1952 — a horizontal axis of years, with a line showing how far in advance of graduation offers were being made, creeping earlier and earlier, then a sharp reset to the 1952 NRMP founding. Student should see that unraveling is a measurable, progressive phenomenon, not a sudden crisis. -->

---

## What Stability Means

The setup: two groups of people, each with preferences over the other. Call them applicants and programs. Each applicant ranks the programs; each program ranks the applicants. You want to pair them up.

A matching is just an assignment — this applicant goes to that program, that applicant goes to this program. There are many possible matchings. Most of them are bad.

Here's what makes a matching bad: suppose applicant Alice is matched to program X, but she would prefer program Y — and program Y would prefer Alice to whichever applicant it actually got. Then Alice and program Y have a mutual grievance. They'd both rather be matched to each other. In a decentralized world, they'd find each other and renegotiate. The assignment falls apart.

A *blocking pair* is any applicant-program pair where both would prefer each other to their current assignments. A matching is *stable* if it has no blocking pairs.

<!-- → INFOGRAPHIC: Small worked example with 3 applicants (Alice, Bob, Carol) and 3 programs (X, Y, Z), showing two matchings side by side — one with a blocking pair highlighted in red (Alice→X but Alice prefers Y and Y prefers Alice), one stable matching with no such pair. Caption: a blocking pair is a mutual grievance that unravels an assignment. -->

Stability is what prevents unraveling. If no applicant-program pair has mutual incentive to defect from the assignment, the assignment holds. Nobody can do better by going around the mechanism. The medical-residency chaos was an instability problem: applicants and programs were finding each other and making private deals because the informal market wasn't producing stable outcomes.

Now the question is: can you always find a stable matching? And if so, how?

---

## The Algorithm

David Gale and Lloyd Shapley answered both questions in 1962. Yes, a stable matching always exists. And here is how to find one.

The algorithm runs in rounds. Every unmatched applicant proposes to the highest-ranked program on their list they haven't already proposed to. Each program looks at its proposals — including any applicant it's currently holding from a previous round — and tentatively accepts its most-preferred applicant. It rejects the rest.

Rejected applicants move down their lists and propose to their next choice in the following round. Programs keep their tentative match but may upgrade if a better applicant proposes. This continues until no applicant has a program left to propose to.

The word "deferred" in the algorithm's name — deferred acceptance — refers to what the programs do. They don't commit immediately. They hold a tentative match but stay open to upgrading. An applicant held by a program may be dropped if a better applicant arrives later.

<!-- → INFOGRAPHIC: Step-by-step trace of Gale-Shapley on a 3×3 example across 3 rounds — show each applicant's proposal arrow, each program's held/rejected decision, and the state of tentative matches after each round. Student should see how a tentative match gets displaced when a better proposal arrives, making "deferred" concrete. -->

Why does this produce a stable matching? Suppose, at the end of the algorithm, that Alice is matched to program X but prefers program Y. For (Alice, Y) to be a blocking pair, program Y would also need to prefer Alice to its current match. But if Alice prefers Y to X, Alice would have proposed to Y before proposing to X — proposals go in preference order. If program Y rejected Alice, it's because Y had a candidate it preferred at the time and never downgraded to Alice. Y prefers its current match to Alice. So (Alice, Y) is *not* a blocking pair. This logic covers every possible applicant-program pair, so the matching is stable.

The runtime is $O(n^2)$ where $n$ is the number of applicants (equal to the number of programs in the classical one-to-one setting). Each applicant proposes to each program at most once — $n$ applicants, $n$ proposals each, $n^2$ proposals total. Each proposal is processed in constant time.

A stable matching always exists because the algorithm always terminates with one.

---

## Who Benefits

Here is the fact about Gale-Shapley that most people miss, and it's the most important structural result in the chapter.

When applicants propose, every applicant gets the *best* partner they could get in *any* stable matching. Not just a stable matching — the best one, across all possible stable matchings. This is the proposer-optimal property.

The flip side: every program gets the *worst* partner they could get in any stable matching.

These two facts come together. The full set of stable matchings for a given preference profile forms a lattice — a partially ordered set with a top and a bottom. The applicant-proposing Gale-Shapley algorithm produces the top of the lattice for applicants, which is simultaneously the bottom for programs. If you flip who proposes — program-proposing Gale-Shapley — you get the other extreme: best for programs, worst for applicants.

<!-- → DIAGRAM: A lattice diagram showing the set of stable matchings for a small example — nodes are matchings, edges connect matchings that differ by one swap, with the applicant-optimal matching at the top and the program-optimal at the bottom. Label the 1952 NRMP (program-proposing, bottom for applicants) and the 1998 redesign (applicant-proposing, top for applicants). Student should see that the redesign wasn't a bug fix — it was a deliberate move across the lattice. -->

Why does this happen? The deferred-acceptance structure benefits the proposing side because proposers keep proposing down their preference lists until someone accepts. A proposer is never held at a program worse than their best stable option — if they could have gotten a better program in some stable matching, they would have proposed there first and been held. The receiving side has the opposite experience: programs can only accept or reject the applicants who arrive. They have no ability to reach out to preferred applicants who haven't proposed.

The consequence for mechanism design is direct: which side you let propose determines who wins. This is a policy decision, not a technical detail.

The NRMP was originally program-proposing — which meant programs got their best stable outcomes and applicants got their worst. In 1998, following research by Alvin Roth and Elliott Peranson, the mechanism was redesigned to be applicant-proposing. The change was deliberate. It moved the outcome across the lattice from the program-optimal stable matching to the applicant-optimal stable matching.

---

## Strategy-Proofness

Suppose you're an applicant in an applicant-proposing Gale-Shapley mechanism. Should you submit your true preferences, or should you game the system?

Roth showed in 1982 that for applicants in an applicant-proposing mechanism, truthful reporting is a dominant strategy. You cannot do better by lying about your preferences. If you truncate your list — pretending some programs are unacceptable when they're not — you might end up unmatched rather than matched to your least-preferred acceptable program. If you permute your list — claiming you prefer program Y to program X when you actually prefer X — you might end up at Y rather than X.

The proposing side has nothing to gain from misreporting.

The receiving side is different. Programs in an applicant-proposing mechanism can sometimes benefit from misreporting — specifically, by truncating their preference lists (claiming an applicant is unacceptable who is actually acceptable). By doing this, a program may end up matched to a more-preferred applicant through a rebalancing of the matching across the preference structure. This is theoretically possible; it requires the program to have precise information about other programs' preferences, which in practice they rarely do.

The deeper result is a theorem by Roth: no stable matching mechanism can be strategy-proof for both sides simultaneously. The asymmetry is structural. You can protect one side from manipulation, but not both. Real mechanism designers choose which side to protect — and that choice reflects whose welfare they're prioritizing.

---

## The Real World Is More Complicated

The classical Gale-Shapley setup has equal-sized groups, strict preferences, and complete rankings. Real markets violate all three.

**Many-to-one matching.** A residency program doesn't take one applicant — it takes a cohort. A school district doesn't assign one student per school. The extension to many-to-one is straightforward: programs have a *quota* (maximum number of applicants they'll accept). The algorithm runs the same way, except programs hold their top $k$ proposals rather than their top one. Stability is defined analogously, and the proposer-optimal property still holds.

**Ties.** Programs often can't strictly rank all applicants — some are equally qualified. When preferences have ties, multiple stable matchings can have different welfare properties for the same side. A random tie-breaking rule produces a stable matching but may not be fair in the sense of equal treatment.

**Incomplete preferences.** Applicants may not want to rank every program (some are genuinely unacceptable). Programs may not want to accept every applicant. The algorithm handles this: unacceptable options are simply omitted from the preference list. Some participants may end up unmatched.

The rural hospital theorem, proved by Roth in 1986, gives a sharp result about incomplete-preferences matching: the *set* of unmatched participants is identical across all stable matchings. If a program fills below quota in one stable matching, it fills below quota in every stable matching, by the same amount. Reshuffling stable matchings — moving from program-optimal to applicant-optimal — doesn't help hospitals that no applicant ranked. The unfilled slots are a structural feature of the preferences, not an artifact of which stable matching you chose.

<!-- → TABLE: Two-column illustration of the rural hospital theorem — left column shows applicant-optimal stable matching with fill rates per program; right column shows program-optimal stable matching with fill rates. The rural/less-preferred programs show identical fill rates in both columns. Caption: switching which side proposes changes who wins among matched participants but leaves unfilled programs unfilled regardless. -->

This matters for policy. Rural hospitals are unfilled because applicants don't prefer them, not because the algorithm is badly designed. No change to the matching mechanism changes that. The intervention, if one is warranted, is outside the algorithm — incentive programs, living allowances, pipeline development.

**Couples.** The NRMP has a genuine complication: married medical students who want placements in the same geographic area. A couple's preference isn't over individual programs — it's over *pairs* of programs. This breaks the substitutability assumption that makes Gale-Shapley work. When preferences involve complementarities (I want program A only if my partner also gets program B), a stable matching may not exist. The NRMP runs a specialized extension; in some years the algorithm reports an approximation because no true stable matching is achievable with the submitted preferences.

---

## The Fairness Misconception

The most consequential mistake practitioners make when working with stable matching is calling the result *fair*.

Stability is not fairness. Stability means no blocking pair — no applicant-program pair has mutual incentive to defect. It says nothing about whether the assignment is equitable across applicants, or whether the proposing side benefited at the receiver side's expense, or whether applicants from disadvantaged backgrounds entered the market with equal prospects.

The proposer-optimal property is not fair to the receiving side. Every program in an applicant-proposing mechanism gets its worst stable outcome. The mechanism was designed to favor applicants. Calling the result "fair to everyone" is wrong — and it obscures the policy decision that was made about whose welfare to prioritize.

There are multiple stable matchings in the lattice. The Gale-Shapley algorithm picks one extreme. Interior stable matchings — ones that sit between the proposer-optimal and receiver-optimal ends — may better balance welfare across both sides. Choosing which stable matching to implement is itself a policy question, and answering it requires being explicit about fairness criteria that stability alone cannot resolve.

Ties create another welfare ambiguity. When programs have tied preferences, different tie-breaking rules lead to different stable matchings with different applicant welfare. Random tie-breaking is fair in expectation — any applicant is equally likely to benefit from the tie resolution. Deterministic tie-breaking by secondary criterion (say, test score) may systematically advantage some applicants over others while remaining stable throughout.

Finally, stability says nothing about the market itself. A stable matching within a medical residency system is consistent with a market where graduates from certain medical schools never reach top programs, where informal networks shape which applicants programs actually rank, where rural communities lack the physicians they need. The algorithm is stable with respect to the preferences submitted; it doesn't adjudicate whether those preferences were shaped by fair conditions. Stability is a local property.

The corrective: name which side proposes, state what the welfare implications are, handle ties and incomplete preferences explicitly, and keep fairness criteria on the table as a separate question from stability.

---

## What Comes Next

Stable matching gives you a framework for two-sided markets where preferences are fixed and the goal is a durable assignment. The key insight — that stability prevents unraveling by removing the incentive to defect — generalizes beyond the specific algorithm.

Chapter 7 moves from *matching* to *routing*: how do you direct flows through a network when the network is uncertain and participants are self-interested? The question of stability returns, but now in a dynamic setting where the "match" is renegotiated every time a packet or a vehicle makes a routing decision. The mechanism-design intuitions from this chapter carry forward; the combinatorial structure is different.

The deeper thread: markets are algorithms, whether or not anyone designed them to be. The medical-residency market in the 1940s was running an algorithm — it was just a bad one. Unraveling is what an unstable market does. The NRMP replaced it with a better algorithm, one whose fixed point is durable by construction. Understanding why the better algorithm works is understanding what stability actually buys.

---

## What You Can Do Now

You can recognize when a problem is a stable-matching problem: two-sided preferences, a need for durable assignment, and pressure toward unraveling in a decentralized setting. You can apply Gale-Shapley correctly, with attention to which side proposes and what that means for outcomes. You can extend the framework to many-to-one matching with quotas, handle ties and incomplete preferences, and identify the cases — couples, complementarities — where stable matchings may not exist. You can state the rural hospital theorem and explain why mechanism-redesign doesn't help unfilled programs. And you can articulate precisely why stability is not fairness, and what the proposer-optimal property means for which side wins.

The next time a two-sided assignment problem arrives — applications, school choice, residency, internal project staffing — the question to ask first is: who proposes? Everything follows from the answer.

---

## Exercises

### Warm-Up

**W1.** Three applicants (Alice, Bob, Carol) and three programs (X, Y, Z) have the following strict preferences:

| Applicant | Preference | Program | Preference |
|-----------|-----------|---------|-----------|
| Alice | Y > X > Z | X | Alice > Carol > Bob |
| Bob | X > Y > Z | Y | Bob > Alice > Carol |
| Carol | X > Y > Z | Z | Alice > Bob > Carol |

Run the applicant-proposing Gale-Shapley algorithm by hand. Trace each round: who proposes, who accepts, who is rejected. State the final matching and verify it has no blocking pairs. *(Tests: algorithm mechanics, stability verification.)*

**W2.** Using the same preference profile from W1, now run the program-proposing version of Gale-Shapley. State the final matching. Compare the two outcomes: which applicants are better off under applicant-proposing? Which programs are better off under program-proposing? Does either result surprise you, given the proposer-optimal property? *(Tests: proposer-optimal property, welfare comparison across the two algorithm variants.)*

**W3.** A matching mechanism is called strategy-proof for one side if truthful preference reporting is a dominant strategy for that side. In the applicant-proposing Gale-Shapley mechanism: (a) Is it ever in Alice's interest to submit a preference list that swaps her top two programs? Explain why or why not. (b) Is it ever in program X's interest to truncate its preference list? Describe the general condition under which this might help it. *(Tests: strategy-proofness for proposing side, manipulability of receiving side.)*

### Application

**A1.** A technology company runs annual project assignments: 12 engineers and 12 projects, each with preferences over the other. Currently, project leads make offers to engineers in an informal process: leads identify their top candidates and extend verbal offers, engineers have 24 hours to accept or decline, and leads move to their next choice if rejected. Identify which structural property of stable matching this mechanism violates. Name two specific behaviors you would expect to observe as a symptom of this violation. Describe what a Gale-Shapley redesign would change and who would benefit. *(Tests: unraveling recognition, blocking pairs in decentralized markets, mechanism redesign consequences.)*

**A2.** A city school district runs a student-school assignment process. Each student ranks up to 5 schools; each school has a quota and ranks applicants by a priority score (sibling enrollment, then test score, then lottery). Ties in priority score are broken randomly. Explain why this is a many-to-one matching problem. Identify the role of incomplete preferences (students rank only 5 of 20 schools) and tie-breaking. What does the rural hospital theorem predict about the lowest-demand schools in this system, and what policy intervention does that suggest? *(Tests: many-to-one extension, incomplete preferences, rural hospital theorem, policy implications.)*

**A3.** Two medical students are a married couple applying to residency programs in the same metropolitan area. Their joint preference is: (Neurology-City A, Cardiology-City A) > (Internal Medicine-City A, Pediatrics-City A) > (Neurology-City B, Cardiology-City B). Explain why this preference structure is not representable as two independent individual preference lists. What property of the standard Gale-Shapley model does it violate? What does this imply about the existence of a stable matching when couples are present? *(Tests: couples and complementarities, substitutability assumption, limits of the standard model.)*

### Synthesis

**S1.** A colleague argues: "We redesigned our hiring process to use applicant-proposing Gale-Shapley. Now it's fair to everyone." Write a precise technical response that (a) states what the proposer-optimal property actually guarantees, (b) explains in what sense the new mechanism is *not* fair to hiring managers (programs), (c) describes the lattice of stable matchings and where the new mechanism sits in it, and (d) identifies at least one fairness criterion the new mechanism leaves unaddressed. *(Tests: proposer-optimal property, fairness vs. stability distinction, lattice structure, limits of the stability guarantee.)*

**S2.** A nonprofit designs a mentorship matching program: 40 junior researchers (applicants) and 15 senior researchers (mentors, each willing to take up to 3 mentees). The nonprofit wants the mechanism to be strategy-proof for junior researchers and to produce stable outcomes. They are considering three designs: (i) juniors propose, (ii) seniors propose, (iii) a lottery with no preference elicitation. For each design, state whether it achieves the two stated goals, identify who is favored and who can manipulate, and recommend one design with justification. *(Tests: many-to-one extension, strategy-proofness choice, who-proposes-who-wins, mechanism selection.)*

**S3.** The Boston Public Schools used the "Boston mechanism" for school assignment until 2005: students list their top choices in order; the algorithm first fills seats at each school with students who listed it first (by priority score), then repeats for second choices, and so on. A student who lists a competitive school second risks not getting their first choice and also being shut out of the competitive school (whose seats are already filled). Explain the strategic problem this creates for students. State how applicant-proposing Gale-Shapley resolves it, and why that resolution is connected to strategy-proofness rather than just to stability. *(Tests: manipulability of non-strategy-proof mechanisms, strategy-proofness as a design goal distinct from stability, real-world mechanism comparison.)*

### Challenge

**C1.** The rural hospital theorem states that the set of unmatched participants is identical across all stable matchings. Suppose a policy-maker claims: "If we switch from program-proposing to applicant-proposing Gale-Shapley, rural hospitals that currently go unfilled will attract better applicants because applicants now have more bargaining power." Evaluate this claim. What does the theorem actually imply about the fill rate of rural hospitals across the two mechanisms? What *does* change for rural hospitals when the proposing side switches, if anything? What type of intervention *would* change rural hospital fill rates, and why is it outside the algorithm's scope? *(Tests: rural hospital theorem, what does and doesn't change across stable matchings, limits of mechanism design.)*

**C2.** Design a matching mechanism for the following setting: a graduate school with 50 PhD applicants, 20 faculty advisors (each willing to take 1–3 students), and the following complications: (a) some applicants are co-advised and have joint preferences over advisor pairs, (b) two faculty members have a known conflict and refuse to co-advise the same student, (c) the school wants the mechanism to be strategy-proof for students. Identify which of these complications is handleable by standard Gale-Shapley variants, which requires a specialized extension, and which may preclude the existence of a stable matching. Sketch the design choices you would make and their welfare consequences. Identify the unresolved tension in your design. *(Tests: synthesis of variants — many-to-one, couples, complementarities, strategy-proofness — and honest acknowledgment of impossibility results.)*

---

## LLM Exercise — Chapter 6: A Stable-Matching Decision

**Project:** *Decision Diary*.

**What you're building this chapter:** A diary entry on one real two-sided pairing decision in your life — a hiring round, a project-engineer assignment, an advisor-student match, a co-founder search, a marketplace design.

**Tool:** Claude Project (your *Decision Diary*).

**The prompt:**

```
Chapter 6 entry — Stable Matching.

The decision I'm thinking through: [one or two sentences naming a
real two-sided pairing decision. Examples: how to assign the next
quarter's engineers to projects given both sides have preferences;
how to think about a hiring round where candidates and roles both
rank each other; how to design the matching mechanism for an
internal mentorship program; how to navigate a residency match,
school choice, or job-offer round; how my org's vendor-selection
process is currently structured.]

Help me work through this as a stable-matching problem. The chapter
named two consequential misconceptions:

(a) "Stable matching produces a fair outcome" — it doesn't. The
proposer side gets its best stable outcome; the receiver side gets
its worst. Which side proposes determines who benefits.

(b) Implicit: that a non-stable mechanism (early commitments, side
deals, prestige-based rankings without explicit preferences) is just
a different way of producing the same result. It isn't. It usually
produces unraveling.

Walk me through:

1. **Identify the two sides.** Who is being matched to whom?
   Applicants to programs? Engineers to projects? Founders to
   investors? Mentors to mentees? Be specific.

2. **What are each side's preferences?** Real preference lists,
   not just "everyone wants the top candidate." If one side has
   tied or incomplete preferences, name that — Gale-Shapley
   variants handle it but the variant matters.

3. **Who proposes — currently and ideally?** In my current
   mechanism, which side is making the moves and which is
   evaluating? Who benefits from that?

4. **Is the mechanism strategy-proof for the proposing side?**
   Applicant-proposing deferred acceptance is strategy-proof for
   applicants (they should submit their true preferences).
   Program-proposing is not strategy-proof for programs in
   many-to-one cases. What's the equivalent for my situation?

5. **Where is the mechanism unraveling?** Are matches being
   made before formal evaluation? Are exploding offers being used
   to force commitment? Are side channels (informal calls,
   reference whispers) reshaping the matching after the formal
   round? These are signs of an unstable mechanism — even if no
   blocking pair is mathematically present, the *behavior*
   indicates instability.

6. **Is the "fairness" framing being used to obscure who wins?**
   When stakeholders call the current mechanism "fair," check
   what they actually mean. Often "fair" is doing rhetorical work
   that "stable" cannot do honestly.

7. **What's the many-to-one extension?** Programs admit multiple
   applicants; projects host multiple engineers. The chapter
   covers this — does my mechanism need it, and is the
   capacity-respecting variant being used?

Output: a structured diary entry. Headings: *The matching
problem*, *The two sides and their preferences*, *Current
mechanism and who proposes*, *Strategy-proofness*, *Signs of
unraveling*, *Fairness framing vs stability*, *What I'd change
about the mechanism*, *What I'll do next*, *What would change my
mind*, *Outcome (to fill in later)*.
```

**What this produces:** A diary entry that classifies your matching problem, names the proposing side and its incentives, and (most usefully) surfaces where the *current* mechanism in your environment is unstable — i.e., where the formal process is being routed around by exploding offers, prestige hierarchies, or backchannel commitments.

**How to adapt this prompt:**

- *For your own project:* If you're a participant in the matching (job-search, partner-search), shift the entry's tone to "what should *I* do under this mechanism," not "what should the mechanism be."
- *For ChatGPT / Gemini:* Both work. Either can run Gale-Shapley on a small worked example if you want to see the algorithm produce a matching on your stated preferences.
- *For Claude Code:* Sidecar opportunity: ask Claude Code to implement Gale-Shapley for your specific preference lists, then run it. The output is the diary entry's "what the algorithm says to do" anchor.
- *For a Claude Project:* Native fit. If you're a recurring participant in matching markets (hiring frequently, evaluating candidates often), the project will notice patterns in your preferences.

**Connection to previous chapters:** Strategy-proofness analysis is game-theoretic (Chapter 4). Many-to-one matching with capacity constraints connects to scheduling (Chapter 5). The Bayesian-game framing of submitting preferences under uncertainty (Chapter 1) applies.

**Preview of next chapter:** Chapter 7 (Randomness and Networking) shifts to *systems* decisions — when to randomize routing, when to use gossip protocols, when consistent hashing earns its keep. The diary entry will be the most engineering-flavored of the eight.

---

## AI Wayback Machine

The ideas in this chapter didn't appear from nowhere. **Marilda Sotomayor** is a Brazilian economist who co-wrote the canonical textbook on two-sided matching with Alvin Roth — extending Gale–Shapley to the messy real-world cases of many-to-one and many-to-many matching that show up in school choice, residency matching, and kidney exchange.

**Run this:**

```
Who is Marilda Sotomayor, and how does her work on two-sided matching markets connect to the Gale–Shapley algorithm we implemented in this chapter? Keep it to three paragraphs. End with the single most surprising thing about her career or ideas.
```

→ Search **"Marilda Sotomayor"** on Wikipedia. See what the model got right, got wrong, or left out.

**Now make the prompt better.** Try one of these:

- Ask it to extend Gale–Shapley to a many-to-one case (residents to hospitals), and explain where new failure modes appear.
- Ask it to compare Sotomayor's school-choice mechanisms with the deferred-acceptance algorithm you implemented — what's different in practice?

What changes? What gets better? What gets worse?
