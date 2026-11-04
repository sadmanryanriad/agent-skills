# Free Worker Subagent Runner

You are delegating a task to an external free model subagent via `free-worker` to save Sadman's tokens.

Task to execute:
$ARGUMENTS

## Step 1: Live Model Consultation
Run `free-worker -l` to fetch the real-time list of available free models and their context sizes.
Present the active options to Sadman and ask which model he wants to use for this task.

## Step 2: Execute Delegation
Once Sadman selects a model (or if he specifies one in the arguments), run:
```bash
free-worker -m "<selected-model>" "$ARGUMENTS"
```
Or for read-only codebase exploration:
```bash
free-worker -m "<selected-model>" -a plan "$ARGUMENTS"
```

### Parallel Workers (When Applicable)
- When a large task can be split across independent files (e.g. tests for module A vs module B), or to race two models for speed:
  - Run up to 2 workers in parallel in background (`&`) using distinct models (e.g. one `opencode/deepseek-v4.1-flash-free` and one `openrouter/openrouter/free` to avoid single-provider rate limits).
  - Never assign the same destination file to concurrent workers.

## Step 3: Latency & Expiry Guardrail
- If the model takes >45–60s without responding or errors out (due to capacity/expiration):
  - Do NOT hang or fail silently.
  - Stop immediately and ask Sadman's permission to switch to a fallback free model (e.g. `opencode/deepseek-v4.1-flash-free` or `openrouter/openrouter/free`).

## Step 4: Verification
Inspect the worker's output/diff, check syntax (`python -m py_compile`), and present the final verified result to Sadman.
