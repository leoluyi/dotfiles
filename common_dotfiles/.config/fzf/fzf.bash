# Setup fzf
# ---------
[ -d /usr/local/opt/fzf ] && _fzf_path=/usr/local/opt/fzf
[ -d /opt/homebrew/opt/fzf ] && _fzf_path=/opt/homebrew/opt/fzf
[ -d "$HOME/.fzf" ] && _fzf_path="$HOME/.fzf"

[ -z "$_fzf_path" ] && return 0

if [[ ! "$PATH" == "*${_fzf_path}/bin*" ]]; then
  export PATH="${PATH:+${PATH}:}${_fzf_path}/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "${_fzf_path}/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "${_fzf_path}/shell/key-bindings.bash"
