# Chapter 7 — Randomness and Networking

*Why giving up control of where a packet goes can make the whole network work better.*

---

In 1982, Leslie Valiant asked a question that sounds perverse: what if, instead of routing packets along the shortest path, you routed them through a randomly chosen intermediate node first?

The obvious objection is that this makes every route longer. If you want to get from New York to Los Angeles, detouring through Houston adds distance. On a lightly loaded network, shortest-path wins. But Valiant wasn't thinking about lightly loaded networks. He was thinking about hypercubes under adversarial load — the kind of network where an adversary who knows your routing algorithm can craft traffic patterns that funnel every packet through the same bottleneck nodes, grinding the whole system to a halt.

Under that adversarial load, shortest-path can be catastrophically bad. Because every source routing to the same destination takes the same shortest path, the nodes on that path become hotspots. Add enough demand, and those hotspots saturate. The network's throughput collapses far below what its total capacity would suggest.

Valiant's insight: randomize the intermediate node. Instead of routing from source $s$ to destination $t$ directly, choose a random intermediate node $v$, route $s \to v \to t$. The path is longer, but now the load is spread. No adversary can predict which intermediate nodes get traffic, because the choice is random. With high probability, no node becomes a hotspot. On an $n$-node hypercube, Valiant's scheme achieves $O(\log n)$ routing time even under the worst-case adversarial permutation — where direct shortest-path routing would take $O(n)$.

The counterintuitive principle is the one this whole chapter turns on: randomness, applied to networked systems, often outperforms determinism — not despite its inefficiency in individual cases, but because of the aggregate robustness that unpredictability provides.

---

## Two Kinds of Randomness

Before going further, a distinction that's easy to get wrong.

Networked systems use randomness in two fundamentally different ways, and confusing them is a production security failure waiting to happen.

**Algorithmic randomness** is randomness for performance. Pseudorandom number generators seeded per-process — Mersenne Twister, xorshift, PCG — used for routing decisions, load balancing, hash-based assignment. Fast, reproducible given the seed, adequate for non-security-sensitive uses. An adversary who knows your algorithm and seed can predict every "random" choice you make, but for load balancing or sampling that predictability doesn't matter.

**Cryptographic randomness** is randomness for security. Cryptographically secure pseudorandom number generators — `/dev/urandom`, `BCryptGenRandom`, Python's `secrets` module — used for keys, tokens, nonces, anti-replay identifiers. Unpredictable to a determined adversary even knowing the algorithm, because the seed itself is kept secret and drawn from physical entropy sources.

The rule is simple and non-negotiable: wherever the security of a system depends on an adversary not predicting your random choices, use cryptographic randomness. Using `Math.random()` to generate session tokens is not a performance-vs-security tradeoff — it's a security failure.

With that distinction held, everything else in this chapter is about algorithmic randomness applied to network problems, where the goal is performance, robustness, and coordination.

---

## Random Walks on Graphs

The simplest randomized process on a network is the random walk.

Start at some vertex. At each step, move to a uniformly random neighbor. Repeat. The sequence of visited vertices is a stochastic process. On connected, non-bipartite graphs, this process has a stationary distribution — a probability over vertices that the walker converges to, regardless of starting point. For an undirected graph with $n$ vertices and $m$ edges, the stationary probability at vertex $v$ is:

$$\pi(v) = \frac{\deg(v)}{2m}$$

High-degree vertices are visited more often. A page linked to by many other pages gets a higher stationary probability than one linked to by few. This is, essentially, PageRank.

![Example graph (6–8 nodes, varying degree) with each](images/07-randomness-and-networking-fig-01.png)
*Figure 7.1 — Example graph (6–8 nodes, varying degree) with each*

The original Google algorithm formalizes the random walk with one modification: with probability $1 - d$ (the "damping factor," typically $d = 0.85$), the walker teleports to a uniformly random page rather than following a link. This ensures the walk doesn't get trapped in link sinks or disconnected components. The PageRank of a page is its stationary probability under this teleporting walk. Google announced PageRank's use in 1998; its computational dominance has since given way to learned signals, but the random walk as a centrality measure remains a foundational concept.

