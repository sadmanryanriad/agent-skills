# Free Worker Subagent Runner

You are delegating a task to an external free model subagent via `free-worker` to save Sadman's tokens.

Task to execute:
$ARGUMENTS

## Step 1: Live Model Consultation
Run `free-worker -l` to fetch the real-time list of available free models and their context sizes.
Because model quality varies, present the active options to Sadman and ask which model or models he wants to use:
- *Recommended for code/tests:* `opencode/deepseek-v4.1-flash-free`, `openrouter/cohere/north-mini-code:free`, `openrouter/google/gemma-4-31b-it:free`
- *Recommended for large sweeps:* `openrouter/nvidia/nemotron-3-ultra-550b-a55b:free` (1M context)

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

## Step 4: Verification & Transparent Attribution
1. Inspect the worker's output/diff and check syntax (`python -m py_compile`).
2. In your final report to Sadman, **explicitly state which model(s) were used**:
   - `> 🤖 Free Subagent: <provider/model> | Mode: <build|plan> | Verification: <Passed>`
   - If parallel workers ran, list each model and which file it generated.
