# Game Theory

## TL;DR

Game theory studies decisions where outcomes depend on what *other agents* choose. Reach for this chapter when a problem involves two or more decision-makers whose payoffs depend on each other — pricing against competitors, bidding in auctions, designing platform incentives, modeling network congestion, anticipating responses to a policy change. After consulting it, you can model a strategic interaction as a game, identify Nash equilibria for simple games, distinguish cooperative from non-cooperative settings, sketch second-price and VCG auctions, and recognize when game-theoretic reasoning applies versus when it's overkill.

## Recognition pattern

Three signals.

*Multiple agents with separate objectives.* Decisions are not made by one optimizer; multiple parties act, each with their own payoffs. Pricing against a competitor, bidding against rivals, choosing a transit route alongside other commuters, deciding whether to publish an exploit before others — all are games. Where there's interdependence and separate utilities, game theory is the framework.

*Equilibrium is the question.* You want to predict the stable outcome of strategic interaction, not just analyze a single agent's optimization. The Nash equilibrium asks: given everyone else's behavior, no one wants to deviate. The equilibrium is the joint state where no player has a unilateral improvement.

*Auction or mechanism design.* You're designing rules under which agents will act strategically. The auctioneer doesn't bid; they design the auction. The platform doesn't transact; they set the rules. Mechanism design is the inverse-game-theory move: what rules produce the outcome you want, given that participants will act in their own interest?

A signal game theory is *not* the right tool: a single agent making a decision against nature (no opponent). Decision theory under uncertainty (Chapter 1, Chapter 2) is the right framing. Game theory adds machinery for opponents; if there's no opponent, the machinery is decoration.

The misconception engaged in §10 is the one that breaks practitioner intuition: "Game theory always predicts rational behavior." The Nash equilibrium presumes rationality; real agents are boundedly rational. Behavioral game theory studies where the predictions break, and the gap between the rational-agent model and observed behavior is itself analyzable.

## What you need to know first

This chapter assumes basic probability (Chapter 1) and combinatorial reasoning (Vol. 1 Chapter 2 for Big O on game-tree analysis). Bayesian games use Bayesian updating from Chapter 1. For evolutionary game theory and population dynamics, the chapter touches but defers; for stable-matching mechanisms, see Chapter 6.

## Players, strategies, payoffs — the model

A game has three components.

**Players.** The decision-makers. Sometimes called agents.

**Strategies.** The available actions for each player. A *pure strategy* is a single action; a *mixed strategy* is a probability distribution over actions.

**Payoffs.** Each player's utility for each combination of strategies. Encoded in a payoff matrix (two-player) or payoff function (general).

The simplest representation is the **normal form** — a matrix with players' strategies on rows and columns, payoffs in the cells. Each cell is a tuple `(payoff to player 1, payoff to player 2)`.

Two ways to classify games.

**Cooperative vs non-cooperative.** Cooperative games allow binding agreements; non-cooperative games do not. Most production game theory is non-cooperative — players cannot enforce promises.

**Zero-sum vs general-sum.** Zero-sum: one player's gain is exactly another's loss. Chess, poker (one round), some adversarial settings. Most economic games are general-sum — everyone can benefit (cooperation) or everyone can lose (war).

**Information structure.** Complete information — all players know the payoff structure. Incomplete information — players have private information (their type, their preferences). Bayesian games handle incomplete information by treating private types as random variables with prior distributions.

## Nash equilibrium and best response

A **Nash equilibrium** is a strategy profile where no player gains by unilaterally changing strategy, given the others' choices.

Formally, `(s_1*, s_2*, ..., s_n*)` is a Nash equilibrium if for every player `i`:

```
u_i(s_i*, s_{-i}*) ≥ u_i(s_i, s_{-i}*)   for all s_i in S_i
```

where `s_{-i}*` denotes the strategies of all players other than `i`.

**Existence.** Every finite game has at least one Nash equilibrium in mixed strategies (Nash 1950) [verify]. Pure-strategy equilibria may not exist; mixed-strategy equilibria always do.