**Mixing time.** How long does the walk need to run before its distribution is close to stationary? The answer is the *mixing time* — the number of steps until the walker's distribution is within $\varepsilon$ in total variation distance from $\pi$. Mixing time depends on the graph's spectral structure, specifically the gap between the first and second eigenvalues of the walk's transition matrix. Well-connected graphs mix in $O(\log n)$ steps. Graphs with bottlenecks — a narrow bridge between two dense clusters — mix slowly because the walker takes a long time to cross.

This matters for any algorithm that uses random walks for sampling. If you're estimating properties of a large graph by running a random walk and observing visited vertices, the accuracy of your estimate depends on the walk having mixed. On a scale-free network with heavy-tailed degree distribution, mixing can be slow. The sample is biased toward high-degree vertices, and that bias is computable and correctable — but only if you know the walk has run long enough.

**Graph algorithms via random walks.** Beyond PageRank, random walks underlie a family of graph algorithms that would be computationally intractable by exhaustive methods.

Network embedding — learning vector representations of vertices for use in machine learning — starts from random walks. The DeepWalk algorithm generates random walk sequences from a graph, treats them as "sentences," and applies word2vec to learn vertex vectors that capture neighborhood structure. Node2vec generalizes this with biased walks that interpolate between breadth-first and depth-first exploration. Both approaches became standard tools for recommendation, link prediction, and community detection in large graphs.

Spectral clustering uses the relationship between random walk dynamics and graph community structure. The eigenvectors of the walk's transition matrix capture the directions along which the walk mixes slowly — which correspond, roughly, to the boundaries between communities. Random walks, in this sense, reveal graph structure through their dynamics rather than their topology.

---

## Consistent Hashing: Randomness for Distributed Storage

Routing data to servers has the same problem as routing packets through a network: deterministic methods break under change.

The naive approach to distributing keys across $N$ servers is to assign key $k$ to server `hash(k) mod N`. This is deterministic, uniform in expectation, and completely brittle. When a server joins or leaves, $N$ changes, and almost every key remaps to a different server. A cache with 100 nodes loses nearly its entire cached content on every node change. In a live production system, this is a traffic disaster — the cache is empty, every request falls through to the database, and the database collapses under the sudden load.

Consistent hashing solves this by mapping both keys and servers onto a circle — a 64-bit hash space with arithmetic modulo $2^{64}$. Each key is owned by the first server clockwise from its hash position. When a server joins, it takes ownership only of keys in the arc between its position and the previous server clockwise. When a server leaves, its keys redistribute only to the next server clockwise. In both cases, $O(K/N)$ keys move — where $K$ is the total number of keys and $N$ is the server count — regardless of cluster size. The rest of the data is untouched.

This was first published by Karger et al. in 1997, and it's now used in Cassandra, DynamoDB, memcached, and most production distributed key-value systems in existence.

![Consistent hashing ring diagram ](images/07-randomness-and-networking-fig-02.png)
*Figure 7.2 — Consistent hashing ring diagram *

**The virtual node problem.** With $N$ servers placed randomly on the circle, the arc lengths aren't equal — they're exponentially distributed. The unluckiest server gets an arc about $O(\log N)$ times the average, meaning it handles far more than its fair share of keys. This load imbalance grows with $N$.

The fix is virtual nodes: each physical server is assigned multiple positions on the circle, placed independently at random. With 100–500 virtual nodes per physical server, the aggregate load per server concentrates around $1/N$ by a balls-and-bins argument. The random placement of virtual nodes is precisely what makes the load balance — without it, the distribution is skewed. Randomness is not just implementation detail here; it's the mechanism that makes the algorithm work.

**Hot keys and the power of two choices.** Even with consistent hashing, some keys are read far more than others. A celebrity's profile, a viral post, a popular product — these create load spikes on whatever server happens to own them. The solution is replication with random routing: each key is replicated to multiple servers; reads can go to any replica; the request goes to whichever replica is less loaded at the moment.

