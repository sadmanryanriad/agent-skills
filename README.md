# Agent Skills (`agent-skills`)

A centralized, cross-device repository for AI coding assistant skills, custom slash commands, and worker subagents. Designed for seamless portability across developer machines running **Antigravity CLI**, **Claude Code**, **OpenAI Codex**, **Cursor**, **Kimi**, or any terminal-capable AI harness.

---

## Included Skills & Tools

### `free-worker` (Subagent Token Saver)
Offloads mechanical coding tasks, boilerplate generation, unit test drafting, and large file exploration to free models (via **OpenCode** and **OpenRouter**) at zero token cost.

- **Antigravity CLI:** Triggered via `/free-worker <task>` or `"use free-worker to <task>"` (Progressive disclosure: 0 token overhead until invoked).
- **Claude Code:** Triggered via `/free-worker <task>` (or shorthand `/worker <task>`).
- **OpenAI Codex / Kimi / Any Harness:** Run directly via terminal/bash tool: `free-worker -m <model> "prompt"`.
- **Interactive Model Selection (User Decides):** Real-time query of currently available free models and context windows (`free-worker -l`). The agent presents the list and waits for your explicit choice.
- **Dynamic Parallel Scaling:** Single worker for focused edits, or scaled parallel workers (`&`) across independent files or model races with provider balancing.
- **Hardware Protection:** Governed by Linux cgroups (`systemd-run -p MemoryMax=512M -p CPUQuota=60%`).

---

## 🤖 AI Agent Prompts for Other Devices

Whenever you work on another computer (Windows WSL, `Riad-AMD` workstation, Intel workstation, MacBook, or VPS), paste one of the prompts below into your AI agent (**Claude Code**, **Antigravity CLI**, **Codex**, etc.):

### Option A: Universal Smart Prompt (Initial Setup OR Sync)
> *"Sync my agent-skills: If `~/projects/agent-skills` does not exist, clone `https://github.com/sadmanryanriad/agent-skills.git` there. Then run `./sync.sh` (or `./install.sh` if first time) to non-destructively link skills and commands. Preserve all existing unique local skills on this device; if any skill has the same name but different content, ask me before modifying it. Finally, verify with `free-worker -l`."*

---

### Option B: Quick Update / Sync Prompt (When You Pushed Changes)
Use this when you edited a skill on one device, pushed to GitHub, and want your other machine to get the update:
> *"Run `./sync.sh` inside `~/projects/agent-skills` to pull the latest skill updates and re-sync symlinks. Report any conflicts with my local skills."*

---

## 🛡️ Edge Cases & Non-Destructive Appending (Workstation Safety)

If your machine (e.g. `Riad-AMD`) already has local skills installed:
1. **Never Overwrites Unique Skills:** Skills existing only on your local workstation are untouched.
2. **Identical Skills are Ignored:** If a local skill is identical or already symlinked to the repo, it is skipped silently.
3. **Conflict Detection:** If a local skill has the same name but **different content/description**, `./sync.sh` pauses and asks whether to keep your local version, overwrite it, or create a timestamped backup first.

---

## 🛠️ Manual CLI Setup

### 1. Initial Clone & Install
```bash
git clone https://github.com/sadmanryanriad/agent-skills.git ~/projects/agent-skills
cd ~/projects/agent-skills
./install.sh
```

### 2. Syncing Future Updates
```bash
cd ~/projects/agent-skills
./sync.sh
```

### 3. (Optional) Configure OpenRouter Key
To enable OpenRouter's free tier models in addition to OpenCode's built-in free models:
```bash
echo 'export OPENROUTER_API_KEY="sk-or-v1-your-key-here"' > ~/.config/opencode/.env
chmod 600 ~/.config/opencode/.env
```

### 4. Verify Installation
```bash
free-worker -l
```

---

## 🔒 Strict Zero-Secret Policy (Public Repo Safe)

This repository is designed to be safe as a **public** repository:
1. **Local Keys Only:** API keys reside in `~/.config/opencode/.env` (mode `600`) outside the repo.
2. **Automated Git Pre-Commit Scanner:** An automated hook (`.git/hooks/pre-commit`) blocks any commit containing API key patterns (`sk-or-v1-`, `ghp_`, `sk-ant-`, `sk-`).
3. **Strict `.gitignore`:** Ignores all `.env*` (except `.env.example`), `*.key`, `*.token`, and `*.db` files.

---

## 📂 Repository Structure

```text
agent-skills/
├── README.md                                 # Documentation & AI Agent Prompts
├── install.sh                                # Automated setup & OpenCode installer
├── sync.sh                                   # Conflict-aware non-destructive sync
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