**Computation.** For two-player zero-sum games, mixed-strategy Nash equilibria are computable in polynomial time via linear programming (Vol. 1 Chapter 13). For general-sum games, computing Nash equilibria is PPAD-complete (Daskalakis-Goldberg-Papadimitriou 2009) [verify] — believed hard, though no NP-hardness result and not in P.

**Best response dynamics.** An iterative algorithm for finding Nash equilibrium: each player updates their strategy to the best response given others' current strategies. Converges to Nash for some game classes (potential games), cycles in others.

**Multiplicity of equilibria.** Many games have multiple Nash equilibria. The Battle of the Sexes has two pure equilibria plus a mixed one; coordination games can have many. Equilibrium *selection* — predicting which equilibrium gets played — requires additional machinery (focal points, repeated-game considerations, behavioral assumptions).

## Classical games — three patterns

**Prisoner's Dilemma.** Two players, each with two strategies (Cooperate, Defect). Payoffs satisfy `T > R > P > S` and `2R > T + S`. The unique Nash equilibrium is mutual defection (D, D), even though mutual cooperation (C, C) yields higher total payoff. The dilemma: rational individual play produces collectively-suboptimal outcomes.

The Prisoner's Dilemma models price wars, arms races, public-goods provision, climate-change negotiation. The repeated version (iterated Prisoner's Dilemma) admits cooperative equilibria via reputation and reciprocity (tit-for-tat dominated Axelrod's tournament; subsequent variants are also robust) [verify].

**Battle of the Sexes.** A coordination game with two pure-strategy equilibria. Both players prefer being together to being alone but disagree on the joint activity. The mixed equilibrium randomizes; the pure equilibria favor one player or the other. Models any joint-decision setting where parties have shared interest in coordination but conflicting preferences over coordination point.

**Chicken (Hawk-Dove).** Two players each prefer the other to "swerve." Pure equilibria where one swerves and the other doesn't (asymmetric); mixed equilibrium with both swerving probabilistically. Models brinkmanship, market entry against an incumbent, signaling games where one party must back down.

These three structures cover much of what game theory's normal form can do. Recognizing your specific situation as one of them — or as a hybrid — is the first analytic step.

## Information and Bayesian games

When players have private information, the game becomes Bayesian. Each player has a *type* (their private payoff-relevant information) drawn from a prior distribution. Strategies map types to actions.

**Bayesian Nash equilibrium.** A strategy profile where each type's strategy is a best response given the prior over other players' types and the others' strategies.

**Signaling and screening.** Asymmetric-information games where one player has information the other lacks. Signaling: the informed party takes a costly action that reveals their type (education as a signal of productivity, advertising as a signal of quality). Screening: the uninformed party offers a menu designed so that different types self-select into different options (insurance contracts, menus of pricing tiers).

**Auctions as Bayesian games.** Bidders have private valuations. The auction format determines bidding strategies. The four canonical formats:

- **First-price sealed-bid.** Highest bid wins; pays their bid. Bidders shade their bids below their true value (bidding their value would yield zero surplus).
- **Second-price sealed-bid (Vickrey).** Highest bid wins; pays the second-highest bid. Strategy-proof: bidding your true value is dominant. The winner's expected payment equals their expected bid in the first-price auction (Revenue Equivalence Theorem, Myerson 1981) [verify].
- **English (ascending) auction.** Open, ascending bids until one bidder remains. Strategically equivalent to second-price sealed-bid for private-value bidders.
- **Dutch (descending) auction.** Price descends until a bidder accepts. Strategically equivalent to first-price sealed-bid.

**Vickrey-Clarke-Groves (VCG).** Generalizes the second-price principle to combinatorial allocation: each winner pays the externality they impose on others (the value lost to others by their winning). Strategy-proof; truthful bidding is a dominant strategy. Used in spectrum auctions and some ad-allocation systems [verify].

**The revelation principle.** Without loss of generality, restrict attention to direct mechanisms where players truthfully report their type. Any equilibrium outcome of any mechanism can be implemented by a direct, truthful mechanism. Reduces mechanism design to a tractable problem.

## Decision rules

| Situation | Tool |
| --- | --- |
| Single decision-maker, no opponent | Decision theory (Chapter 1, 2), not game theory |
| Two players, finite strategies | Normal-form game; find Nash via best response |
| Multiple players, sequential moves | Extensive-form game; backward induction |
| Players have private information | Bayesian game |
| One-shot game where rational agents would defect | Prisoner's Dilemma — accept the equilibrium or change the game |
| Repeated interaction with reputation | Repeated game; cooperation possible via tit-for-tat or trigger strategies |
| You're designing the rules, not playing | Mechanism design |
| Auction with private values, want strategy-proofness | Second-price (Vickrey) for single item; VCG for combinatorial |
| Behavioral deviation from Nash matters | Behavioral game theory; quantal response, level-k reasoning |
| Population-level dynamics | Evolutionary game theory; replicator dynamics |
| Coordination needed | Coordination game; focal points, communication |
| Dynamic pricing against competitor | Repeated game; commitment devices may dominate myopic best response |

## Worked example — pricing on a two-sided platform

A ride-sharing platform sets prices that affect both drivers (supply) and riders (demand). Surge pricing increases prices when demand exceeds supply; the price increase incentivizes more drivers and rations rides among riders.

The pricing decision is a multi-player game. Three perspectives change the model.

**Perspective 1: Platform vs riders and drivers separately.** The platform sets the price; riders decide whether to take a ride at the price; drivers decide whether to drive at the implied wage. Each rider and driver is a single-agent decision-maker against the platform's posted price. The platform optimizes total welfare or platform revenue, treating rider and driver demand as functions of price.

This is the simplest model and matches early surge-pricing analyses. The platform plays optimally against aggregated demand and supply curves.

**Perspective 2: Platform vs competitor platform.** The platform competes with another ride-sharing service. Each platform's pricing decision affects the other's market share. This is a duopoly pricing game — Bertrand competition with differentiated products. Nash equilibrium typically involves prices above marginal cost (because differentiation softens competition) but below monopoly prices.

The model adds a second layer: the platform's optimal surge level depends on what the competitor charges. Surge wars (mutual price increases when both platforms surge) and surge gaps (one platform surges, the other doesn't) are visible in real data.