The "power of two choices" is the canonical analysis of this idea. Choose two servers uniformly at random; send the request to the less-loaded one. This is exponentially better in load balance than choosing one server at random, and competitive with the optimal assignment that requires global knowledge of all server loads. The insight is a general principle: two random samples plus a local comparison is dramatically better than one random sample, even though neither involves global coordination.

![Bar chart comparing maximum load per server across](images/07-randomness-and-networking-fig-03.png)
*Figure 7.3 — Bar chart comparing maximum load per server across*

---

## Gossip Protocols: Randomness for Distributed Coordination

Distributing information through a network without a central coordinator is the coordination problem in distributed systems. A naive approach — broadcast to all nodes — is expensive and brittle. A hierarchical approach — propagate through a tree — creates bottlenecks and single points of failure. Gossip protocols solve this with randomness.

The mechanism is simple. Each node maintains some state. Periodically, each node picks a random peer and exchanges state. Updates propagate epidemically: if node $A$ has an update and contacts node $B$, now $B$ has it. $B$ contacts node $C$, now $C$ has it. In each round, the number of nodes that lack the update decreases by at least a constant factor in expectation. With high probability, all $n$ nodes converge to consistent state in $O(\log n)$ rounds.

The analysis uses concentration inequalities. In round $k$, if $i$ nodes have the update, each of those $i$ nodes contacts a random peer. The expected number of newly-informed nodes is at least $i \cdot (n-i)/n$ — the chance that an informed node contacts an uninformed one. When $i$ is small relative to $n$, this grows exponentially fast. When $i$ is close to $n$, it slows, but the last few uninformed nodes are caught quickly because many informed nodes are reaching out. Total convergence in $O(\log n)$ rounds follows from a straightforward induction.

Gossip was analyzed as a protocol in Demers et al. in 1987. The variants differ in what gets exchanged.

*Anti-entropy* gossip exchanges full state periodically — not just recent updates, but everything. This is bandwidth-expensive but guarantees eventual consistency even if nodes miss earlier rounds. Cassandra uses this for cluster membership and failure detection.

*Rumor-mongering* gossip pushes only fresh updates, and stops pushing a given update after it has circulated enough times. More efficient for high-volume, short-lived updates; doesn't guarantee full convergence the way anti-entropy does.

Production systems typically combine both: rumor-mongering for fast propagation of fresh updates, anti-entropy for catching any node that missed something.

![Line chart showing gossip convergence ](images/07-randomness-and-networking-fig-04.png)
*Figure 7.4 — Line chart showing gossip convergence *

The broader pattern: when global coordination is too expensive and a small inconsistency window is acceptable, gossip provides eventual consistency at almost no coordination overhead. Each node needs to know only that it should contact a random peer periodically — not which peer, not in what order, not who is the current leader.

---

## When Shortest-Path Loses

The Valiant routing insight is worth dwelling on, because it contradicts the intuition most engineers carry.

Shortest-path routing is optimal for a single packet on an unloaded network. The objection to randomized routing is valid in that regime: the detour through an intermediate node wastes capacity.

But networks are not single packets on unloaded infrastructure. They're many packets simultaneously, on infrastructure that saturates.

Consider what happens when all sources route to the same destination via the shortest path. The nodes on that shortest path receive traffic from every source. They saturate. The nodes on other paths receive nothing. This is the adversarial permutation problem: an adversary who knows the routing algorithm can craft traffic that concentrates all load on a small subset of nodes, driving them to saturation while leaving the rest of the network idle.

Valiant randomization defeats the adversary by making each route unpredictable. If source $s$ chooses a random intermediate $v$ before routing to $t$, an adversary cannot predict which path the packet takes — because $v$ is chosen after the adversary has committed to the traffic pattern. Load spreads across the network regardless of the adversary's strategy. The worst-case throughput under Valiant routing is $O(\log n)$ for hypercubes; the worst-case throughput under deterministic shortest-path routing is $O(n)$, because a single adversarial permutation can concentrate all traffic on one path.

