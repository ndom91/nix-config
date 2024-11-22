if [ -f /usr/bin/exa ]; then
  alias ll='exa --icons -l -a --group-directories-first --time-style long-iso --classify --group'
  alias ls='exa --icons --group-directories-first --classify'
  alias tree='exa --long --tree --time-style long-iso --icons --group'
fi

alias hn='hostname'
alias topfolders='sudo du -hs * | sort -rh | head -5'
alias topfiles='sudo find -type f -exec du -Sh {} + | sort -rh | head -n 5'

# Typo Fixes
alias suod='sudo'
alias sduo='sudo'
alias udso='sudo'
alias suod='sudo'
alias sodu='sudo'

alias whcih='which'
alias whchi='which'
alias wchih='which'

alias cd.='cd ..'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'
alias .4='cd ../../../../../'
alias .5='cd ../../../../../../'

[[ "$(command -v xclip)" ]] && alias xc='xclip -selection c'
[[ "$(command -v lazygit)" ]] && alias lg="lazygit"
[[ "$(command -v rg)" ]] && alias grep='rg'
[[ "$(command -v fdfind)" ]] && alias find='fdfind'
[[ "$(command -v fdfind)" ]] && alias fd='fdfind'
[[ "$(command -v nvim)" ]] && alias vim='nvim'

if [ "$(command -v git)" ]; then
  alias cob='git checkout $(git branch -a | cut -c 3- | pick)'
  alias gs='git status'
  alias gss='git status --short'
  alias gd='git diff'
  alias gp='git pull'
  alias gl='git log --oneline --color | emojify | most'
  alias gm='gitmoji -c'
  alias g='git'
  alias gpb='git push origin `git rev-parse --abbrev-ref HEAD`'
  alias gpl='git pull origin `git rev-parse --abbrev-ref HEAD`'
  alias glb='git checkout $(git for-each-ref --sort=-committerdate --count=20 --format="%(refname:short)" refs/heads/ | fzf)'
  alias ds='dot status'
  alias ddi='dot diff'
  alias gitroot='cd "$(git rev-parse --show-toplevel)"'
fi

