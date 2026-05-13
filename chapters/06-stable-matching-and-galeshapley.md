# Stable Matching and Gale-Shapley

## TL;DR

Stable matching pairs members of two sets — applicants and programs, students and schools, riders and drivers — such that no two unmatched parties prefer each other to their assigned partners. Reach for this chapter when a problem has the shape "two-sided market with preferences and a need for stability." After consulting it, you can apply the Gale-Shapley deferred-acceptance algorithm correctly, identify which side benefits (proposer-optimal stability), extend the model to many-to-one matching, and recognize when ties or incomplete preferences require variants.

## Recognition pattern

Three signals.

*Two distinct populations with preferences over each other.* Applicants rank programs; programs rank applicants. Students rank schools; schools rank students. Riders have preferences over drivers; drivers have preferences over rides. Each side has a preference list; the goal is to pair them.

*The pairing must be stable.* A matching is *stable* if no unmatched applicant-program pair would both prefer each other to their assigned partners. Instability creates pressure to renegotiate — the matched parties have incentive to break the match. Stability is what makes the assignment durable.

*Preferences are private and decentralized.* Without a centralized clearinghouse, stable matchings can be hard to reach — applicants apply, are accepted or rejected, may have their offers rescinded, may receive late offers from preferred programs after committing elsewhere. The "unraveling" of decentralized markets motivated the development of centralized matching algorithms.

A signal stable matching is *not* the right tool: pricing replaces preferences. In a market where prices clear demand, the matching mechanism is the price system, not preference-based matching. Auction-based assignment (Chapter 4) is the framework. Stable matching applies when participants cannot freely set prices — labor markets with fixed pay scales, school choice with no tuition variation, organ allocation with no monetary exchange.

The misconception engaged in §8 is consequential: "Stable matching produces a fair outcome." The Gale-Shapley algorithm produces a *stable* matching, not a fair one. The proposer side gets its best stable outcome; the receiver side gets its worst. Which side proposes determines who benefits. Calling the result "fair" misreads what the algorithm guarantees.

## What you need to know first

This chapter assumes basic combinatorial reasoning (Vol. 1 Chapter 2) and game theory at the level of Chapter 4. The strategy-proofness analysis uses Bayesian-game reasoning from Chapter 4. For the matching-as-graph framing, see Vol. 1 Chapter 5. For network flow as a matching mechanism (bipartite matching reduces to max-flow), see Vol. 1 Chapter 9.

## The stable matching problem

The classical problem (Gale and Shapley 1962) [verify]: two equal-sized sets `M` and `W` (originally framed as men and women, though the modern framing uses applicants and programs or two abstract sides). Each member of `M` has a strict ranking over members of `W`; each member of `W` has a strict ranking over members of `M`. A *matching* is a one-to-one correspondence between `M` and `W`. A matching is *stable* if no pair `(m, w)` exists where:

- `m` and `w` are not matched to each other, *and*
- `m` prefers `w` to `m`'s current match, *and*
- `w` prefers `m` to `w`'s current match.

Such a pair is called a *blocking pair*. A stable matching has no blocking pairs.

**Existence.** A stable matching always exists for any preferences. This is non-obvious — preferences could be cyclic in a way that seems to preclude stability — but Gale and Shapley proved it by giving a constructive algorithm.

**Uniqueness.** Stable matchings are not unique. A given preference profile typically admits many stable matchings, varying in who gets matched to whom. The set of stable matchings has a lattice structure — the proposer-optimal and receiver-optimal matchings sit at the top and bottom respectively.

## The Gale-Shapley deferred-acceptance algorithm

The algorithm runs in rounds.

```
Initialize: all members of M and W are unmatched.

While some m in M is unmatched and has not proposed to all w in W:
    m proposes to the highest-ranked w on m's list to whom m has not yet proposed.
    If w is unmatched: w tentatively accepts m.
    Else: w compares m to her current tentative match m'.
          If w prefers m to m': w rejects m', tentatively accepts m. m' becomes unmatched.
          Else: w rejects m. m proceeds to the next w on m's list.

When no m has an unmatched-and-unproposed candidate: tentative matches become final.
```

