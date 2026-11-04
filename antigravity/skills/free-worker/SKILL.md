---
name: free-worker
description: >-
  Delegate mechanical coding tasks, boilerplate generation, unit test drafting,
  or codebase exploration to free stealth models (DeepSeek, GLM, LLaMA, etc.)
  via OpenCode at zero token cost.
---

# Free Worker Subagent (OpenCode / OpenRouter)

Use `free-worker` to offload grunt work to free models dynamically without consuming premium agent tokens. Compatible with Antigravity, Claude Code, Codex, and any CLI-capable AI harness.

## 1. Interactive Model Consultation Protocol (User Decides)
Model intelligence and task fitness vary greatly; a larger context window does **not** necessarily mean a better model for code generation. The user knows which model fits their specific task best.

1. **Fetch live models:** Run `free-worker -l` to get the real-time list of active free models and context sizes.
2. **Present & await user choice:** Display the live list with context sizes to the user. **DO NOT pick a model automatically.** Ask: *"Which free model would you like to use for this task?"* and wait for their explicit decision.
3. **Strict adherence to user choice:** Always respect and dispatch the exact model specified by the user.
4. **Timeout & Expiration Protection:** If the chosen model takes >45–60s without output or errors out, stop immediately, explain the delay, and ask user permission to switch to another model.

## 2. Caveman Speed Engine (Fast Execution on Free Models)
Free models can experience traffic congestion and slower token streaming. To ensure maximum speed and execution efficiency, **always enforce Caveman format** when commanding `free-worker`:

1. **Caveman Briefing:** Strip conversational filler from the prompt. Give exact paths, bullets, and strict requirements.
2. **Mandatory Caveman Directive:** Append an explicit caveman instruction to the prompt:
   `"Output rule: Caveman format. Code/diff first. Zero pleasantries, zero fluff. Terse bullets for status."`
3. **Why:** Eliminating preamble cuts output tokens by up to 70%, allowing free models to return completed code 3x–5x faster and avoid queue timeouts.

## 3. How to Invoke
Execute the `free-worker` binary via your command/bash tool:

```bash
# Check real-time free models + context sizes:
free-worker -l

# Code generation with Caveman directive for ultra-fast generation:
free-worker -m <user-chosen-model> "Draft pytest unit tests for app/torrent_sentinel.py. Caveman output: code first, zero fluff."

# Read-only exploration / research ('plan' agent):
free-worker -m <user-chosen-model> -a plan "Find all places where router credentials are used. Caveman bullets only."
```

## 4. Transparent Attribution in Final Response (Mandatory)
Whenever `free-worker` is used, the final response to the user MUST explicitly state which model(s) performed the work:
- Format: `> 🤖 Free Subagent: <provider/model> | Mode: <build|plan> | Verification: <Passed>`
- If parallel workers were run, list each model and the specific file or component it handled.

## 5. Dynamic Parallel Scaling (User Governed)
Single or multiple workers can be dispatched depending on the workload:
- **Independent Task Splitting:** When work naturally divides across distinct files (e.g. tests for module A, B, and C), launch concurrent background workers (`&`) simultaneously.
- **Model Racing:** For complex tasks, dispatch multiple distinct models in parallel and merge the cleanest solution.
- **Provider Balancing:** When scaling concurrency, distribute workers across providers (e.g., OpenCode built-in vs OpenRouter) to avoid single-provider concurrency rate limits.
- **Strict File Isolation:** Every concurrent worker must own a separate, distinct file target—never let parallel workers write to the same destination file.

## 6. Hardware & System Safety
- Automatically runs under a 512MB RAM and 60% CPU cgroup clamp via `systemd-run` to protect host resources.
- The orchestrator agent must always review, syntax-check (`python -m py_compile`), and verify the worker's output before committing.
