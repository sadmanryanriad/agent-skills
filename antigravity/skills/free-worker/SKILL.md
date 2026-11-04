---
name: free-worker
description: >-
  Delegate mechanical coding tasks, boilerplate generation, unit test drafting,
  or codebase exploration to free stealth models (DeepSeek, GLM, LLaMA, etc.)
  via OpenCode at zero token cost.
---

# Free Worker Subagent (OpenCode / OpenRouter)

Use `free-worker` to offload grunt work to free models dynamically without consuming premium agent tokens. Compatible with Antigravity, Claude Code, Codex, and any CLI-capable AI harness.

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
free-worker -m <chosen-model> "Draft pytest unit tests for app/torrent_sentinel.py"

# Read-only exploration / research ('plan' agent):
free-worker -m <chosen-model> -a plan "Find all places where router credentials are used"
```

## Parallel Execution & Scaling (Dynamic)
Single or multiple workers can be dispatched depending on the workload:
- **Independent Task Splitting:** When work naturally divides across distinct files (e.g. tests for module A, B, and C), launch concurrent background workers (`&`) simultaneously.
- **Model Racing:** For complex tasks, dispatch multiple distinct models in parallel and merge the cleanest solution.
- **Provider Balancing:** When scaling concurrency, distribute workers across providers (e.g., OpenCode built-in vs OpenRouter) to avoid single-provider concurrency rate limits.
- **Strict File Isolation:** Every concurrent worker must own a separate, distinct file target—never let parallel workers write to the same destination file.

## Hardware & System Safety
- Automatically runs under a 512MB RAM and 60% CPU cgroup clamp via `systemd-run` to protect host resources.
- The orchestrator agent must always review, syntax-check (`python -m py_compile`), and verify the worker's output before committing.
