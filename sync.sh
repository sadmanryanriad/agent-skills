#!/usr/bin/env bash
# ==============================================================================
# agent-skills Smart Sync — Conflict-Safe Sync Across All Devices
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Syncing Agent Skills ==="

# 1. Update git repository if tracking remote
if [[ -d "$SCRIPT_DIR/.git" ]] && git -C "$SCRIPT_DIR" remote >/dev/null 2>&1; then
    echo "Pulling latest changes from GitHub..."
    git -C "$SCRIPT_DIR" pull --ff-only origin main || {
        echo "Notice: Could not fast-forward git pull. Proceeding with local repository files."
    }
fi

# 2. Ensure user binary path exists and link free-worker
mkdir -p "$HOME/.local/bin"
if [[ -f "$SCRIPT_DIR/bin/free-worker" ]]; then
    chmod +x "$SCRIPT_DIR/bin/free-worker"
    ln -sf "$SCRIPT_DIR/bin/free-worker" "$HOME/.local/bin/free-worker"
fi

# 3. Smart Link Antigravity Skills (Non-destructive, conflict-aware)
mkdir -p "$HOME/.gemini/config/skills"
if [[ -d "$SCRIPT_DIR/antigravity/skills" ]]; then
    for skill_dir in "$SCRIPT_DIR/antigravity/skills"/*; do
        if [[ -d "$skill_dir" ]]; then
            skill_name="$(basename "$skill_dir")"
            target_dir="$HOME/.gemini/config/skills/$skill_name"
            source_skill="$skill_dir/SKILL.md"
            target_skill="$target_dir/SKILL.md"

            if [[ ! -d "$target_dir" ]] || [[ ! -f "$target_skill" ]]; then
                echo " [APPEND] Linking new Antigravity skill: $skill_name"
                mkdir -p "$target_dir"
                ln -sf "$source_skill" "$target_skill"
            elif cmp -s "$source_skill" "$target_skill"; then
                # Files are identical or already symlinked
                true
            else
                echo ""
                echo " [CONFLICT] Skill '$skill_name' already exists locally and differs from repository version."
                echo "   Local: $target_skill"
                echo "   Repo:  $source_skill"
                
                # Check if running interactively
                if [ -t 0 ]; then
                    read -r -p "   Action: [K]eep local / [O]verwrite with repo / [B]ackup & replace? (default: Keep): " choice
                    case "${choice,,}" in
                        o|overwrite)
                            echo "   -> Overwriting with repo version."
                            ln -sf "$source_skill" "$target_skill"
                            ;;
                        b|backup)
                            backup_file="$target_dir/SKILL.md.bak.$(date +%s)"
                            echo "   -> Backing up local to $backup_file and linking repo version."
                            mv "$target_skill" "$backup_file"
                            ln -sf "$source_skill" "$target_skill"
                            ;;
                        *)
                            echo "   -> Keeping existing local version."
                            ;;
                    esac
                else
                    echo "   -> Non-interactive session: Keeping existing local version to prevent accidental overwrites."
                fi
            fi
        fi
    done
fi

# 4. Smart Link Claude Code Commands (Non-destructive, conflict-aware)
mkdir -p "$HOME/.claude/commands"
if [[ -d "$SCRIPT_DIR/claude/commands" ]]; then
    for cmd_file in "$SCRIPT_DIR/claude/commands"/*.md; do
        if [[ -f "$cmd_file" ]]; then
            cmd_name="$(basename "$cmd_file")"
            target_cmd="$HOME/.claude/commands/$cmd_name"

            if [[ ! -f "$target_cmd" ]]; then
                echo " [APPEND] Linking new Claude command: $cmd_name"
                ln -sf "$cmd_file" "$target_cmd"
            elif cmp -s "$cmd_file" "$target_cmd"; then
                true
            else
                echo ""
                echo " [CONFLICT] Command '$cmd_name' already exists locally and differs from repository version."
                if [ -t 0 ]; then
                    read -r -p "   Action: [K]eep local / [O]verwrite / [B]ackup & replace? (default: Keep): " choice
                    case "${choice,,}" in
                        o|overwrite)
                            ln -sf "$cmd_file" "$target_cmd"
                            ;;
                        b|backup)
                            mv "$target_cmd" "$target_cmd.bak.$(date +%s)"
                            ln -sf "$cmd_file" "$target_cmd"
                            ;;
                        *)
                            echo "   -> Keeping existing local command."
                            ;;
                    esac
                else
                    echo "   -> Non-interactive session: Keeping existing local command."
                fi
            fi
        fi
    done
fi

echo ""
echo "=== Sync Complete! Skills and Commands are up to date. ==="