The same logic applies to load balancers. A round-robin balancer cycling through $N$ servers can be beaten by an adversary who times requests to hit the same server every cycle. Random load balancing has no such vulnerability — the next server is chosen at random, and no adversary can predict it.

The principle is general: deterministic algorithms expose a fixed attack surface; randomized algorithms dissolve it. When the adversary is an actual adversary — a malicious actor, a DDoS attacker, a Byzantine node — randomization is often the only defense. When the "adversary" is simply a load distribution that happens to be worst-case for your deterministic method, randomization provides robustness at the cost of slight average-case inefficiency.

Shortest-path is the right tool when load is predictable, skew is absent, adversaries don't exist, and latency is paramount. That describes some systems. It doesn't describe most production distributed infrastructure, which operates under unpredictable load, hot keys, hardware failures, and occasionally adversarial traffic.

---

## Where the Framework Breaks

Randomization in networked systems has its own failure modes.

**Algorithmic randomness in security-sensitive contexts.** The most consequential failure mode: generating session tokens, API keys, or cryptographic nonces with a PRNG rather than a CSPRNG. A PRNG is seeded from a small entropy source — often process ID, timestamp, or a combination. An attacker who can observe enough outputs can reconstruct the seed and predict all future outputs. This has been exploited in production systems. The rule is simple; the failure is using the wrong tool because they both feel like "random numbers."

**Forgetting reproducibility.** Randomization makes production bugs harder to reproduce. If a distributed system routes requests randomly and a bug manifests only on one routing path, reproducing the bug requires hitting the same random choices. The fix is mundane but essential: log the random seed at the moment of each decision, and include it in observability infrastructure. Deterministic replay should be possible given the logs.

**The power of two choices requires fresh load information.** The two-choice load balancer sends requests to the less-loaded of two randomly chosen servers. But "less loaded" requires knowing the current load of both servers. If the load information is stale — because load reports are batched, delayed, or cached — the algorithm degrades toward pure random selection. Real systems need to bound the staleness of load reports for the power-of-two guarantee to hold.

**Slow mixing on poorly-connected graphs.** Random walk algorithms assume mixing time is short. On scale-free networks with heavy-tailed degree distributions, or on graphs with structural bottlenecks, mixing is slow. PageRank on a graph with near-disconnected components converges slowly. A network sampler on a graph with bridge nodes gives a biased sample of the components on each side. The mixing time needs to be estimated before the random walk result is trusted; on structurally complex graphs, a random walk may need to run far longer than intuition suggests.

**Cache locality vs. random routing.** Pure random routing across replicas destroys session affinity. If a user's session data is cached on one node and warmed from their request history, routing their next request to a random replica means a cold cache hit. Production systems use affinity-aware random routing — random across replicas, but consistent for a given session ID. The design requires both mechanisms working together.

---

## The Capability You Now Have

The next time a distributed systems problem involves load balancing, state propagation, or large-graph analysis, you have a framework for deciding whether randomization helps and which kind to reach for.

Consistent hashing with virtual nodes for sharding — when keys need to redistribute gracefully as the server pool changes. The power of two choices for load balancing — when hot keys or skewed load defeats uniform assignment. Gossip protocols for eventual consistency — when global coordination is too expensive and a short inconsistency window is acceptable. Valiant routing or random selection for adversarial robustness — when a deterministic method exposes a fixed pattern that can be exploited.

In each case, the randomness is not imprecision or sloppiness. It's a deliberate design choice that trades average-case optimality for worst-case robustness. The adversary can't concentrate load on a path they can't predict. The load balancer can't be gamed by a traffic pattern it doesn't follow. The gossip protocol needs no leader because any node can contact any other.

And throughout: algorithmic randomness when the goal is performance, cryptographic randomness when the goal is security. Getting this wrong isn't a design tradeoff — it's a vulnerability.

---

## Exercises

### Warm-Up

