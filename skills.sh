#!/usr/bin/env bash
# skills.sh — installer for the mobile-onboarding skills bundle
#
# Copies the four skills in ./skills/ into a Claude skills directory so
# Claude Code / Antigravity / any Claude-compatible harness can auto-load them.
#
# Usage:
#   ./skills.sh                       # install all skills to ~/.claude/skills
#   ./skills.sh install               # same as above
#   ./skills.sh install --project     # install to ./.claude/skills (project-scoped)
#   ./skills.sh install --target DIR  # install to a custom directory
#   ./skills.sh install --force       # overwrite any existing skill of the same name
#   ./skills.sh install --dry-run     # show what would happen; do nothing
#   ./skills.sh uninstall             # remove the installed skills
#   ./skills.sh list                  # list skills shipped in this repo
#   ./skills.sh status                # show which of them are currently installed
#   ./skills.sh help                  # show this message
#
# Cross-platform: macOS, Linux, WSL, Git Bash on Windows.
# The default target `~/.claude/skills` resolves correctly on all of these.

set -euo pipefail

# ---- paths --------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="$SCRIPT_DIR/skills"

if [[ -n "${CLAUDE_SKILLS_DIR:-}" ]]; then
  DEFAULT_TARGET="$CLAUDE_SKILLS_DIR"
else
  DEFAULT_TARGET="$HOME/.claude/skills"
fi

PROJECT_TARGET="$SCRIPT_DIR/.claude/skills"

# ---- colors -------------------------------------------------------------

if [[ -t 1 ]] && [[ "${TERM:-}" != "dumb" ]]; then
  C_RED=$'\033[31m'
  C_GREEN=$'\033[32m'
  C_YELLOW=$'\033[33m'
  C_BLUE=$'\033[34m'
  C_DIM=$'\033[2m'
  C_BOLD=$'\033[1m'
  C_RESET=$'\033[0m'
else
  C_RED="" C_GREEN="" C_YELLOW="" C_BLUE="" C_DIM="" C_BOLD="" C_RESET=""
fi

info()  { printf '%s›%s %s\n' "$C_BLUE"   "$C_RESET" "$*"; }
ok()    { printf '%s✓%s %s\n' "$C_GREEN"  "$C_RESET" "$*"; }
warn()  { printf '%s!%s %s\n' "$C_YELLOW" "$C_RESET" "$*" >&2; }
fail()  { printf '%s✗%s %s\n' "$C_RED"    "$C_RESET" "$*" >&2; }
hr()    { printf '%s%s%s\n' "$C_DIM" "$(printf '%.0s─' $(seq 1 48))" "$C_RESET"; }

# ---- discover skills in ./skills/ --------------------------------------

discover_skills() {
  # Emit one skill name per line (just the directory basename).
  if [[ ! -d "$SKILLS_SRC" ]]; then
    return 0
  fi
  find "$SKILLS_SRC" -mindepth 1 -maxdepth 1 -type d -print 2>/dev/null \
    | while read -r dir; do
        if [[ -f "$dir/SKILL.md" ]]; then
          basename "$dir"
        fi
      done \
    | sort
}

skill_description() {
  # Extract the `description:` value from a skill's SKILL.md frontmatter.
  local skill_md="$1"
  [[ -f "$skill_md" ]] || { echo ""; return; }
  awk '
    /^---[[:space:]]*$/ { fm++; next }
    fm == 1 && /^description:[[:space:]]*/ {
      sub(/^description:[[:space:]]*/, "")
      print
      exit
    }
  ' "$skill_md" | head -c 140
}

# ---- commands -----------------------------------------------------------

cmd_help() {
  cat <<EOF
${C_BOLD}skills.sh${C_RESET} — installer for the mobile-onboarding skills bundle

${C_BOLD}USAGE${C_RESET}
  ./skills.sh [command] [options]

${C_BOLD}COMMANDS${C_RESET}
  install       Install all skills   (default)
  uninstall     Remove installed skills
  list          List skills shipped in this repo
  status        Show which of them are installed
  help          Show this message

${C_BOLD}OPTIONS${C_RESET}
  --target DIR  Install into DIR   (default: $DEFAULT_TARGET)
  --project     Install into ./.claude/skills (project-scoped)
  --force       Overwrite existing skills of the same name
  --dry-run     Show what would happen; do nothing
  -h, --help    Show this message

${C_BOLD}ENVIRONMENT${C_RESET}
  CLAUDE_SKILLS_DIR   Override the default install location

${C_BOLD}EXAMPLES${C_RESET}
  ./skills.sh
  ./skills.sh install --project
  ./skills.sh install --target /custom/path --force
  ./skills.sh uninstall
  ./skills.sh list
  ./skills.sh status
EOF
}

cmd_list() {
  local skills
  mapfile -t skills < <(discover_skills)
  if [[ "${#skills[@]}" -eq 0 ]]; then
    warn "No skills found in $SKILLS_SRC"
    return 1
  fi
  info "Skills shipped in this bundle (${#skills[@]}):"
  hr
  for s in "${skills[@]}"; do
    local desc
    desc="$(skill_description "$SKILLS_SRC/$s/SKILL.md")"
    printf '  %s%s%s\n' "$C_BOLD" "$s" "$C_RESET"
    if [[ -n "$desc" ]]; then
      printf '    %s%s%s\n' "$C_DIM" "$desc" "$C_RESET"
    fi
  done
  hr
}

