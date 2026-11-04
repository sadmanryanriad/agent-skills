---
name: grill-me
description: >-
  A relentless interview to sharpen a plan, decision, or architectural design.
  Use when the user wants to stress-test their thinking or uses any 'grill' triggers.
---

# grill-me

Interview the user relentlessly until you reach a shared understanding. Map this as a **design tree**: every decision branches into the decisions that hang off it.

## The Interview Loop

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already settled: the questions you can ask _now_ without guessing at answers you haven't heard yet. Ask the whole frontier in one round: number each question and give your recommended answer. Then wait for the user's answers before the next round.

Format a round like so:

```markdown
❓ **Q1** - **<question title>**: <question body, multiple choices if applicable>

➡️ **Recommended**: <your recommended answer>

---

❓ **Q2** - **<question title>**: <question body>

➡️ **Recommended**: <your recommended answer>
```

- Word each question so answering "yes" or accepting accepts your recommended answer.
- Each round the user answers reshapes the tree: settled decisions push the frontier outward and unblock questions that depended on them.
- Finding **facts** is your job, never the user's. Look up files, configurations, and tools yourself; only put **decisions** to the user.
- The session is done when the frontier is empty: every branch of the design tree visited, nothing left silently assumed. Do not execute code or major changes until the user confirms you have reached a shared understanding.
