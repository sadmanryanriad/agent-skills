# Agent Skills (`agent-skills`)

A centralized, cross-device repository for AI coding assistant skills, custom slash commands, and worker subagents. Designed for seamless syncing across developer machines running **Antigravity CLI** and **Claude Code**.

---

## Included Skills & Tools

### `free-worker` (Subagent Token Saver)
Offloads mechanical coding tasks, boilerplate generation, unit test drafting, and large file exploration to free models (via **OpenCode** and **OpenRouter**) at zero token cost.

- **Antigravity CLI:** Triggered via `/free-worker <task>` or `"use free-worker to <task>"` (Progressive disclosure: 0 token overhead until invoked).
- **Claude Code:** Triggered via `/free-worker <task>` (or shorthand `/worker <task>`).
- **Interactive Model Selection:** Real-time query of currently available free models and context windows (`free-worker -l`).
- **Parallel Dispatch:** Safely race two models or split across independent files with rate-limit evasion.
- **Hardware Protection:** Governed by Linux cgroups (`systemd-run -p MemoryMax=512M -p CPUQuota=60%`).

---

## 🚀 One-Shot AI Agent Setup Prompt (For Other Devices)

When you clone this repo onto any other computer (Windows WSL, Linux workstation, MacBook, VPS), open your AI agent (**Claude Code** or **Antigravity CLI**) and paste this prompt:

```text
I have cloned my agent-skills repo to this machine at [PATH_TO_REPO]. Please run the installation script (`./install.sh`), verify that ~/.local/bin/free-worker, ~/.gemini/config/skills/free-worker/, and ~/.claude/commands/ are properly linked, and test that `free-worker -l` outputs the live free models table. Ensure my environment is ready to use free-worker subagents.
```

The agent will execute `install.sh`, verify symlinks, install OpenCode if missing, and test the models table automatically.

---

## 🛠️ Manual Installation (Any New Device)

### 1. Clone the repository
```bash
git clone git@github.com:sadmanryanriad/agent-skills.git ~/projects/agent-skills
cd ~/projects/agent-skills
```

### 2. Run the installer
```bash
./install.sh
```

The installer will:
- Install OpenCode CLI if not already present.
- Symlink `bin/free-worker` to `~/.local/bin/free-worker`.
- Link the Antigravity skill to `~/.gemini/config/skills/free-worker/`.
- Link the Claude Code command to `~/.claude/commands/free-worker.md`.

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

## 📖 How to Use

### In Claude Code:
```text
/free-worker draft pytest unit tests for auth service
```

### In Antigravity CLI:
```text
Use free-worker to find all callers of the payment webhook
```

### In Your Terminal:
```bash
# Check real-time free models + context sizes
free-worker -l

# Run a quick code task
free-worker "Write a python function to parse ISO timestamps"

# Read-only exploration (won't modify files)
free-worker -a plan "Explain how background tasks are handled in this codebase"
```

---

## 📂 Repository Structure

```text
agent-skills/
├── README.md
├── install.sh                                # Automated setup script
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