cmd_status() {
  local target="$1"
  local skills
  mapfile -t skills < <(discover_skills)
  if [[ "${#skills[@]}" -eq 0 ]]; then
    warn "No skills found in $SKILLS_SRC"
    return 1
  fi
  info "Install target: $target"
  hr
  local installed=0
  for s in "${skills[@]}"; do
    if [[ -f "$target/$s/SKILL.md" ]]; then
      printf '  %s✓%s  %s  %s(installed)%s\n' "$C_GREEN" "$C_RESET" "$s" "$C_DIM" "$C_RESET"
      installed=$((installed + 1))
    else
      printf '  %s·%s  %s  %s(not installed)%s\n' "$C_DIM" "$C_RESET" "$s" "$C_DIM" "$C_RESET"
    fi
  done
  hr
  info "$installed of ${#skills[@]} skills installed."
}

cmd_install() {
  local target="$1"
  local force="$2"
  local dry_run="$3"

  local skills
  mapfile -t skills < <(discover_skills)
  if [[ "${#skills[@]}" -eq 0 ]]; then
    fail "No skills found in $SKILLS_SRC"
    return 1
  fi

  info "Installing ${#skills[@]} skill(s) into:"
  printf '    %s\n' "$target"
  [[ "$dry_run" == "1" ]] && warn "Dry run — no files will be written."
  hr

  if [[ "$dry_run" != "1" ]]; then
    mkdir -p "$target"
  fi

  local count_new=0 count_updated=0 count_skipped=0

  for s in "${skills[@]}"; do
    local src="$SKILLS_SRC/$s"
    local dst="$target/$s"

    if [[ -d "$dst" ]]; then
      if [[ "$force" != "1" ]]; then
        printf '  %s·%s  %s  %s(exists, skipped; pass --force to overwrite)%s\n' \
          "$C_YELLOW" "$C_RESET" "$s" "$C_DIM" "$C_RESET"
        count_skipped=$((count_skipped + 1))
        continue
      fi
      if [[ "$dry_run" != "1" ]]; then
        rm -rf "$dst"
      fi
      count_updated=$((count_updated + 1))
    else
      count_new=$((count_new + 1))
    fi

    if [[ "$dry_run" == "1" ]]; then
      printf '  %s→%s  %s  %s(would copy)%s\n' \
        "$C_BLUE" "$C_RESET" "$s" "$C_DIM" "$C_RESET"
    else
      cp -R "$src" "$dst"
      printf '  %s✓%s  %s\n' "$C_GREEN" "$C_RESET" "$s"
    fi
  done

  hr
  ok "Done. $count_new new · $count_updated updated · $count_skipped skipped."
  if [[ "$dry_run" != "1" ]]; then
    info "Restart your Claude harness (Claude Code, Antigravity, etc.) for skills to register."
  fi
}

cmd_uninstall() {
  local target="$1"
  local dry_run="$2"

  local skills
  mapfile -t skills < <(discover_skills)
  if [[ "${#skills[@]}" -eq 0 ]]; then
    fail "No skills found in $SKILLS_SRC to reference for uninstall"
    return 1
  fi

  info "Removing ${#skills[@]} skill(s) from:"
  printf '    %s\n' "$target"
  [[ "$dry_run" == "1" ]] && warn "Dry run — no files will be removed."
  hr

  local count_removed=0 count_missing=0
  for s in "${skills[@]}"; do
    local dst="$target/$s"
    if [[ -d "$dst" ]]; then
      if [[ "$dry_run" == "1" ]]; then
        printf '  %s→%s  %s  %s(would remove)%s\n' \
          "$C_BLUE" "$C_RESET" "$s" "$C_DIM" "$C_RESET"
      else
        rm -rf "$dst"
        printf '  %s✗%s  %s  %s(removed)%s\n' "$C_GREEN" "$C_RESET" "$s" "$C_DIM" "$C_RESET"
      fi
      count_removed=$((count_removed + 1))
    else
      printf '  %s·%s  %s  %s(not present)%s\n' "$C_DIM" "$C_RESET" "$s" "$C_DIM" "$C_RESET"
      count_missing=$((count_missing + 1))
    fi
  done

  hr
  ok "Done. $count_removed removed · $count_missing not present."
}

# ---- argument parsing ---------------------------------------------------

CMD=""
TARGET="$DEFAULT_TARGET"
USE_PROJECT=0
FORCE=0
DRY_RUN=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    install|uninstall|list|status|help)
      if [[ -z "$CMD" ]]; then
        CMD="$1"
      else
        fail "Unexpected argument: $1 (command already set to: $CMD)"
        exit 2
      fi
      shift
      ;;
    --target)
      if [[ $# -lt 2 ]]; then fail "--target requires an argument"; exit 2; fi
      TARGET="$2"
      shift 2
      ;;
    --project)
      USE_PROJECT=1
      shift
      ;;
    --force|-f)
      FORCE=1
      shift
      ;;
    --dry-run|-n)
      DRY_RUN=1
      shift
      ;;
    -h|--help)
      cmd_help
      exit 0
      ;;
    *)
      fail "Unknown argument: $1"
      echo
      cmd_help
      exit 2
      ;;
  esac
done

[[ -z "$CMD" ]] && CMD="install"

if [[ "$USE_PROJECT" == "1" ]]; then
  TARGET="$PROJECT_TARGET"
fi

# ---- sanity checks ------------------------------------------------------

if [[ ! -d "$SKILLS_SRC" ]]; then
  fail "Skills source directory not found: $SKILLS_SRC"
  fail "Run this script from the repository root, where ./skills/ lives."
  exit 1
fi

# ---- dispatch -----------------------------------------------------------

case "$CMD" in
  help)      cmd_help ;;
  list)      cmd_list ;;
  status)    cmd_status "$TARGET" ;;
  install)   cmd_install   "$TARGET" "$FORCE" "$DRY_RUN" ;;
  uninstall) cmd_uninstall "$TARGET" "$DRY_RUN" ;;
  *)
    fail "Unknown command: $CMD"
    cmd_help
    exit 2
    ;;
esac