**1.** A graph has 8 vertices and 10 edges. Vertex $A$ has degree 4; vertex $B$ has degree 1. (a) What is the stationary probability of a random walk visiting $A$? Visiting $B$? (b) If you run PageRank on this graph with damping factor $d = 0.85$, does vertex $A$ or $B$ get more weight? Why? (c) Give one example from a real system — other than web search — where you'd want a centrality measure that favors high-degree nodes. *(Tests: stationary distribution formula, PageRank intuition, applied translation.)*

**2.** A distributed key-value store uses `hash(key) mod N` to assign keys to servers. The store has 200 servers and 1 million keys. (a) If one server is removed, approximately how many keys must be remapped? (b) If consistent hashing is used instead, approximately how many keys move when one server is removed? Show your reasoning. (c) The store autoscales — on peak days it adds 20 servers, on off-peak days it removes 20. Which approach causes more operational pain, and why? *(Tests: naive hashing fragility, consistent hashing O(K/N) guarantee, operational implications of the tradeoff.)*

**3.** You are designing a load balancer for a fleet of 50 application servers. Request load is uniform in expectation but has occasional hot spikes. (a) Compare three options: round-robin, uniform random selection, and power of two choices. What is the expected maximum load per server under each, qualitatively? (b) The power-of-two-choices variant requires sampling the load of two servers before routing. What happens to its guarantees if the load samples are 30 seconds stale? (c) You discover that 5% of your users generate 60% of the load. Does consistent hashing with power-of-two help? What else might you need? *(Tests: load balancing method comparison, staleness failure mode, hot-key problem identification.)*

### Application

**4.** A 6-node graph forms two dense triangles connected by a single bridge edge: nodes 1–2–3 form one triangle, nodes 4–5–6 form another, with edge 3–4 as the only connection between them. (a) Without computing exact mixing time, explain qualitatively why a random walk on this graph mixes slowly. (b) If you run DeepWalk to generate node embeddings, what property of the resulting vectors would you expect — and what would be misleading about them for nodes near the bridge? (c) What modification to the graph (or the walk) would improve mixing time? *(Tests: mixing time intuition from graph structure, practical implication for graph ML, spectral gap reasoning.)*

**5.** You run a gossip protocol across a cluster of 1,024 nodes to propagate a configuration update. (a) Approximately how many rounds are needed for all nodes to receive the update? Show the log calculation. (b) Two nodes are partitioned from the rest of the cluster for 5 rounds, then reconnect. Which gossip variant — anti-entropy or rumor-mongering — is more likely to eventually bring them current? Why? (c) A network engineer proposes replacing gossip with a broadcast tree (each node fans out to 4 children). What is the depth of the tree, and how does it compare to gossip for convergence speed and single-point-of-failure risk? *(Tests: O(log n) convergence calculation, anti-entropy vs. rumor-mongering tradeoff, gossip vs. tree comparison.)*

**6.** A web service stores session tokens in a cache. A developer uses Python's `random.random()` to generate token values before hashing them into storage keys. (a) Identify the specific security failure in this design. (b) An attacker observes 1,000 consecutive tokens from the public API. What does this enable them to do, and why? (c) Rewrite the token generation in one line using the correct Python primitive. (d) The developer argues: "We use a PRNG for routing decisions in our load balancer, so why not here?" Write the two-sentence response that correctly distinguishes the two cases. *(Tests: algorithmic vs. cryptographic randomness distinction, PRNG predictability vulnerability, correct tool selection, ability to explain the distinction to a non-specialist.)*

### Synthesis

**7.** You are designing the storage layer for a social network's feed cache. Each user's feed is a hot-read object; celebrity users generate read spikes of up to 10,000x average. The system must tolerate node failures with no downtime. (a) Design a key assignment scheme that handles dynamic cluster scaling, hot-user spikes, and node failure. Name every randomized component and explain what each one is doing. (b) A user's feed is replicated to 3 nodes. On read, you route to a random replica. A junior engineer complains that the user sometimes sees stale data. Explain the tradeoff being made and name the system property being sacrificed. (c) The team wants to add session affinity — always routing a given user's requests to the same replica during a session. How do you add this without losing the load distribution benefits of random routing? *(Tests: integrated system design combining consistent hashing, virtual nodes, power-of-two, replication, and affinity — requires holding multiple tradeoffs simultaneously.)*

