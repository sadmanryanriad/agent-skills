#!/usr/bin/env bash
# ==============================================================================
# agent-skills Installer — Cross-Device Setup for Antigravity, Claude Code, Codex & AI Harnesses
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Setting up Agent Skills ==="

# 1. Ensure user local bin exists and is in PATH
mkdir -p "$HOME/.local/bin"
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo "Notice: Adding ~/.local/bin to your PATH in ~/.bashrc"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    export PATH="$HOME/.local/bin:$PATH"
fi

# 2. Check / Install OpenCode CLI
if ! command -v opencode >/dev/null 2>&1 && [[ ! -f "$HOME/.opencode/bin/opencode" ]]; then
    echo "Installing OpenCode CLI..."
    curl -fsSL https://opencode.ai/install | bash
fi

export PATH="$HOME/.opencode/bin:$HOME/.local/bin:$PATH"

# 3. Symlink free-worker binary
echo "Linking free-worker runner to ~/.local/bin/free-worker..."
chmod +x "$SCRIPT_DIR/bin/free-worker"
ln -sf "$SCRIPT_DIR/bin/free-worker" "$HOME/.local/bin/free-worker"

# 4. Link Antigravity Global Skill
mkdir -p "$HOME/.gemini/config/skills/free-worker"
echo "Linking Antigravity skill to ~/.gemini/config/skills/free-worker/..."
ln -sf "$SCRIPT_DIR/antigravity/skills/free-worker/SKILL.md" "$HOME/.gemini/config/skills/free-worker/SKILL.md"

# 5. Link Claude Code Command
mkdir -p "$HOME/.claude/commands"
echo "Linking Claude Code command to ~/.claude/commands/..."
ln -sf "$SCRIPT_DIR/claude/commands/free-worker.md" "$HOME/.claude/commands/free-worker.md"
ln -sf "$SCRIPT_DIR/claude/commands/free-worker.md" "$HOME/.claude/commands/worker.md"

# 6. Install Git Pre-Commit Hook (Prevents Secret Leaks)
if [[ -d "$SCRIPT_DIR/.git" ]]; then
    mkdir -p "$SCRIPT_DIR/.git/hooks"
    cat << 'EOF' > "$SCRIPT_DIR/.git/hooks/pre-commit"
#!/usr/bin/env bash
# Secret scanner pre-commit hook
if git diff --cached | grep -iE 'sk-or-v1-[0-9a-zA-Z]{20,}|ghp_[0-9a-zA-Z]{20,}|sk-ant-[0-9a-zA-Z]{20,}|sk-[0-9a-zA-Z]{30,}'; then
    echo "ERROR: Attempted to commit what looks like an API key or secret token!" >&2
    echo "Commit rejected to protect public repository security." >&2
    exit 1
fi
EOF
    chmod +x "$SCRIPT_DIR/.git/hooks/pre-commit"
fi

# 7. Ensure OpenCode config directory exists
mkdir -p "$HOME/.config/opencode"
if [[ ! -f "$HOME/.config/opencode/.env" ]]; then
    cat << 'EOF' > "$HOME/.config/opencode/.env.example"
# Optional: Set your OpenRouter API key to unlock OpenRouter free tier models
export OPENROUTER_API_KEY="sk-or-v1-..."
EOF
    echo "Tip: To enable OpenRouter free models, create ~/.config/opencode/.env with your key."
fi

echo ""
echo "=== Installation Complete! ==="
echo "Test the live free models table with:"
echo "  free-worker -l"
