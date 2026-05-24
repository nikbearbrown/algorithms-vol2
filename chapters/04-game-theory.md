# Chapter 4 — Game Theory

*What happens when the answer to your optimization problem depends on someone else solving theirs.*

---

In 1950, the RAND Corporation posed a thought experiment to illustrate why two perfectly rational people might make each other worse off. Two suspects are arrested separately and can't communicate. If both stay silent, both get a short sentence on a minor charge. If one talks and the other doesn't, the talker goes free and the silent one gets the maximum sentence. If both talk, both get a long sentence — worse than if both had stayed silent, but better than being the one who stayed silent while the other talked.

What does each suspect do?

If you think your partner will stay silent, you should talk — you go free instead of serving the minor sentence. If you think your partner will talk, you should also talk — you get the long sentence instead of the maximum. Talking is the right move regardless of what your partner does. The logic is airtight. Both suspects talk. Both get the long sentence. The outcome is worse for everyone than if they'd both stayed silent.

This is the Prisoner's Dilemma, and it's not really about prisoners. It's about the structure of any situation where individual rationality produces collective failure — price wars that destroy industry profits, arms races that leave both sides less secure, fisheries that collapse because each boat takes as much as it can. The dilemma works because of the shape of the payoffs. Change the numbers and you get a different problem. But the logic — rational self-interest leading to a worse outcome for everyone — recurs across economics, biology, political science, and computer systems.

What makes this different from the decision problems in earlier chapters is the presence of another mind. In Chapter 1, you were updating beliefs about a world that didn't care what you concluded. In Chapter 2, you were timing a commitment against a process that ignored your reasoning. Here, the other player is watching you, predicting you, and acting in response. Your best move depends on their move. Their best move depends on yours. The problem is reflexive, and standard optimization has no direct handle on it.

Game theory is the framework built for this situation.

---

## The Model

A game has three parts.

**Players.** The decision-makers. Two in the simplest cases; potentially many. What distinguishes a player from background noise is that their choices affect your payoff and yours affect theirs.

**Strategies.** The actions available to each player. A *pure strategy* is a single action chosen with certainty. A *mixed strategy* is a probability distribution over actions — deliberately randomizing, which turns out to matter more than it initially seems.

**Payoffs.** Each player's utility for each combination of strategies. With two players and two strategies each, this fits naturally into a two-by-two matrix. Each cell holds a pair of numbers: what player one gets and what player two gets when each plays that combination.

That's the whole model. The game is completely specified once you name the players, their strategy sets, and their payoff function. The Prisoner's Dilemma fits in four cells. So does every other two-player, two-strategy game — and the differences between those games all live in the numbers.

