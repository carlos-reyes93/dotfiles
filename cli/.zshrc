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
alias ls="ls -lh --color"
alias pbcopy="xclip -selection clipboard"
alias pbpaste="xclip -selection clipboard -o"
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"
eval "$(pyenv virtualenv-init -)"
PATH="$HOME/.local/bin:$PATH"
