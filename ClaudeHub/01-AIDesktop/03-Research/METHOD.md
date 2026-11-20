# Research method

How a question becomes a brief. Pick the depth first, then run the steps. The depth sets how
far each step goes, not which steps run: even a quick answer gets checked.

| Depth | When | Roughly |
|-------|------|---------|
| **Quick** | a fact, a price, "is this allowed" | 3+ sources, one pass, a 5-line brief |
| **Standard** | a decision with money or time on it | 5–10 sources across angles, a verify pass |
| **Deep** | "research this properly", a decision with real money or health behind it, anything they'll act on for weeks | parallel agents per angle, adversarial verify, full brief |

They say the depth, or you pick it from the stakes and say which in one line.

## 1. Frame

Write the top of `BRIEF.md` before searching:

- **Question**, in one sentence, in their words.
- **What it's for**: the decision or action it feeds. A question with no decision behind it
  gets a quick answer, not a deep one.
- **What "answered" looks like**: a number, a yes/no with conditions, a ranked shortlist.
- **What would change the answer**: their hardware, budget, country, platform.

If the question is ambiguous in a way that changes the research, ask one question. Otherwise
state your reading of it and go.

## 2. Sweep from several angles

One search phrasing finds one corner of the web. Cover at least three of these:

- **Primary**: the official docs, the platform's own help center or policy page, the study
  itself, the GitHub repo, the company's pricing page.
- **Practitioners**: people who actually do it (forums, Reddit, Discord write-ups, YouTube).
  Good for "what really happens"; weak for rules and numbers.
- **Critics**: search for the case against ("X doesn't work", "X banned", "X problems").
- **Recent**: add the current year, or search the changelog. What changed in the last six
  months?
- **Evidence** (health, training, anything with a study behind it): systematic reviews and
  meta-analyses first, then trials; PubMed and Cochrane are the usual databases.

At **Deep**, if you can launch subagents, give each angle its own agent with the frame from
step 1, and have each return claims with URLs. If the session offers multi-agent workflows
and they asked for depth, use one: sweep, then verify, then synthesize.

## 3. Read sources, not snippets

A search result's preview is not a source. Open the page and read the part that matters.
For each source note in `sources.md`: what it claims, how it knows (data, experience,
opinion), its date, and who's behind it (and whether they're selling something).

## 4. Verify

For every claim the bottom line rests on:

- **Second source.** Two independent sources, or one primary source. Two blogs copying the
  same press release count as one.
- **Try to break it.** Search for the claim being wrong or outdated. At **Deep**, give the
  three biggest claims to separate agents told to refute them.
- **Check dates.** A 2023 answer about platform rules or tool prices is probably wrong now.

Anything you couldn't verify stays in, marked `(unconfirmed)`.

## 5. Write the brief

`BRIEF.md`, in this shape:

```
# <question>
Asked: YYYY-MM-DD · Depth: quick/standard/deep · Re-check after: YYYY-MM-DD

## Bottom line
<2–4 sentences: the answer, and what to do about it>
Confidence: high / medium / low — <one line on why>

## What it's for
<the decision this feeds>

## The answer in detail
<short sections; every claim that matters carries a link>

## What would change this
<the conditions under which the answer flips>

## Open questions
<what couldn't be settled, and how it could be>
```

Then the row in `INDEX.md`, and the bottom line in chat.

## Traps

- **Confident and wrong is the worst outcome.** A clear "unclear, and here's why" beats a
  guess dressed as an answer.
- **Sources that sell the thing** (a supplement brand's "research", a tool's own comparison
  page) are claims, not evidence. Say who's selling.
- **AI-written listicles** are everywhere for tools and supplements. Prefer pages with a named
  author, real tests, or primary data.
- **Don't stop at the first answer that sounds right.** Run the critics angle anyway.
