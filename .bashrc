# ~/.bashrc: executed by bash(1) for non-login shells.
# ------------------------------------------------------------
# Color Palettes
# ------------------------------------------------------------
# Rouge theme colors
ROUGE_USER_COLOR="\[\033[38;5;214m\]"   # Golden Yellow (#E5C07B)
ROUGE_HOST_COLOR="\[\033[38;5;208m\]"   # Warm Orange (#D19A66)
ROUGE_DIR_COLOR="\[\033[38;5;167m\]"    # Purple (#C678DD)
ROUGE_MODIFIED_COLOR="\[\033[38;5;203m\]"  # Soft Red (#E06C75)
ROUGE_ADDED_COLOR="\[\033[38;5;208m\]"     # Warm Orange (#D19A66)
ROUGE_DELETED_COLOR="\[\033[38;5;167m\]"   # Purple (#C678DD)
ROUGE_UNTRACKED_COLOR="\[\033[38;5;214m\]" # Golden Yellow (#E5C07B)
ROUGE_PROMPT_SYMBOL_COLOR="\[\033[38;5;141m\]" # Soft Cyan (#56B6C2)
ROUGE_RESET="\[\033[0m\]"

# Atom One Dark theme colors
ATOM_USER_COLOR="\[\033[38;5;75m\]"        # Blue (#61AFEF)
ATOM_HOST_COLOR="\[\033[38;5;108m\]"       # Green (#98C379)
ATOM_DIR_COLOR="\[\033[38;5;204m\]"        # Pink (#C678DD)
ATOM_MODIFIED_COLOR="\[\033[38;5;203m\]"   # Red (#E06C75)
ATOM_ADDED_COLOR="\[\033[38;5;180m\]"      # Yellow (#E5C07B)
ATOM_DELETED_COLOR="\[\033[38;5;131m\]"    # Orange (#D19A66)
ATOM_UNTRACKED_COLOR="\[\033[38;5;245m\]"  # Gray (#5C6370)
ATOM_PROMPT_SYMBOL_COLOR="\[\033[38;5;247m\]" # Light Gray (#ABB2BF)
ATOM_RESET="\[\033[0m\]"


# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# if not set then:
#THEME=${THEME:-"ATOM"}
THEME=${THEME:-"ROUGE"}

# ------------------------------------------------------------
# Aliases
# ------------------------------------------------------------
alias ls='ls --color=auto'
alias ll='ls -lah'
alias grep='grep --color=auto'
alias vi='vim'
alias ..='cd ..'
alias ...='cd ../..'

# ------------------------------------------------------------
# Evals
# ------------------------------------------------------------
if command -v direnv &>/dev/null; then
    eval "$(direnv hook bash)"
fi

# ------------------------------------------------------------
# Git Status Count
# ------------------------------------------------------------
# Function to fetch Git status counts
git_status_counts_prompt() {
    # Check if inside a Git repositoryp
    if git rev-parse --is-inside-work-tree &>/dev/null; then
	
	local branch=$(git symbolic-ref --short HEAD)
	
	local modified=$(git status --porcelain | grep -c '^ M')
	local added=$(git status --porcelain | grep -c '^A')
	local deleted=$(git status --porcelain | grep -c '^D')
	local untracked=$(git status --porcelain | grep -c '^??')
	
	# Initialize the Git status part of the prompt
	local git_status=""

	# Format the status counts for the prompt
	if [ "$THEME" = "ROUGE" ]; then
	    # Append status counts to the git_status variable if they are greater than 
            [ "$modified" -gt 0 ] && git_status+="${ROUGE_MODIFIED_COLOR}M:$modified "
            [ "$added" -gt 0 ] && git_status+="${ROUGE_ADDED_COLOR}A:$added "
            [ "$deleted" -gt 0 ] && git_status+="${ROUGE_DELETED_COLOR}D:$deleted "
            [ "$untracked" -gt 0 ] && git_status+="${ROUGE_UNTRACKED_COLOR}U:$untracked "
            # Add commits ahead and behind to the status string if they are not zero
            git_status+="${ROUGE_DIR_COLOR}($branch) "
	else
            # Append status counts to the git_status variable if they are greater than 
            [ "$modified" -gt 0 ] && git_status+="${ATOM_MODIFIED_COLOR}M:$modified "
            [ "$added" -gt 0 ] && git_status+="${ATOM_ADDED_COLOR}A:$added "
            [ "$deleted" -gt 0 ] && git_status+="${ATOM_DELETED_COLOR}D:$deleted "
            [ "$untracked" -gt 0 ] && git_status+="${ATOM_UNTRACKED_COLOR}U:$untracked "
            # Add commits ahead and behind to the status string if they are not zero
            git_status+="${ATOM_DIR_COLOR}($branch) "
	fi

	echo "$git_status "
    else
	echo ""
    fi
}

# ------------------------------------------------------------
# Prompt
# ------------------------------------------------------------
# Atom One Dark theme colors and Git
ATOM_GIT="${ATOM_USER_COLOR}\u@${ATOM_HOST_COLOR}\h ${ATOM_DIR_COLOR}\w $(git_status_counts_prompt)${ATOM_PROMPT_SYMBOL_COLOR}\$${ATOM_RESET} "
	
# Rouge theme colors and Git 
ROUGE_GIT="${ROUGE_USER_COLOR}\u@${ROUGE_HOST_COLOR}\h ${ROUGE_DIR_COLOR}\w $(git_status_counts_prompt)${ROUGE_PROMPT_SYMBOL_COLOR}\$${ROUGE_RESET} "

export PS1="${ROUGE_GIT}"

# ------------------------------------------------------------
# Path
# ------------------------------------------------------------
export PATH=$HOME/bin:/usr/local/bin:$PATH

# ------------------------------------------------------------
# Environment Variables
# ------------------------------------------------------------
export EDITOR=micro
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoredups:erasedups
export HISTIGNORE="&:ls:[bf]g:exit"
shopt -s histappend

# ------------------------------------------------------------
# History Search
# ------------------------------------------------------------
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# ------------------------------------------------------------
# Aliases for Safety
# ------------------------------------------------------------
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# ------------------------------------------------------------
# Functions
# ------------------------------------------------------------
# Extract function for various archive formats
extract() {
    if [ -f "$1" ] ; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1" ;;
            *.tar.gz)    tar xzf "$1" ;;
            *.bz2)       bunzip2 "$1" ;;
            *.rar)       unrar x "$1" ;;
            *.gz)        gunzip "$1" ;;
            *.tar)       tar xf "$1" ;;
            *.tbz2)      tar xjf "$1" ;;
            *.tgz)       tar xzf "$1" ;;
            *.zip)       unzip "$1" ;;
            *.Z)         uncompress "$1" ;;
            *.7z)        7z x "$1" ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}
# ------------------------------------------------------------
# Source Other Files
# ------------------------------------------------------------
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Reload bashrc
alias reload='source ~/.bashrc'
