# Free Worker Subagent Runner

You are delegating a task to an external free model subagent via `free-worker` to save Sadman's tokens.

Task to execute:
$ARGUMENTS

## Step 1: Live Model Consultation
Run `free-worker -l` to fetch the real-time list of available free models and their context sizes.
Present the active options to Sadman and ask which model he wants to use for this task.

## Step 2: Execute Delegation
Once Sadman selects a model (or if specified in arguments), run:
```bash
free-worker -m "<selected-model>" "$ARGUMENTS"
```
Or for read-only codebase exploration:
```bash
free-worker -m "<selected-model>" -a plan "$ARGUMENTS"
```

### Parallel Scaling (Dynamic)
- Single or multiple workers can be dispatched depending on the task:
  - If work splits across distinct files (e.g. tests for module A and module B) or to race models for speed/quality, run concurrent workers in background (`&`).
  - Distribute parallel workers across distinct providers (e.g. OpenCode built-in vs OpenRouter) to evade single-provider rate limits.
  - Never allow multiple workers to write to the same destination file simultaneously.

## Step 3: Latency & Expiry Guardrail
- If a model takes >45–60s without responding or errors out (due to capacity/expiration):
  - Do NOT hang or fail silently.
  - Stop immediately and ask Sadman's permission to switch to a fallback free model (e.g. `opencode/deepseek-v4.1-flash-free` or `openrouter/openrouter/free`).

## Step 4: Verification
Inspect the worker's output/diff, check syntax (`python -m py_compile`), and present the final verified result to Sadman.