Time complexity: `O(n²)` where `n = |M| = |W|`. Each member of `M` proposes to each member of `W` at most once, giving `n²` proposals.

**Correctness.** The output is a stable matching:
- *Termination*: every proposal moves a member of `M` down their preference list; total proposals bounded by `n²`.
- *No blocking pairs*: if `(m, w)` were a blocking pair where `m` prefers `w` to current match, `m` would have proposed to `w` before reaching the current match. `w` either accepted (and would be matched to `m` or someone she prefers more, contradicting blocking) or rejected (meaning she preferred her current tentative match, so wouldn't prefer `m` now).

**Proposer-optimal stability.** The Gale-Shapley algorithm with `M` proposing produces the matching where every `m` gets the *best* partner achievable in any stable matching (Gale-Shapley 1962) [verify]. Symmetrically, every `w` gets the *worst* partner achievable in any stable matching. The roles are perfectly inverted: which side proposes determines who is favored.

This is the chapter's most consequential structural fact. The "fairness" misconception arises from missing it.

## Strategy-proofness

A matching mechanism is *strategy-proof* if each participant's best strategy is to report their true preferences, regardless of what others do.

**One-sided strategy-proofness of Gale-Shapley.** When `M` proposes, the proposing side has a dominant strategy of reporting truthfully (Roth 1982) [verify]. Lying about preferences cannot improve a proposer's match.

**One-sided manipulability.** The receiving side can sometimes benefit from misreporting. By truncating their preference list (claiming some acceptable matches are unacceptable), a receiver may end up matched to a more-preferred partner. This is the "rural hospital theorem" inverse — the receivers can manipulate, the proposers cannot.

**No two-sided strategy-proof stable mechanism.** Roth (1982) [verify] showed that no stable matching mechanism is strategy-proof for both sides. The trade-off is structural; you can't have both stability and bilateral truthfulness.

The asymmetry matters in practice. A matching mechanism's choice of proposer determines who can manipulate and who cannot. Mechanism designers in real markets (the NRMP, school choice systems) chose proposing sides deliberately.

## Variants — many-to-one, ties, incomplete preferences

The classical problem assumes one-to-one matching with strict, complete preferences. Real markets violate each assumption.

**Many-to-one matching.** Programs match with multiple applicants up to a quota. The NRMP, college admissions, school choice. Gale-Shapley generalizes: the proposing side (applicants) propose; programs hold the top `k` proposals (where `k` is the program's quota) and reject the rest. Stability is defined analogously, with blocking pairs being applicant-program pairs where both would prefer each other.

**Ties in preferences.** Programs may have ties (no strict ranking among some applicants). With ties, multiple stable matchings can have different *applicant-side* utilities, and the question of which to choose becomes a separate optimization. Tie-breaking randomly produces a stable matching but may sacrifice some applicants' welfare.

**Incomplete preferences.** Applicants may not rank all programs (some are unacceptable). Programs may have minimum thresholds. The Gale-Shapley algorithm extends; the result is stable on the *acceptable* set, with some participants potentially unmatched.

**The rural hospital theorem.** In many-to-one matching with incomplete preferences, the *set* of unmatched participants and *fill rate* of programs is the same across all stable matchings (Roth 1986) [verify]. Some hospitals — typically rural, less-preferred — fill below their quotas in every stable matching. The theorem has policy implications: reshuffling stable matchings doesn't help unfilled hospitals.

**Couples and complementarities.** When applicants are couples seeking nearby placements, preferences become non-substitutable, and stable matchings may not exist. Real systems (NRMP) have specialized algorithms for couples.

## Decision rules

| Situation | Approach |
| --- | --- |
| Two-sided market, preferences known, want stability | Gale-Shapley deferred acceptance |
| Decide which side proposes | The proposing side gets best stable outcome; choose deliberately |
| Many-to-one (residents/hospitals, students/schools) | Gale-Shapley with quotas |
| Ties in preferences | Tie-break randomly or by secondary criterion |
| Incomplete preferences (some unacceptable) | Gale-Shapley extends; some participants unmatched |
| Need strategy-proofness on one side | Gale-Shapley with that side proposing |
| Need strategy-proofness on both sides | Impossible — Roth 1982 |
| Couples seeking nearby placements | NRMP-style specialized algorithm |
| School choice with priorities | Boston mechanism (manipulable) or DA (strategy-proof for students) |
| Allocation without preferences (random) | Random serial dictatorship |
| Allocation with prices | Auction (Chapter 4), not stable matching |
| Bipartite matching without preference structure | Max-flow on bipartite graph (Vol. 1 Chapter 9) |

## Worked example — the medical residency match (NRMP)

The National Resident Matching Program matches roughly 50,000 graduating medical students to residency programs each year [verify]. Both sides submit ranked preference lists. The match is centralized; participants cannot directly communicate offers.

**History.** Before 1952, the medical-residency market was decentralized. Applicants received offers progressively earlier as programs tried to lock in top candidates before competitors could counter. By the 1940s, programs were making offers to medical students in their second year — years before graduation, with binding acceptance windows of hours. The market was *unraveling*.

The NRMP was created in 1952 [verify] to solve unraveling via a centralized algorithm. The original mechanism was the *program-proposing* version of Gale-Shapley.

**The 1998 redesign.** The mechanism was *program-proposing* until 1998. This produced *program-optimal* stable matchings — programs got the best stable outcome; applicants got the worst. After concerns about applicant welfare (and recognition that the proposer-side bias produced systematically worse outcomes for the side that did not propose), the NRMP redesigned the algorithm to be *applicant-proposing* (Roth and Peranson 1999) [verify].

The redesign matters because of the proposer-optimal property. Applicants in the new mechanism receive their best stable matches; programs receive their worst stable matches. For applicants who would have been matched anyway, the two mechanisms might produce the same outcome — but for applicants whose stable-matching options vary across the lattice of stable matchings, the change is meaningful.

**Couples.** The NRMP has substantial numbers of couples (married medical students) seeking placements that allow them to live near each other. Couples' preferences are over *pairs* of placements, which can break the substitutability assumption that guarantees stable-matching existence in the standard model. The NRMP's algorithm includes a specialized couples-handling extension; in some years, no stable matching exists with couples, and the algorithm reports the closest approximation.

**Empirical patterns.**

- Most participants get one of their top choices. The match is *high-quality* for applicants in the typical case, even though the algorithm guarantees only stability, not satisfaction.
- The rural hospital theorem holds: certain hospitals (geographically remote, less prestigious) fill below quota in every stable matching. The NRMP's switch to applicant-proposing did not help these hospitals.
- Strategy-proofness for applicants matters: medical students can submit truthful preferences without strategic concern. Programs can in principle manipulate but rarely have the information to do so effectively.

**The school-choice analog.** Many U.S. cities (Boston, NYC, Denver, New Orleans) use modified Gale-Shapley for public-school assignment [verify]. The Boston Public Schools used a non-strategy-proof mechanism (the "Boston mechanism") until 2005, then switched to applicant-proposing Gale-Shapley after research showed applicant manipulation was producing welfare-reducing distortions (Abdulkadiroğlu and Sönmez 2003) [verify]. The redesign followed the same pattern as the NRMP: from a manipulable mechanism to a strategy-proof one for the side that the policymaker prioritized.

The lesson: stable matching is a structural framework, not a fairness guarantee. The choice of proposer, the handling of couples and ties, the inclusion or exclusion of priority systems — all are mechanism-design decisions that determine who benefits. Real production matching systems are decades of accumulated mechanism-design research applied to specific markets.

## Failure modes — when "stable matching produces a fair outcome" misleads

The misconception engaged: "Stable matching produces a fair outcome."

The Gale-Shapley algorithm produces a *stable* matching. Stability is a specific property: no pair has incentive to break their assignment. Fairness is a different concept and the algorithm does not guarantee it.

**The proposer side is favored.** The proposer-proposing version produces the proposer-optimal stable matching. Every proposer gets the best stable partner; every receiver gets the worst stable partner. Calling this fair to both sides is wrong.

**Choice of proposer is a policy decision.** Whether `M` or `W` proposes is determined by the mechanism designer. The choice has welfare consequences. Markets with applicant-proposing mechanisms favor applicants; markets with program-proposing mechanisms favor programs. The 1998 NRMP redesign was an explicit choice to favor applicants over programs.

**Ties create welfare ambiguity.** When preferences have ties, multiple stable matchings produce different applicant-side outcomes. Tie-breaking matters. Random tie-breaking produces fairness in expectation; deterministic tie-breaking may favor systematically.

**Incomplete preferences hide unmatched parties.** Some participants are unmatched in every stable matching (rural hospital theorem). Their welfare is zero. Calling the matching fair while ignoring them misrepresents the situation.

**Strategy-proofness is one-sided.** The receiving side can manipulate. In real markets, sophisticated participants on the receiving side may game the system; less-sophisticated participants pay the cost. The asymmetry between proposer-strategy-proofness and receiver-manipulability creates fairness questions about who has the information and capacity to manipulate.

**Stability doesn't address allocation across markets.** A match within one market is stable; whether the market itself is fair (do applicants from disadvantaged backgrounds enter with the same prospects?) is outside the algorithm's scope. Stability is a local property.

**Welfare comparisons across stable matchings.** The set of stable matchings has a lattice structure. The proposer-optimal and receiver-optimal are extremes; intermediate stable matchings exist that may better balance welfare. The Gale-Shapley algorithm picks the extreme of the lattice; other algorithms (linear programming, mediating mechanisms) pick interior points. Choosing among stable matchings is itself a policy question.

**Couples and complementarities can preclude stability.** When the standard model breaks (couples, peer effects, complementarities), no stable matching may exist. Real markets handle these cases with approximations, not stable matchings.

The corrective heuristic: state which side proposes, what the welfare implications are, how ties and incomplete preferences are handled, and what fairness criteria are required separately from stability. Stability is one criterion; fairness is many.

## Cross-references

For game-theoretic mechanism design underlying strategy-proofness, see Chapter 4. For Bayesian-game reasoning when participants have private types, see Chapter 4 §6. For bipartite matching without preferences (combinatorial maximum matching) reducing to network flow, see Vol. 1 Chapter 9. For the NP-hardness of certain matching variants (matching with couples), see Vol. 1 Chapter 10.

## Companion-page handoffs

Many-to-one matching implementations with quotas and ties; school-choice algorithm comparisons (Boston mechanism vs deferred acceptance vs top trading cycles); real NRMP statistics (match rates by specialty, couples handling, fill rates); Gale-Shapley implementation in Python with traceability of preference reasoning; rural hospital theorem demonstration. Available at bearbrown.co/algorithms-by-bear-vol2/chapter-6.

## What this chapter does not enable

This chapter does not give a deep treatment of mechanism design impossibility theorems beyond the Roth strategy-proofness result. The Gibbard-Satterthwaite theorem [verify], the Myerson-Satterthwaite theorem on bilateral trade impossibility, and the broader landscape of impossibility results in social choice theory are out of scope; consult Roth's *The Economics of Matching* and Mas-Colell-Whinston-Green for graduate treatments. The chapter also does not cover online matching (where preferences arrive sequentially), kidney-exchange algorithms (which are a different combinatorial structure), or two-sided platforms with prices (which combine matching with auction-style mechanisms).

## Capability statement

You can now recognize when a problem is a stable-matching problem; apply Gale-Shapley correctly with attention to which side proposes and what that means for outcomes; extend to many-to-one matching with quotas, ties, and incomplete preferences; recognize the strategy-proofness asymmetry and its implications; and avoid the failure mode of conflating stability with fairness. The next time a two-sided market with preferences requires assignment — applications, school choice, organ allocation, residency matching — the path from problem to mechanism is in your hands.


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

## 🕰️ AI Wayback Machine

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
