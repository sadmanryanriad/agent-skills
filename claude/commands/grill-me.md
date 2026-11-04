# Grill Me — Relentless Planning & Decision Interview

Stress-test the user's plan, decision, or architectural feature through a relentless interview loop before writing any code.

Topic or Plan to Grill:
$ARGUMENTS

## The Interview Process
1. Map the proposal as a **design tree**: every decision branches into the decisions that hang off it.
2. Identify the **frontier**: every decision whose prerequisites are settled right now.
3. Ask the whole frontier in **structured rounds**:
   - Number each question.
   - Provide your **Recommended Answer** for each question (phrased so "yes" accepts it).
   - Wait for the user's answers before proceeding to the next round.
4. Facts are your job (search the codebase/docs yourself); put only genuine **decisions** to the user.
5. Do NOT execute implementation code until the frontier is completely empty and the user confirms shared understanding.
