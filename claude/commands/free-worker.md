# Free Worker Subagent Runner

You are delegating a task to an external free model subagent via `free-worker` to save Sadman's tokens.

Task to execute:
$ARGUMENTS

## Step 1: Live Model Consultation (Sadman Decides)
Run `free-worker -l` to fetch the real-time list of available free models and their context sizes.
A larger context size does NOT automatically mean a better model. Sadman knows which model works best.
1. Present the active models with their context sizes.
2. DO NOT pick a model yourself. Ask: *"Which free model would you like me to use for this task?"* and wait for Sadman's explicit choice.
3. If Sadman specifies multiple models for parallel execution, dispatch them accordingly.

## Step 2: Execute Delegation (With Caveman Speed Engine)
To prevent free-model queue latency and ensure fastest execution, enforce **Caveman format** on the worker output:
```bash
free-worker -m "<sadman-chosen-model>" "$ARGUMENTS. Rule: Caveman format. Code/diff first, zero preamble, no pleasantries, terse status bullets."
```
Or for read-only codebase exploration:
```bash
free-worker -m "<sadman-chosen-model>" -a plan "$ARGUMENTS. Caveman format: terse bullets, exact paths."
```

### Parallel Scaling (When Applicable)
- If work splits across distinct files (e.g. tests for module A and module B) or to race models for speed/quality, run concurrent workers in background (`&`).
- Distribute parallel workers across distinct providers (e.g. OpenCode built-in vs OpenRouter) to evade single-provider rate limits.
- Never allow multiple workers to write to the same destination file simultaneously.

## Step 3: Latency & Expiry Guardrail
- If the model takes >45–60s without responding or errors out (due to capacity/expiration):
  - Do NOT hang or fail silently.
  - Stop immediately, explain the delay, and ask Sadman's permission to switch to another active model.

## Step 4: Verification & Transparent Attribution
1. Inspect the worker's output/diff and check syntax (`python -m py_compile`).
2. In your final report to Sadman, **explicitly state which model(s) were used**:
   - `> 🤖 Free Subagent: <provider/model> | Mode: <build|plan> | Verification: <Passed>`
   - If parallel workers ran, list each model and which file it generated.