**8.** Valiant routing on a 16-node hypercube introduces a random intermediate node before each packet reaches its destination. (a) Under a worst-case adversarial traffic permutation, what is the expected routing time in hops with and without Valiant's scheme? (b) The routing overhead of Valiant's scheme doubles the expected path length. Under what traffic conditions is this overhead worth paying? Under what conditions would you switch back to shortest-path? (c) You are building a rate limiter for an API gateway with 8 backend servers. A sophisticated client is timing requests to exploit round-robin routing and always hit the same backend. Describe a randomized defense, and explain why it's analogous to Valiant's approach. *(Tests: Valiant routing analysis, adversarial vs. benign load tradeoff, cross-domain application of the core insight — the adversarial defense argument applied outside networking.)*

### Challenge

**9.** You are the infrastructure lead for a distributed analytics platform. The platform runs a nightly job that estimates the clustering coefficient of a social graph with 500 million nodes and 50 billion edges — too large to enumerate exhaustively. The team proposes using random walk sampling. (a) Describe how you would use a random walk to estimate the fraction of triangles in the graph. What statistic would you observe on each step, and how would you correct for the degree-bias of the sample? (b) The graph has a known heavy-tailed degree distribution (a small number of nodes have millions of connections). Explain the mixing-time implications for your random walk sampler, and propose a practical mitigation. (c) A data scientist suggests running 1,000 independent short walks rather than one long walk. What does this buy you statistically, and what does it assume about the graph? (d) The estimate must be within 5% of the true value with 95% confidence. Sketch how you would determine the required number of samples, naming the relevant concentration inequality. *(Tests: random walk sampling design from scratch, degree-bias correction, heavy-tail mixing problem, walk-length vs. number-of-walks tradeoff, confidence bound reasoning — requires integrating all of Chapter 7's random walk material with Chapter 1's probability tools.)*

---

## LLM Exercise — Chapter 7: A Randomization Decision

**Project:** *Decision Diary*.

**What you're building this chapter:** A diary entry on one real decision where randomization is — or could be — the right tool. Load balancing, sampling, exploration of a large network, defending against adversarial inputs, coordination at scale.

**Tool:** Claude Project (your *Decision Diary*).

**The prompt:**

```
Chapter 7 entry — Randomness and Networking.

The decision I'm thinking through: [one or two sentences naming a
real systems decision where randomization is in play. Examples: how
to load-balance requests across a fleet under known traffic skew;
whether to switch from round-robin to consistent hashing for a
sharded store; whether to use random sampling for an analytics
query on a huge graph; whether to randomize the routing of work to
on-call engineers to avoid burnout patterns; whether to use a
randomized rather than deterministic A/B-assignment scheme for
fairness reasons.]

Help me work through this as a randomized-networking problem. The
chapter's named misconception is "random routing is worse than
shortest-path routing" — which is often false under load skew,
adversarial inputs, or coordination cost.

Walk me through:

1. **What is the deterministic alternative I'd otherwise use?**
   Round-robin? Shortest-path? A consistent hash without random
   virtual nodes? A leader-elected coordinator? Name it concretely.

2. **Why is the deterministic alternative fragile here?**
   - Adversarial inputs (the load is shaped by a hostile or
     unpredictable source)
   - Load skew (some keys / paths / nodes get
     disproportionate traffic)
   - Coordination cost (deterministic methods require a leader
     or global state that doesn't scale)
   - Reproducibility-trap (debugging the deterministic version
     reveals it's depending on a brittle coincidence)
   Name the specific failure mode I'm worried about.

3. **What kind of randomization fits?**
   - Random load balancing (uniform / weighted / power-of-two
     choices)
   - Random walk for graph sampling or community-detection
   - Gossip protocol for distributed coordination
   - Consistent hashing with random virtual nodes for sharding
   - Randomized routing for adversarial environments
   - Randomized A/B-assignment for fairness or statistical
     validity
   Pick the right family.

4. **What probabilistic guarantee do I need?** The chapter
   distinguishes "with high probability" guarantees from
   "expected case" guarantees. If a single failure is
   catastrophic, expected-case isn't enough.

5. **Is the randomness algorithmic or cryptographic?**
   - Algorithmic: ordinary PRNG with a known seed, reproducible
     in tests.
   - Cryptographic: unpredictable to an adversary, used when
     security depends on the unpredictability.
   The chapter warns this distinction is high-stakes. Which do
   I actually need?

6. **What's the reproducibility / debugging cost?**
   Randomization makes production bug-reproduction harder.
   Have I planned to capture random seeds at the moment of
   failure? Is the seed in my observability stack?

Output: a structured diary entry. Headings: *The systems
decision*, *Deterministic alternative*, *Fragility of the
deterministic version*, *Randomization family chosen*,
*Probabilistic guarantee required*, *Algorithmic vs
cryptographic*, *Debugging plan*, *What I'll do next*,
*What would change my mind*, *Outcome (to fill in later)*.
```

