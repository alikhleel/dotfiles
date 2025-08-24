# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[ -f "${ZDOTDIR}/aliasrc" ] && source "${ZDOTDIR}/aliasrc"
[ -f "${ZDOTDIR}/optionrc" ] && source "${ZDOTDIR}/optionrc"
[ -f "${ZDOTDIR}/pluginrc" ] && source "${ZDOTDIR}/pluginrc"

# history
HISTSIZE=110000
SAVEHIST=100000
HISTFILE=~/.histfile

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export PATH="$HOME/.local/bin/scripts:$PATH"

zmodload zsh/terminfo

bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# Extra bindings for different terminals
bindkey '^[OA' history-substring-search-up
bindkey '^[[A' history-substring-search-up
bindkey '^[OB' history-substring-search-down
bindkey '^[[B' history-substring-search-down
bindkey -s '^F' 'tmux-sessionizer\n'


autoload -U colors && colors        # Load color definitions
autoload -U zcalc                   # calculator module

autoload -Uz compinit               # Load completion system
compinit                            # Initialize completion

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'

# Colored completion list
zstyle ':completion:*' list-colors "${(s.:.)--color=auto}"

# Automatically find new executables in $PATH
zstyle ':completion:*' rehash true

# Menu selection mode for completions
zstyle ':completion:*' menu select

# Colored Man Pages
export LESS_TERMCAP_mb=$'\e[01;32m'     # Bold green 
export LESS_TERMCAP_md=$'\e[01;32m'     # Bold green
export LESS_TERMCAP_me=$'\e[0m'         # Reset
export LESS_TERMCAP_se=$'\e[0m'         # End standout
export LESS_TERMCAP_so=$'\e[01;47;34m'  # Standout: white bg, blue text
export LESS_TERMCAP_ue=$'\e[0m'         # End underline
export LESS_TERMCAP_us=$'\e[01;36m'     # Underline: cyan
export LESS=-R                          # Interpret raw ANSI colors

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
