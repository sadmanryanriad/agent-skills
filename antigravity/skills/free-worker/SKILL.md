---
name: free-worker
description: >-
  Delegate mechanical coding tasks, boilerplate generation, unit test drafting,
  or codebase exploration to free stealth models (DeepSeek, GLM, LLaMA-70B, etc.)
  via OpenCode at zero token cost.
---

# Free Worker Subagent (OpenCode / OpenRouter)

Use `free-worker` to offload grunt work to free models dynamically without consuming premium agent tokens.

## Interactive Model Consultation Protocol (Mandatory)
Before delegating tasks in a session:
1. Run `free-worker -l` to fetch the real-time list of live free models and their current context windows.
2. Present the available models with context sizes to the user and ask which one they prefer.
3. If the selected model experiences high latency (>45–60s) or errors out (expired/rate-limited), pause and ask the user for permission to switch to a fallback model.

## How to Invoke
Execute the `free-worker` binary via your command/bash tool:

```bash
# Check real-time free models + context sizes:
free-worker -l

# Code generation / editing (default 'build' agent):
free-worker -m <chosen-model> "Draft 5 pytest unit tests for app/torrent_sentinel.py"

# Read-only exploration / research ('plan' agent):
free-worker -m <chosen-model> -a plan "Find all places where router credentials are used"
```

## Parallel Execution (When Work Suits Multiple Agents)
- When a task splits into independent files (e.g. `tests/test_a.py` and `tests/test_b.py`) or to race models for speed:
  - Run up to 2 workers in parallel using distinct providers (e.g. one on OpenCode built-in, one on OpenRouter) to bypass single-provider rate limits.
  - Strictly isolate file targets so concurrent workers never overwrite each other.

## Hardware & System Safety
- The worker automatically runs under a 512MB RAM and 60% CPU cgroup clamp via `systemd-run` to protect the Asus server.
- The smart agent must always review, syntax-check (`python -m py_compile`), and verify the worker's output before committing.