**What this produces:** A diary entry that names the deterministic alternative, the specific fragility being addressed, and (most usefully) whether your randomization plan respects the algorithmic-vs-cryptographic distinction and includes a seed-capture strategy for debugging.

**How to adapt this prompt:**

- *For your own project:* The system prompt personalizes it. If you're not in an engineering role, the chapter still applies — randomized sampling in surveys, randomized audit selection, randomized assignment in clinical or social-science studies — the diary entry just shifts domain.
- *For ChatGPT / Gemini:* Both work. The probabilistic guarantee math is standard textbook material.
- *For Claude Code:* Sidecar opportunity: simulate your specific load distribution under round-robin vs. power-of-two-choices and report the tail-latency difference. The number is the anchor for your entry.
- *For a Claude Project:* Native fit. Engineering readers tend to revisit randomization questions repeatedly; the project accumulates patterns.

**Connection to previous chapters:** The bandit framing (Chapter 3) is a randomized-exploration decision. Game-theoretic adversarial inputs (Chapter 4) connect directly to "the deterministic alternative is fragile under adversarial input."

**Preview of next chapter:** Chapter 8 (Social Networks) is the diary's closing entry — and the synthesis moment. You'll work through one position-or-influence problem on a real network, *then* do a pass across all eight entries to surface the patterns the diary has revealed about your decision-making.

---

## AI Wayback Machine

The ideas in this chapter didn't appear from nowhere. **Radia Perlman** invented the spanning tree protocol in 1985 — the algorithm that keeps every Ethernet network on the planet from collapsing under broadcast storms. She's sometimes called "the mother of the internet," but she objects to the title.

**Run this:**

```
Who is Radia Perlman, and how does her work on the spanning tree
protocol and link-state routing connect to the randomness and
networking algorithms we covered in this chapter? Keep it to three
paragraphs. End with the single most surprising thing about her
career or ideas.
```

→ Search **"Radia Perlman"** on Wikipedia. See what the model got right, got wrong, or left out.

**Now make the prompt better.** Try one of these:

- Ask it to explain how the spanning tree protocol avoids broadcast loops, using a 4-switch example.
- Ask it to compare Perlman's deterministic spanning tree with the randomized algorithms in this chapter — what does randomness buy, what does determinism buy?

What changes? What gets better? What gets worse?

## Prompts

Use these prompts with Claude to generate interactive D3 v7 versions of the
figures in this chapter. Each produces a standalone HTML file you can open
in a browser and modify freely.

**Prerequisites:** Load `brutalist/CLAUDE.md` and `brutalist/DESIGN.md` into
your Claude project context before using these prompts. They define the stack,
naming conventions, color system, and typography the figures use.

---

### Figure 7.1 — Example graph (6–8 nodes, varying degree) with each

