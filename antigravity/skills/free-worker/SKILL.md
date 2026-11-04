---
name: free-worker
description: >-
  Delegate mechanical coding tasks, boilerplate generation, unit test drafting,
  or codebase exploration to free stealth models (DeepSeek, GLM, LLaMA, etc.)
  via OpenCode at zero token cost.
---

# Free Worker Subagent (OpenCode / OpenRouter)

Use `free-worker` to offload grunt work to free models dynamically without consuming premium agent tokens. Compatible with Antigravity, Claude Code, Codex, and any CLI-capable AI harness.

## 1. Interactive Model Consultation Protocol (Mandatory)
Not all free models perform equally on coding and reasoning tasks. Therefore:
1. **Always query real-time options:** Run `free-worker -l` to fetch currently active free models and context windows.
2. **Ask the user for model selection:** Present the live choices and ask the user which model or models they want to use for this task. Suggest top candidates based on the task:
   - *Code generation & unit tests:* `opencode/deepseek-v4.1-flash-free`, `openrouter/cohere/north-mini-code:free`, `openrouter/google/gemma-4-31b-it:free`.
   - *Broad repository exploration & large context:* `openrouter/nvidia/nemotron-3-ultra-550b-a55b:free` (1M), `openrouter/thinkingmachines/inkling:free` (1M).
   - *Fast auto-routed fallback:* `openrouter/openrouter/free`.
3. **Timeout & Expiration Protection:** If the chosen model takes >45–60s without output or errors out, stop immediately and ask user permission to switch to another active model.

## 2. Transparent Attribution in Final Response (Mandatory)
Whenever `free-worker` is used, the final response to the user MUST explicitly state which model(s) performed the work:
- Format: `> 🤖 Free Subagent: <provider/model> | Mode: <build|plan> | Verification: <Passed>`
- If parallel workers were run, list each model and the specific file or component it handled.

## 3. How to Invoke
Execute the `free-worker` binary via your command/bash tool:

```bash
# Check real-time free models + context sizes:
free-worker -l

# Code generation / editing (default 'build' agent):
free-worker -m <chosen-model> "Draft pytest unit tests for app/torrent_sentinel.py"

# Read-only exploration / research ('plan' agent):
free-worker -m <chosen-model> -a plan "Find all places where router credentials are used"
```

## 4. Parallel Execution & Scaling (Dynamic)
Single or multiple workers can be dispatched depending on the workload:
- **Independent Task Splitting:** When work naturally divides across distinct files (e.g. tests for module A, B, and C), launch concurrent background workers (`&`) simultaneously.
- **Model Racing:** For complex tasks, dispatch multiple distinct models in parallel and merge the cleanest solution.
- **Provider Balancing:** When scaling concurrency, distribute workers across providers (e.g., OpenCode built-in vs OpenRouter) to avoid single-provider concurrency rate limits.
- **Strict File Isolation:** Every concurrent worker must own a separate, distinct file target—never let parallel workers write to the same destination file.

## 5. Hardware & System Safety
- Automatically runs under a 512MB RAM and 60% CPU cgroup clamp via `systemd-run` to protect host resources.
- The orchestrator agent must always review, syntax-check (`python -m py_compile`), and verify the worker's output before committing.
