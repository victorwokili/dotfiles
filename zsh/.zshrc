###############################################
####        ZSH CONFIG (STOW VERSION)      ####
###############################################

# Instant prompt (safe to keep)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Oh My Zsh path
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Load P10k config
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Colors
autoload -Uz colors && colors

# Nice ls colors
alias ls='ls -G'
export LSCOLORS="ExFxBxDxCxegedabagacad"