Create a standalone D3 v7 HTML file for Figure Example graph (6–8 nodes, varying degree) with each. Use the CDN https://cdnjs.cloudflare.com/ajax/libs/d3/7.9.0/d3.min.js, inline CSS, ResizeObserver redraw, SVG role="img", aria-labelledby, title, and desc. Build the figure from this structural brief: small example graph (6–8 nodes, varying degree) with each node labeled by its stationary probability π(v) = deg(v)/2m, and an arrow indicating the random walk transition; reader should see at a glance that high-degree nodes accumulate higher visit probability, and connect the formula to the PageRank intuition before the text names it. Use the described data shape and labels; when exact values are not supplied, use plausible illustrative values that preserve the relationships in the brief. Use a zero baseline for bars or areas, direct labels where possible, and annotations named in the brief. Use only DESIGN.md color variables and the required serif/mono font split.

> Reference implementation: `d3/07-randomness-and-networking-fig-01.html`

---

### Figure 7.2 — Consistent hashing ring diagram 

Create a standalone D3 v7 HTML file for Figure Consistent hashing ring diagram . Use the CDN https://cdnjs.cloudflare.com/ajax/libs/d3/7.9.0/d3.min.js, inline CSS, ResizeObserver redraw, SVG role="img", aria-labelledby, title, and desc. Build the figure from this structural brief: consistent hashing ring diagram — circular hash space with 4–5 server nodes placed at random positions and 8–10 keys placed at their hash positions; arc ownership indicated by color; one server marked as "leaving" with arrows showing which keys (only those in its arc) migrate to the next clockwise server; reader should see why only O(K/N) keys move on a membership change. Use the described data shape and labels; when exact values are not supplied, use plausible illustrative values that preserve the relationships in the brief. Use a zero baseline for bars or areas, direct labels where possible, and annotations named in the brief. Use only DESIGN.md color variables and the required serif/mono font split.

> Reference implementation: `d3/07-randomness-and-networking-fig-02.html`

---

### Figure 7.3 — Bar chart comparing maximum load per server across

Create a standalone D3 v7 HTML file for Figure Bar chart comparing maximum load per server across. Use the CDN https://cdnjs.cloudflare.com/ajax/libs/d3/7.9.0/d3.min.js, inline CSS, ResizeObserver redraw, SVG role="img", aria-labelledby, title, and desc. Build the figure from this structural brief: bar chart comparing maximum load per server across three strategies — random (one choice), power of two choices, optimal — for 100 servers and 10,000 requests; reader should see the dramatic difference between one random choice (heavy tail) and two choices (nearly optimal), which is the whole point of the theorem and harder to feel from prose alone. Use the described data shape and labels; when exact values are not supplied, use plausible illustrative values that preserve the relationships in the brief. Use a zero baseline for bars or areas, direct labels where possible, and annotations named in the brief. Use only DESIGN.md color variables and the required serif/mono font split.

> Reference implementation: `d3/07-randomness-and-networking-fig-03.html`

---

### Figure 7.4 — Line chart showing gossip convergence 

Create a standalone D3 v7 HTML file for Figure Line chart showing gossip convergence . Use the CDN https://cdnjs.cloudflare.com/ajax/libs/d3/7.9.0/d3.min.js, inline CSS, ResizeObserver redraw, SVG role="img", aria-labelledby, title, and desc. Build the figure from this structural brief: line chart showing gossip convergence — x-axis: rounds (1 to ~20), y-axis: fraction of nodes informed (0 to 1.0); curve shows exponential growth in early rounds then rapid flattening near 1.0 at O(log n) rounds; annotated with the inflection point where i ≈ n/2; reader should see why O(log n) is the right convergence claim and feel the epidemic metaphor in the shape of the curve. Use the described data shape and labels; when exact values are not supplied, use plausible illustrative values that preserve the relationships in the brief. Use a zero baseline for bars or areas, direct labels where possible, and annotations named in the brief. Use only DESIGN.md color variables and the required serif/mono font split.

> Reference implementation: `d3/07-randomness-and-networking-fig-04.html`
