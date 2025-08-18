# now, simply add these two lines in your ~/.zshrc
# source antidote
source '/usr/share/zsh-antidote/antidote.zsh'
# initialize plugins statically with ${ZDOTDIR:-~}/.zsh_plugins.txt
antidote load

autoload -Uz promptinit && promptinit && prompt pure
#eval "$(pyenv init -)"
# make sure the --git-dir is the same as the
# directory where you created the repo above.
# alias config="git --git-dir=$HOME/.dotfiles --work-tree=$HOME"

TMUX_PATH=$HOME/.config/tmux/tmux.conf
# NOTE FZF
source <(fzf --zsh)
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git "
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
export FZF_DEFAULT_OPTS="--height 50% --layout=default --border --color=hl:#2dd4bf"
# TMUX FZF Options
export FZF_TMUX_OPTS=" -p90%,70%"

# Setup fzf previews using BAT
export FZF_CTRL_T_OPTS="--preview 'bat --color=always -n --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

#aliases

alias tmux=tmux -f $TMUX_PATH
alias ls="ls -lh --color"
alias pbcopy="xclip -selection clipboard"
alias pbpaste="xclip -selection clipboard -o"
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"
eval "$(pyenv virtualenv-init -)"
PATH="$HOME/.local/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/carlos/google-cloud-sdk/path.zsh.inc' ]; then . '/home/carlos/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/carlos/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/carlos/google-cloud-sdk/completion.zsh.inc'; fi