**Perspective 3: Drivers as strategic agents.** Drivers can choose where to position themselves to anticipate surge. If many drivers expect a neighborhood to surge, they all drive there, and the surge doesn't materialize. Drivers' positioning is a coordination game — too many drivers in one place wastes everyone's time.

This is the most subtle model and the closest to current production reality. Driver positioning is a population-level coordination problem; the platform's pricing affects the equilibrium.

**Auctions on the same platform.** Some ride-sharing platforms use auction-like mechanisms for ride matching: drivers can bid on rides, riders can offer prices, the platform matches based on bid/offer prices. This is a double auction — a Bayesian-game with private values on both sides. VCG-style mechanisms are strategy-proof but rarely used because they don't extract revenue; the platform usually uses simpler mechanisms with revenue properties.

**Ad-auction reserve prices.** A separate but related game. The platform runs an auction for ad slots adjacent to ride-matching. Reserve prices (minimum bids) are a strategic choice. Setting them too high reduces participation; setting them too low loses revenue from high-value bidders. The optimal reserve depends on the bid distribution and is computable from the Myerson optimal-auction framework (Myerson 1981) [verify].

**The lesson.** The same situation — "the platform sets prices" — supports three different game-theoretic models, each with different equilibria, predictions, and policy implications. The art of applied game theory is recognizing which model captures the relevant strategic dynamics. A model that ignores driver positioning will mispredict equilibrium outcomes; a model that ignores cross-platform competition will overestimate the platform's pricing power. Real-world game-theoretic analysis stacks models, each capturing one dynamic.

The 2019 Google ads change — moving display ads from second-price to first-price auctions — illustrates the practitioner stakes [verify]. Second-price auctions are theoretically strategy-proof; first-price auctions require bidders to shade their bids and create complexity for advertisers. Google's stated reason: transparency and uniformity with header bidding ecosystems. The strategic environment changed; bidder behavior had to adapt. Production game theory is dynamic.

## Failure modes — when "game theory always predicts rational behavior" misleads

The misconception engaged: "Game theory always predicts rational behavior."

Three failures of this reading.

