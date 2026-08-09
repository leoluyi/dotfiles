#!/bin/bash
set -f

input=$(cat)

# ── Colors ──────────────────────────────────────────────
blue='\033[38;2;0;153;255m'
orange='\033[38;2;255;176;85m'
green='\033[38;2;0;175;80m'
cyan='\033[38;2;86;182;194m'
red='\033[38;2;255;85;85m'
yellow='\033[38;2;230;200;0m'
white='\033[38;2;220;220;220m'
magenta='\033[38;2;180;140;255m'
dim='\033[2m'
reset='\033[0m'

sep=" ${dim}│${reset} "

color_for_pct() {
    local pct=$1
    if [ "$pct" -ge 90 ]; then printf "$red"
    elif [ "$pct" -ge 70 ]; then printf "$yellow"
    elif [ "$pct" -ge 50 ]; then printf "$orange"
    else printf "$green"
    fi
}

build_bar() {
    local pct=$1
    local width=${2:-10}
    [ "$pct" -lt 0 ] 2>/dev/null && pct=0
    [ "$pct" -gt 100 ] 2>/dev/null && pct=100

    local filled=$(( pct * width / 100 ))
    local empty=$(( width - filled ))
    local bar_color
    bar_color=$(color_for_pct "$pct")

    local filled_str="" empty_str=""
    for ((i=0; i<filled; i++)); do filled_str+="●"; done
    for ((i=0; i<empty; i++)); do empty_str+="○"; done

    printf "${bar_color}${filled_str}${dim}${empty_str}${reset}"
}

# ── Parse Input ─────────────────────────────────────────
model_name=""
pct_used=""
agent_state=""
cwd=""

if [ -n "$input" ] && echo "$input" | jq -e . >/dev/null 2>&1; then
    model_name=$(echo "$input" | jq -r '.model.name // .model // .session.model // empty')
    pct_used=$(echo "$input" | jq -r '.context.pct // .context_usage // .usage.context_percent // empty' | awk '{printf "%.0f", $1}' 2>/dev/null)
    if [ -z "$pct_used" ]; then
        used=$(echo "$input" | jq -r '.context.used_tokens // .usage.input_tokens // 0' 2>/dev/null)
        total=$(echo "$input" | jq -r '.context.total_tokens // .context.max_tokens // 200000' 2>/dev/null)
        if [ "$total" -gt 0 ] 2>/dev/null; then
            pct_used=$(( used * 100 / total ))
        fi
    fi
    agent_state=$(echo "$input" | jq -r '.session.state // .agent_state // .status // empty')
    cwd=$(echo "$input" | jq -r '.workspace.cwd // .cwd // empty')
fi

[ -z "$model_name" ] && model_name="Gemini 3.6 Flash"
[ -z "$pct_used" ] && pct_used=0
[ -z "$cwd" ] && cwd="$PWD"
dirname=$(basename "$cwd")

# ── Git Info ────────────────────────────────────────────
git_branch=""
git_dirty=""
if command -v git >/dev/null 2>&1; then
    git_branch=$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [ -n "$git_branch" ]; then
        if [ -n "$(git -C "$cwd" status --porcelain 2>/dev/null)" ]; then
            git_dirty="*"
        fi
    fi
fi

# ── Render Line ─────────────────────────────────────────
ctx_bar=$(build_bar "$pct_used" 10)
pct_color=$(color_for_pct "$pct_used")

line="${blue}${model_name}${reset}"
line+="${sep}"
line+="✍️  ${ctx_bar} ${pct_color}${pct_used}%${reset}"
line+="${sep}"
line+="${cyan}${dirname}${reset}"

if [ -n "$git_branch" ]; then
    line+=" ${green}(${git_branch}${red}${git_dirty}${green})${reset}"
fi

if [ -n "$agent_state" ]; then
    line+="${sep}"
    case "$agent_state" in
        *thinking*|*Thinking*) line+="${yellow}🤔 ${agent_state}${reset}" ;;
        *executing*|*Executing*|*running*|*Running*) line+="${magenta}⚡ ${agent_state}${reset}" ;;
        *idle*|*Idle*) line+="${dim}💤 ${agent_state}${reset}" ;;
        *) line+="${dim}● ${agent_state}${reset}" ;;
    esac
fi

printf "%b\n" "$line"
