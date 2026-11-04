# Agent Skills (`agent-skills`)

A centralized, cross-device repository for AI coding assistant skills, custom slash commands, and worker subagents. Designed for seamless portability across developer machines running **Antigravity CLI**, **Claude Code**, **OpenAI Codex**, **Cursor**, **Kimi**, or any terminal-capable AI harness.

---

## Included Skills & Tools

### `free-worker` (Subagent Token Saver)
Offloads mechanical coding tasks, boilerplate generation, unit test drafting, and large file exploration to free models (via **OpenCode** and **OpenRouter**) at zero token cost.

- **Antigravity CLI:** Triggered via `/free-worker <task>` or `"use free-worker to <task>"` (Progressive disclosure: 0 token overhead until invoked).
- **Claude Code:** Triggered via `/free-worker <task>` (or shorthand `/worker <task>`).
- **OpenAI Codex / Kimi / Any Harness:** Run directly via terminal/bash tool: `free-worker -m <model> "prompt"`.
- **Interactive Model Selection:** Real-time query of currently available free models and context windows (`free-worker -l`).
- **Dynamic Parallel Scaling:** Single worker for focused edits, or scaled parallel workers (`&`) across independent files or model races with provider balancing.
- **Hardware Protection:** Governed by Linux cgroups (`systemd-run -p MemoryMax=512M -p CPUQuota=60%`).

---

## 🚀 One-Shot AI Agent Setup Prompt (For Other Devices)

When you clone this repo onto any other computer (Windows WSL, Linux workstation, MacBook, VPS), open your AI agent (**Claude Code**, **Antigravity CLI**, **Codex**, etc.) and paste this prompt:

```text
I have cloned my agent-skills repo to this machine at [PATH_TO_REPO]. Please run the installation script (`./install.sh`), verify that ~/.local/bin/free-worker, ~/.gemini/config/skills/free-worker/, and ~/.claude/commands/ are properly linked, and test that `free-worker -l` outputs the live free models table. Ensure my environment is ready to use free-worker subagents.
```

The agent will execute `install.sh`, verify symlinks, install OpenCode if missing, and test the models table automatically.

---

## 🛠️ Universal Setup (Any Harness)

### For Claude Code
Type `/free-worker` directly:
```text
/free-worker draft pytest unit tests for auth service
```

### For Antigravity CLI
Mention the skill:
```text
Use free-worker to find all callers of the payment webhook
```

### For OpenAI Codex / Kimi / Aider / Cursor / Any AI Harness
Add this snippet to your harness's system instructions, `AGENTS.md`, or custom instructions:
```markdown
## Free Subagent Worker Protocol (`free-worker`)
When handling mechanical boilerplate, unit tests, or large file exploration:
- Query real-time free models: `free-worker -l`
- Run task: `free-worker -m <model> "prompt"` (or `-a plan` for read-only sweeps)
- Parallel scaling: Dispatch concurrent workers (`&`) on distinct files across different providers to avoid rate limits.
- Latency fallback: If a model hangs >45s, ask user permission to switch to another active model.
```

---

## 🔒 Strict Zero-Secret Policy (Public Repo Safe)

This repository is designed to be safe as a **public** repository:
1. **Never commit `.env` or credentials:** All keys must reside locally in `~/.config/opencode/.env` or `~/.local/share/opencode/auth.json`.
2. **Automated Git Pre-Commit Scanner:** An automated hook (`.git/hooks/pre-commit`) blocks any commit containing API key patterns (`sk-or-v1-`, `ghp_`, `sk-ant-`, etc.).
3. **Strict `.gitignore`:** Ignores all `.env*` (except `.env.example`), `*.key`, `*.token`, and `*.db` files.

---

## 📖 Direct CLI Usage

```bash
# Check real-time free models + context sizes
free-worker -l

# Run a quick code generation task
free-worker "Write a python function to parse ISO timestamps"

# Read-only exploration (won't modify files)
free-worker -a plan "Explain how background tasks are handled in this codebase"

# Parallel execution across two independent files
free-worker -m opencode/deepseek-v4.1-flash-free "Write tests for auth.py" &
free-worker -m openrouter/openrouter/free "Write tests for router.py" &
wait
```

---

## 📂 Repository Structure

```text
agent-skills/
├── README.md
├── install.sh                                # Automated setup script
├── .gitignore                                # Strict zero-secret policy
├── bin/
│   └── free-worker                           # Subagent CLI runner
├── antigravity/
│   └── skills/
│       └── free-worker/
│           └── SKILL.md                      # Antigravity progressive skill
└── claude/
    └── commands/
        └── free-worker.md                    # Claude Code slash command
```