| Player 2 (Cooperate | Defect) |
| --- | --- |
| Player 1 (Cooperate, Defect | A concrete checkpoint for applying the chapter concept. |
| columns: Player 2 (Cooperate, Defect | A concrete checkpoint for applying the chapter concept. |
| cells: (R,R | A concrete checkpoint for applying the chapter concept. |
| S,T | A concrete checkpoint for applying the chapter concept. |
| T,S | A concrete checkpoint for applying the chapter concept. |
| P,P) with T > R > P > S labeled | A concrete checkpoint for applying the chapter concept. |
| Nash equilibrium cell (Defect, Defect) highlighted | A concrete checkpoint for applying the chapter concept. |
| reader should see at a glance why Defect dominates regardless of what the other player does, and why the Nash equilibrium is Pareto-inferior to (Cooperate, Cooperate | It makes the underlying reasoning visible instead of implied. |

**Cooperative versus non-cooperative.** In cooperative games, players can make binding agreements — enforceable contracts, side payments, coalitions. In non-cooperative games, they can't. Most of what's useful for production systems is non-cooperative: you can't enforce a promise to your competitor not to undercut your price.

**Zero-sum versus general-sum.** Zero-sum means one player's gain is exactly another's loss. Chess, poker within a single hand, any fixed-pie negotiation. General-sum means the total payoff can go up or down depending on joint choices. Most economic interactions are general-sum — there are gains from trade, and there are also wars of attrition that destroy value on both sides.

---

## Nash Equilibrium

The central solution concept in non-cooperative game theory is the **Nash equilibrium**, named for John Nash's 1950 result. A Nash equilibrium is a strategy profile — one strategy for each player — where no player gains by unilaterally changing their strategy, given what everyone else is doing.

Formally: strategy profile $(s_1^*, s_2^*, \ldots, s_n^*)$ is a Nash equilibrium if for every player $i$,

$$u_i(s_i^*, s_{-i}^*) \geq u_i(s_i, s_{-i}^*) \quad \text{for all } s_i \in S_i$$

where $s_{-i}^*$ denotes the strategies of all players other than $i$.

The definition is about stability, not optimality. A Nash equilibrium doesn't claim to be the best outcome — the Prisoner's Dilemma's mutual defection is a Nash equilibrium, and it's the worst joint outcome. It claims to be a *stable* outcome: given that both players are there, neither wants to leave. If you're at a Nash equilibrium and I tell you everyone else's strategy, you have no incentive to change yours.

Nash's theorem guarantees that every finite game has at least one Nash equilibrium, possibly in mixed strategies. The proof uses a fixed-point theorem; the existence result is nonconstructive. It tells you an equilibrium exists without telling you how to find it.

**Best response.** A player's best response is the strategy that maximizes their payoff given the other players' strategies. Nash equilibrium is the profile where everyone is simultaneously playing a best response to everyone else. You can sometimes find equilibria iteratively: start with a guess, compute each player's best response, update, repeat. This converges in some games (potential games) and cycles in others.

**Multiple equilibria.** Many games have more than one Nash equilibrium. The coordination game where two people want to meet has two pure-strategy equilibria (both go to location A, or both go to location B) plus a mixed-strategy equilibrium. Which one gets played? Nash equilibrium is silent on this. Equilibrium selection requires additional theory — focal points, repeated-game history, communication — none of which is in the basic framework.

**Computing equilibria is hard.** For two-player zero-sum games, the minimax theorem (von Neumann, 1928) guarantees a unique equilibrium in mixed strategies, computable by linear programming in polynomial time. For general-sum games, computing Nash equilibria is PPAD-complete — a complexity class believed to lie between polynomial and NP-hard. Real agents in complex strategic settings may not be able to find the equilibrium even if they're perfectly rational. This is not just a theoretical nuisance; it has practical implications for predicting behavior.

---

## Three Games That Cover Most of the Structure

**Prisoner's Dilemma.** Already described. The key property: each player has a *dominant strategy* — one that's best regardless of what the other does. When dominant strategies exist, they're compelling; you should play yours. When they lead to mutual defection, you have the dilemma.

The one-shot Prisoner's Dilemma always ends in mutual defection. The repeated version is different. When the same two players interact repeatedly with no known end date, cooperation can emerge as an equilibrium. The logic: if I defect today, you can punish me in all future rounds. If the future is valuable enough (high discount factor), the expected loss from triggering punishment exceeds the short-term gain from defecting. Tit-for-tat — cooperate first, then do whatever your partner did last round — performed well in Axelrod's tournaments and subsequent variants. Cooperation is not irrational in repeated games; it's the equilibrium of a game with a different structure.

**Battle of the Sexes.** Two people want to spend the evening together but prefer different activities. Both prefer being together over being apart; they disagree on which activity. There are two pure-strategy Nash equilibria (one for each player's preferred activity) and one mixed-strategy equilibrium. The pure equilibria are asymmetric — one player gets their preferred outcome. The mixed equilibrium is symmetric but gives each player a lower expected payoff than either pure equilibrium.

The Battle of the Sexes models any coordination problem where parties have shared interest in agreeing but conflicting preferences over the agreement. Standards battles, joint ventures with asymmetric preferred terms, platform ecosystem decisions. The lesson: when there are multiple equilibria, coordination is the problem, not just optimization.

**Chicken (Hawk-Dove).** Two drivers approach each other on a narrow road. The one who swerves loses face; the one who doesn't wins. If neither swerves, they crash. Pure equilibria: one swerves and one doesn't (two asymmetric equilibria). Mixed equilibrium: each swerves with some probability. The game models brinkmanship, market entry against an incumbent, and any situation where commitment and signaling interact. The strategic insight: credibly committing to not swerving (burning bridges, making the commitment observable) changes the equilibrium. If your opponent believes you cannot swerve, they will.

These three games — along with zero-sum minimax — cover the structural taxonomy that matters in practice. When a new problem arrives, the first question is: which of these shapes does it have?

![Three side-by-side 2×2 payoff matrices for Prisoner's Dilemma,](images/04-game-theory-fig-01.png)
*Figure 4.1 — Three side-by-side 2×2 payoff matrices for Prisoner's Dilemma,*

---

## When Players Have Private Information

The games above assume complete information: all players know the payoff structure. Most real strategic settings involve private information — each player knows something the others don't.

A Bayesian game handles this by giving each player a *type* — their private, payoff-relevant information — drawn from a prior distribution that's common knowledge. A player's strategy is a function from their type to an action. The equilibrium concept becomes **Bayesian Nash equilibrium**: each type's strategy is a best response given the prior over other players' types and the strategies they'll play.

Auctions are the canonical Bayesian game. Each bidder has a private valuation — how much the item is worth to them. The auctioneer doesn't know these valuations; bidders don't know each other's. The auction format determines how bids map to outcomes and payments, and therefore determines what bidding strategy is rational.

**Four auction formats.**

*First-price sealed-bid.* Highest bid wins; pays their bid. Rational bidders shade their bids below their true value — bidding your value guarantees zero surplus. The optimal shade depends on the number of bidders and the prior on valuations.

*Second-price sealed-bid (Vickrey).* Highest bid wins; pays the second-highest bid. This format has a remarkable property: bidding your true value is a dominant strategy. If you bid higher, you might win a lot you'd lose money on. If you bid lower, you might lose an auction you'd have won profitably. Your bid only changes the outcome in cases where it's the decisive one, and in those cases you pay the second-highest bid, not your own. Truth-telling dominates.

*English (ascending).* Open, ascending bids; last bidder standing wins. Strategically equivalent to second-price for private-value bidders — the winner ends up paying just above the second-highest value.

*Dutch (descending).* Price descends from a high level until someone accepts. Strategically equivalent to first-price — the winner pays their bid.

The **Revenue Equivalence Theorem** (Myerson, 1981) shows that under standard conditions, all four formats yield the same expected revenue to the seller. The strategic complexity differs enormously; the revenue doesn't.

| format | who wins | what winner pays | is truth-telling dominant | strategic equivalent |
| --- | --- | --- | --- | --- |
| auction format reference card | four rows (First-price, Second-price | A concrete checkpoint for applying the chapter concept. | A concrete checkpoint for applying the chapter concept. | A concrete checkpoint for applying the chapter concept. |

**VCG: generalizing the second-price principle.** The Vickrey-Clarke-Groves mechanism extends strategy-proofness to multi-item, combinatorial settings. Each winner pays the *externality* they impose on others — the value that other bidders lose because this bidder won. Truthful bidding remains dominant. VCG is used in some spectrum auctions and ad-allocation systems, though its computational complexity and vulnerability to collusion limit its use in practice.

**The revelation principle.** A foundational result in mechanism design: any equilibrium outcome of any mechanism can be implemented by a direct mechanism where players truthfully report their private information. This doesn't mean truth-telling is always easy or practical; it means the space of mechanisms can be analyzed by restricting attention to the truthful ones. Mechanism design — designing the rules of a game to produce the outcome you want — reduces to finding the right direct, truthful mechanism.

---

## Mechanism Design: Playing the Game Backward

All the analysis above asks: given the rules of a game, how will players behave? Mechanism design reverses the question: given the outcome I want, what rules should I design, knowing that players will act strategically?

The auctioneer isn't a bidder. They design the auction. The platform doesn't transact; it sets the rules under which transactions happen. The regulator doesn't produce goods; it sets the constraints under which firms compete. Whenever you're setting the rules rather than playing within them, mechanism design is the relevant framework.

The designer's problem: choose a mechanism (a message space, an allocation rule, a payment rule) that implements the desired outcome as an equilibrium when participants act in their own interests. The constraints are incentive compatibility (no player benefits from lying about their type) and individual rationality (players prefer participating to not participating).

Optimal mechanism design — what mechanism maximizes the seller's revenue, or the social planner's welfare — has clean solutions in simple settings (Myerson's optimal auction for single items) and becomes combinatorially hard in complex ones. The practical upshot: when designing pricing rules, allocation mechanisms, contest structures, or compensation schemes, ask whether the mechanism you've designed gives participants the right incentives, or whether rational participants will find a way to game it.

![Two-column contrast ](images/04-game-theory-fig-02.png)
*Figure 4.2 — Two-column contrast *

---

## Where the Framework Breaks

The Nash equilibrium is a theoretical benchmark. It is not a behavioral prediction.

The framework presumes that all players are perfectly rational, have complete knowledge of the game structure, and have unlimited computational capacity to find their equilibrium strategy. Real agents have none of these in full.

**The Ultimatum Game.** One player proposes a split of ten dollars; the other accepts or rejects. If rejected, both get nothing. Rational-agent prediction: the proposer offers the minimum possible split (one dollar); the responder accepts, since one dollar beats nothing. Experimental result: proposers routinely offer 40–50%; responders routinely reject offers below 25–30%, sacrificing money to punish what they perceive as unfair treatment. The Nash prediction is wrong. The deviation is systematic and replicable across cultures, stakes, and framings.

**Behavioral game theory** studies the gap. Quantal response equilibrium models players as making better responses rather than best responses — they favor better options, but not deterministically. Level-k reasoning models players who think their opponents reason only k steps ahead rather than iterating to full equilibrium. Prospect theory models the asymmetry between losses and gains in payoff evaluation. None of these is the Nash model; all of them improve empirical predictions in specific domains.

**Bounded rationality is the production reality.** Real bidders use heuristics, not equilibrium bidding strategies. Real firms coordinate tacitly through price leadership rather than computing Bertrand equilibria. Real commuters choose routes by habit and observation, not by solving the Wardrop traffic equilibrium. Game theory's value in these settings is not prediction but *design* — if you design a mechanism that's only incentive-compatible when participants are perfectly rational, you've built a fragile mechanism.

**Coordination failure.** Multiple equilibria leave the outcome underdetermined. When players have no way to coordinate on which equilibrium to play, they may get stuck at a worse one — or cycle without converging. Communication, history, social norms, and focal points (prominent, natural-seeming options) determine which equilibrium gets played in practice. The Nash framework has no theory of this; it's doing a different job.

**Misidentifying the game.** The most common failure in applied game theory is not computing the wrong equilibrium — it's modeling the wrong game. A pricing problem modeled as a one-shot game produces different predictions than the same problem modeled as a repeated game with reputation. A platform-pricing problem modeled as "platform vs riders" misses the cross-platform competition and the driver-positioning game that may dominate outcomes in practice. The art is in the modeling, not the computation.

---

## The Capability You Now Have

A problem involving multiple agents with separate objectives — pricing, bidding, coordinating, designing rules — is now a problem you can approach structurally rather than by intuition alone.

You can name the players, their strategies, and their payoffs. You can ask whether the game is zero-sum or general-sum, one-shot or repeated, complete-information or Bayesian. You can find Nash equilibria for simple games by best-response iteration, recognize dominant strategies when they exist, and understand why their existence is both clarifying and, in the Prisoner's Dilemma, damning. You can distinguish the case where you're a player from the case where you're designing the rules, and you know that the second case calls for mechanism design thinking — specifically, whether the rules you're designing give participants the right incentives.

What you should not do is treat Nash equilibrium as a behavioral prediction and be surprised when it's wrong. It's a benchmark, not a forecast. The gap between the benchmark and observed behavior is real, systematic, and analyzable. When the benchmark fails, that failure is information — about the payoffs, the information structure, or the rationality assumptions that don't hold in this particular game.

The Prisoner's Dilemma looks hopeless until you realize it's repeated. The coordination game looks intractable until you notice the focal point. The auction looks complex until you see that the second-price mechanism makes truth-telling dominant. Game theory doesn't always make the problem easier. But it makes the problem *visible* — which is where everything useful starts.

---

## Exercises

### Warm-Up

**1.** Two competing coffee shops on the same block each choose whether to offer a daily discount. If both discount, both earn $200/day. If neither discounts, both earn $300/day. If one discounts and the other doesn't, the discounter earns $400/day and the non-discounter earns $100/day. (a) Write out the 2×2 payoff matrix. (b) Does either player have a dominant strategy? (c) What is the Nash equilibrium, and is it Pareto-optimal? *(Tests: payoff matrix construction, dominant strategy identification, Nash equilibrium, and Pareto comparison — the Prisoner's Dilemma structure in a production context.)*

**2.** Three players simultaneously choose a number from 1 to 10. The winner is the player whose number is closest to two-thirds of the average of all three numbers. (a) If all players choose 10, what is two-thirds of the average? (b) What should each player do if they expect others to play the Nash equilibrium? (c) What does this game reveal about the limits of Nash equilibrium as a behavioral prediction? *(Tests: best-response reasoning, iterated dominance, and the gap between equilibrium and observed play — this is the p-beauty contest, a classic behavioral benchmark.)*

**3.** A seller auctions a single item. Two bidders have private valuations: Bidder A values the item at $80, Bidder B values it at $60. Both valuations are private information. (a) In a second-price sealed-bid auction, what does each bidder bid? What does the winner pay? (b) In a first-price sealed-bid auction, should either bidder bid their true value? Why or why not? *(Tests: dominant-strategy property of second-price auctions; bid-shading logic of first-price auctions.)*

### Application

**4.** Two airlines compete on a route. Each can price high ($400) or low ($250). If both price high, each earns $1M/month. If both price low, each earns $400K/month. If one prices high and the other low, the low-pricing airline earns $1.4M and the high-pricing airline earns $200K. (a) Find the Nash equilibrium. (b) Is this a Prisoner's Dilemma? (c) The airlines operate on this route indefinitely. Under what conditions could they sustain the high-price outcome? Name the strategy that could support it and the condition that makes it work. *(Tests: Nash equilibrium in a business context, Prisoner's Dilemma identification, repeated-game cooperation logic and the discount factor condition.)*

**5.** You are designing a compensation structure for a sales team of ten people. Each salesperson can either work hard (effort = 1) or shirk (effort = 0). If all work hard, total revenue is $1M; if all shirk, $100K. Each person who works hard incurs a personal cost of $20K. Individual contributions are not observable — only total revenue is. (a) Model this as a game and find the Nash equilibrium when each salesperson acts independently. (b) Is this a public-goods game? What structure does it share with the Prisoner's Dilemma? (c) You want to design a compensation rule that makes working hard a dominant strategy. Sketch a mechanism that could achieve this. What information does it require? *(Tests: public-goods game structure, Nash equilibrium in n-player settings, mechanism design under unobservability — the principal-agent problem in compact form.)*

**6.** Two firms simultaneously decide whether to enter a new market. Fixed costs of entry are $500K for each firm. If both enter, each earns $300K in the market (a loss after fixed costs). If one enters and the other doesn't, the entrant earns $800K. If neither enters, both earn $0. (a) Build the payoff matrix. (b) How many Nash equilibria does this game have? (c) If the firms could communicate before deciding, which equilibrium would they likely coordinate on, and what makes it focal? *(Tests: multiple equilibria, equilibrium selection, focal point reasoning, coordination game structure vs. Prisoner's Dilemma.)*

### Synthesis

**7.** A platform runs a keyword ad auction with three advertisers. Their private valuations per click are $10, $7, and $4. There are two ad slots; the top slot gets 100 clicks/day, the bottom slot gets 60 clicks/day. (a) Under a VCG mechanism, compute each winner's payment (the externality imposed on others). (b) Is truth-telling a dominant strategy? Explain why, using the VCG externality logic rather than just asserting the result. (c) The platform considers switching to a first-price auction. What happens to bidding behavior, and what does the Revenue Equivalence Theorem predict about the platform's expected revenue? *(Tests: VCG computation, externality logic, Revenue Equivalence Theorem application, strategic comparison of auction formats.)*

**8.** A biotech firm is deciding whether to publish a research finding before completing a patent application. A competitor may be working on the same finding. Model this as a simultaneous game where both firms choose "publish now" or "wait." (a) Construct a plausible payoff matrix based on the strategic logic of priority (first to publish) versus protection (first to patent). (b) Does the game have a dominant strategy for either player? (c) How does adding incomplete information — neither firm knows how far along the other is — change the analysis? What type of game does it become? *(Tests: game construction from a strategic description, incomplete information framing, Bayesian game identification — requires reasoning without a given payoff matrix.)*

### Challenge

**9.** The following situation is sometimes called a "coordination game with outside options." Two firms can either invest in a joint standard (both must invest for the standard to work) or invest in proprietary technology. If both invest in the joint standard, each earns $10M. If both invest proprietary, each earns $4M. If one invests in the standard and the other goes proprietary, the standard-investor earns $1M and the proprietary firm earns $6M. (a) Find all Nash equilibria, including mixed-strategy equilibria. (b) Rank the equilibria by joint payoff. (c) The firms are approached by a standards body offering to coordinate the outcome for a fee of $500K per firm. Under what conditions should both firms pay the fee? (d) Now suppose the game is repeated indefinitely and the firms have a discount factor of 0.8. Can the jointly optimal equilibrium be sustained without the standards body? Show the calculation. *(Tests: full equilibrium analysis including mixed strategies, coordination failure, mechanism design via a third party, repeated-game sustainability with explicit discount factor arithmetic — requires integrating most of the chapter's tools.)*

---

## LLM Exercise — Chapter 4: A Game-Theoretic Decision

**Project:** *Decision Diary*.

**What you're building this chapter:** A diary entry on one real decision in your life that involves *other agents whose payoffs depend on yours and yours on theirs* — a negotiation, a competitive launch, a bid, an organizational political move, a partnership term.

**Tool:** Claude Project (your *Decision Diary*).

**The prompt:**

```
Chapter 4 entry — Game Theory.

The decision I'm thinking through: [one or two sentences naming a
strategic decision involving other agents. Examples: pricing against
a competitor's anticipated move; bidding in an auction; negotiating
salary or contract terms; deciding whether to publish research before
a competing lab; choosing which feature to ship knowing a competitor
might respond; setting a reserve price; deciding whether to make a
"first move" that signals commitment or reveals information.]

Help me work through this as a game. Resist the temptation to model
the world as if I'm the only decision-maker. The chapter's recognition
pattern is three signals: multiple agents with separate objectives,
equilibrium as the question, or mechanism design.

Walk me through:

1. **Identify the players.** Who are the other agents whose actions
   meaningfully affect the outcome? Be specific. If I'm tempted to
   model "the market" or "the team" as a single rational actor,
   force me to pick one specific entity at a time.

2. **For each player, what are their strategies and payoffs?**
   This is the hardest step — I have to imagine the other side's
   utility function, not just my own. Argue with me if my model of
   the opponent's payoffs sounds suspiciously like what I want
   them to value.

3. **Is this game zero-sum, general-sum, or cooperative?**
   - Zero-sum: my gain is their loss. Negotiation over a fixed pie.
     Apply minimax reasoning.
   - General-sum: both can win or both can lose. Most real
     business situations.
   - Cooperative: we're allowed to make binding agreements.
     Coalition-formation logic applies.

4. **Find the Nash equilibrium (or sketch it).** Is there a strategy
   profile where no one wants to deviate unilaterally? Is there more
   than one equilibrium? Is one of them Pareto-superior? Does the
   game have a dominant strategy I should commit to?

5. **Is this really a mechanism-design problem?** If I'm *setting
   the rules* (designing an auction, a comp structure, a referral
   program, a contest), the question is what rules produce the
   outcome I want given that participants will play strategically.
   This is inverse game theory.

6. **Surface the misconception I'm at risk of.** The chapter names
   "Game theory always predicts rational behavior." Am I
   over-rationalizing my opponent? Are they actually going to do
   something the equilibrium model treats as off-path because of
   pride, anger, coordination failure, or genuine uncertainty
   about my type?

7. **Are auction or VCG insights relevant?** If the decision is
   "what price should I set in this auction" or "what bid should
   I submit," the second-price / VCG analysis from the chapter
   may give a clean recommendation.

Output: a structured diary entry. Headings: *The decision*,
*Players*, *Strategies and payoffs*, *Game type*, *Equilibrium
analysis*, *Mechanism-design angle (if any)*, *Where my
opponent-model is shaky*, *What I'll do next*, *What would change
my mind*, *Outcome (to fill in later)*.
```

**What this produces:** A diary entry that explicitly models the other agents, names the equilibrium, and identifies whether you've been over- or under-modeling the rational-actor assumption. The most useful output is usually the moment you realize the "opponent" is acting on a different payoff function than you assumed.

**How to adapt this prompt:**

- *For your own project:* The system prompt personalizes it. If the decision involves several agents, work through them one at a time rather than collapsing them into "the other side."
- *For ChatGPT / Gemini:* Both work. The 2×2 normal-form matrix is often a useful diagrammatic step; ask either model to lay it out as a markdown table.
- *For Claude Code:* Not the fit for this entry, though if your game is 2-player normal-form, Claude Code can compute Nash equilibria with `nashpy` and produce a payoff matrix visualization. Useful as a sidecar to the entry.
- *For a Claude Project:* Native fit. The project will notice if you systematically misjudge opponent rationality — a pattern that becomes legible across multiple game-theoretic entries.

**Connection to previous chapters:** Bayesian games (Chapter 1) come up when players have private information about each other's types. The bandit framing (Chapter 3) carries over for repeated games — but the chapter is careful to flag full-RL territory as out of scope.

**Preview of next chapter:** Chapter 5 (Scheduling) returns to single-agent territory but adds the brutality of finite resources and deadlines. Engineering capacity, sprint planning, when to ship — anything where capacity is the bottleneck.

---

## AI Wayback Machine

The ideas in this chapter didn't appear from nowhere. **Elinor Ostrom** spent decades collecting field data on how communities sustainably manage shared resources — pastures, fisheries, irrigation systems — and built a game-theoretic account of when commons survive without privatization or top-down regulation. She won the 2009 Nobel Prize in Economics, the first woman to do so.

**Run this:**

```
Who was Elinor Ostrom, and how does her game-theoretic analysis of
common-pool resources connect to the cooperation, equilibrium, and
repeated-game concepts we covered in this chapter? Keep it to three
paragraphs. End with the single most surprising thing about her
career or ideas.
```

→ Search **"Elinor Ostrom"** on Wikipedia. See what the model got right, got wrong, or left out.

**Now make the prompt better.** Try one of these:

- Ask it to translate one of Ostrom's eight design principles for stable commons into the language of repeated-game equilibria.
- Ask it to compare Ostrom's empirical fieldwork with the formal game theory in this chapter — when do they reach the same conclusion?

What changes? What gets better? What gets worse?

## Prompts

Use these prompts with Claude to generate interactive D3 v7 versions of the
figures in this chapter. Each produces a standalone HTML file you can open
in a browser and modify freely.

**Prerequisites:** Load `brutalist/CLAUDE.md` and `brutalist/DESIGN.md` into
your Claude project context before using these prompts. They define the stack,
naming conventions, color system, and typography the figures use.

---

### Figure 4.1 — Three side-by-side 2×2 payoff matrices for Prisoner's Dilemma,

Create a standalone D3 v7 HTML file for Figure Three side-by-side 2×2 payoff matrices for Prisoner's Dilemma,. Use the CDN https://cdnjs.cloudflare.com/ajax/libs/d3/7.9.0/d3.min.js, inline CSS, ResizeObserver redraw, SVG role="img", aria-labelledby, title, and desc. Build the figure from this structural brief: three side-by-side 2×2 payoff matrices for Prisoner's Dilemma, Battle of the Sexes, and Chicken — each with Nash equilibria marked, dominant strategies annotated where they exist, and a one-line label of the strategic structure (Dominant strategy / Coordination / Commitment); reader should be able to visually compare the three structures and see what makes each distinct. Use the described data shape and labels; when exact values are not supplied, use plausible illustrative values that preserve the relationships in the brief. Use a zero baseline for bars or areas, direct labels where possible, and annotations named in the brief. Use only DESIGN.md color variables and the required serif/mono font split.

> Reference implementation: `d3/04-game-theory-fig-01.html`

---

### Figure 4.2 — Two-column contrast 

Create a standalone D3 v7 HTML file for Figure Two-column contrast . Use the CDN https://cdnjs.cloudflare.com/ajax/libs/d3/7.9.0/d3.min.js, inline CSS, ResizeObserver redraw, SVG role="img", aria-labelledby, title, and desc. Build the figure from this structural brief: two-column contrast — left column "Playing the game" (you are a player, given the rules, optimize your strategy, Nash equilibrium is the goal); right column "Designing the game" (you are the mechanism designer, you choose the rules, equilibrium of your design is the tool, incentive compatibility is the constraint); reader should see the inversion clearly — same strategic logic, opposite vantage point. Use the described data shape and labels; when exact values are not supplied, use plausible illustrative values that preserve the relationships in the brief. Use a zero baseline for bars or areas, direct labels where possible, and annotations named in the brief. Use only DESIGN.md color variables and the required serif/mono font split.

> Reference implementation: `d3/04-game-theory-fig-02.html`