**Game theory's predictions are conditional on rationality assumptions.** Nash equilibrium presumes that all players are perfectly rational, have perfect information about the game (or known priors over types in Bayesian games), and have unlimited computational capacity. Real agents have none of these in full. The Nash equilibrium is a *theoretical benchmark*, not a behavioral prediction.

**Behavioral game theory studies the gap.** When experimental subjects play the Ultimatum Game, the rational-agent prediction is that the proposer offers the smallest possible split and the responder accepts. In practice, responders reject offers below ~25–30% of the pie (sacrificing money to punish unfair offers) and proposers, anticipating this, offer 40–50% on average [verify]. The Nash prediction is wrong; the deviation is systematic and analyzable. Behavioral models — quantal response equilibrium, level-k reasoning, prospect theory — capture the patterns.

**Bounded rationality is the production reality.** Real bidders in auctions don't compute equilibrium strategies; they use heuristics. Real consumers don't optimize over choice sets; they satisfice. Real firms don't reach Bertrand equilibria; they engage in tacit coordination, price-leadership, and other quasi-cooperative behaviors. Game theory provides the framework; behavioral economics provides the corrections.

**Coordination failure.** Multiple equilibria leave the prediction underdetermined. Without a focal point or coordinating device, players may end up at a worse equilibrium than the joint optimum. Behavior in coordination games is often guided by salience, history, or communication — none of which the Nash framework captures directly.

**Equilibrium computation is hard.** Computing Nash equilibrium is PPAD-complete in general. Even if agents are perfectly rational, they may not be able to *find* the equilibrium. This is a theoretical-computer-science result with practical implications: in complex strategic environments, the equilibrium concept may not predict behavior because no agent can compute it.

**Repeated games change everything.** One-shot Prisoner's Dilemma predicts mutual defection. Repeated Prisoner's Dilemma admits cooperation via reputation. Real-world strategic interactions are usually repeated; one-shot analyses may misjudge the steady state.

**Misidentifying the game.** A practitioner who models "the platform vs riders" misses the platform-vs-competitor and driver-positioning games that drive observed behavior. The right model is rarely the simplest model; finding it is craft.

The corrective heuristic: state the game-theoretic framework as a *tool* for reasoning about strategic interaction, not as a *prediction* about behavior. Use Nash equilibrium as a benchmark; check predictions against data; layer in behavioral or computational realism when the benchmark fails.

## Cross-references

For Bayesian games and the prior-based reasoning underlying mechanism design, see Chapter 1. For optimal stopping in dynamic strategic settings, see Chapter 2. For multi-armed bandits as a single-agent decision problem (no opponent), see Chapter 3. For stable matching as a game-theoretic mechanism, see Chapter 6. For network games and coordination on graphs, see Chapter 8. For LP and polynomial-time solution of zero-sum games, see Vol. 1 Chapter 13. For computational complexity of equilibrium computation, see Vol. 1 Chapter 10.

## Companion-page handoffs

Equilibrium-computation tools (Gambit, Nashpy); auction-mechanism reference card (first-price, second-price, English, Dutch, VCG); behavioral game theory primer (quantal response, level-k); evolutionary dynamics simulator; pointer to magazine for dynamic-pricing deep-dives. Available at bearbrown.co/algorithms-by-bear-vol2/chapter-4.

## What this chapter does not enable

This chapter does not give a treatment of cooperative game theory in depth — coalition formation, the core, the Shapley value as a cost-allocation method are sketched but not developed. Evolutionary game theory is touched (ESS, Hawk-Dove) but not extended to replicator dynamics on networks. Dynamic games with continuous time and continuous strategies (differential games, mean-field games) are out of scope; for those, consult specialized references in mathematical economics.

## Capability statement

You can now model a strategic interaction as a game, identify Nash equilibria for simple games, distinguish cooperative from non-cooperative, recognize zero-sum from general-sum, apply minimax for adversarial games, sketch second-price and VCG auctions when needed, and avoid the failure mode of treating Nash equilibrium as a behavioral prediction. The next time a problem arrives that involves multiple agents with their own objectives — pricing, bidding, coordinating, designing rules — the path from problem to game-theoretic model is in your hands.


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
