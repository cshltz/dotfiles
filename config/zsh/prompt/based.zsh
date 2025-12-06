source $ZDOTDIR/colors/catpp-colors.zsh

# Based on:

# Purity
# by Kevin Lanni
# https://github.com/therealklanni/purity
# MIT License

# prompt:
# %F => color dict
# %f => reset color
# %~ => current path
# %* => time
# %n => username
# %m => shortname host
# %(?..) => prompt conditional - %(condition.true.false)

# Display git status
# TODO to refactor with switch / using someting else than grep
# Might be faster using ripgrep too
git_prompt_status() {
  local INDEX STATUS

  INDEX=$(command git status --porcelain -b 2> /dev/null)

  STATUS=""

  if $(echo "$INDEX" | command grep -E '^\?\? ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_UNTRACKED$STATUS"
  fi

  if $(echo "$INDEX" | grep '^A  ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_ADDED$STATUS"
  elif $(echo "$INDEX" | grep '^M  ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_ADDED$STATUS"
  elif $(echo "$INDEX" | grep '^MM ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_ADDED$STATUS"
  fi

  if $(echo "$INDEX" | grep '^ M ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
  elif $(echo "$INDEX" | grep '^AM ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
  elif $(echo "$INDEX" | grep '^MM ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
  elif $(echo "$INDEX" | grep '^ T ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
  fi

  if $(echo "$INDEX" | grep '^R  ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_RENAMED$STATUS"
  fi

  if $(echo "$INDEX" | grep '^ D ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$STATUS"
  elif $(echo "$INDEX" | grep '^D  ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$STATUS"
  elif $(echo "$INDEX" | grep '^AD ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$STATUS"
  fi

  if $(command git rev-parse --verify refs/stash >/dev/null 2>&1); then
    STATUS="$ZSH_THEME_GIT_PROMPT_STASHED$STATUS"
  fi

  if $(echo "$INDEX" | grep '^UU ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_UNMERGED$STATUS"
  fi

  if $(echo "$INDEX" | grep '^## [^ ]\+ .*ahead' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_AHEAD$STATUS"
  fi

  if $(echo "$INDEX" | grep '^## [^ ]\+ .*behind' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_BEHIND$STATUS"
  fi

  if $(echo "$INDEX" | grep '^## [^ ]\+ .*diverged' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_DIVERGED$STATUS"
  fi

  if [[ ! -z "$STATUS" ]]; then
    echo " [ $STATUS]"
  fi
}

prompt_git_branch() {
    autoload -Uz vcs_info 
    precmd_vcs_info() { vcs_info }
    precmd_functions+=( precmd_vcs_info )
    setopt prompt_subst
    zstyle ':vcs_info:git:*' formats '%b'
}

prompt_git_info() {
    [ ! -z "$vcs_info_msg_0_" ] && echo "$ZSH_THEME_GIT_PROMPT_PREFIX%F{white}$vcs_info_msg_0_%f$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

prompt_purity_precmd() {
    # Pass a line before each prompt
    print -P ''
}

prompt_purification_setup() {
    # Display git branch

    autoload -Uz add-zsh-hook
    add-zsh-hook precmd prompt_purity_precmd

    ZSH_THEME_GIT_PROMPT_PREFIX=" %F{${catppuccin_red}}λ%f:"
    ZSH_THEME_GIT_PROMPT_DIRTY=""
    ZSH_THEME_GIT_PROMPT_CLEAN=""

    ZSH_THEME_GIT_PROMPT_ADDED="%F{${catppuccin_green}}+%f "
    ZSH_THEME_GIT_PROMPT_MODIFIED="%F{${catppuccin_sapphire}}%f "
    ZSH_THEME_GIT_PROMPT_DELETED="%F{${catppuccin_red}}x%f "
    ZSH_THEME_GIT_PROMPT_RENAMED="%F{${catppuccin_rosewater}➜%f "
    ZSH_THEME_GIT_PROMPT_UNMERGED="%F{${catppuccin_yellow}}═%f "
    ZSH_THEME_GIT_PROMPT_UNTRACKED="%F{${catpuccin_base}}%f "
    ZSH_THEME_GIT_PROMPT_STASHED="%B%F{${catppuccin_red}}%f%b "
    ZSH_THEME_GIT_PROMPT_BEHIND="%B%F{${catppuccin_red}}%f%b "
    ZSH_THEME_GIT_PROMPT_AHEAD="%B%F{${catppuccin_green}}%f%b "

# prompt:
# %F => color dict
# %f => reset color
# %~ => current path
# %* => time
# %n => username
# %m => shortname host
# %(?..) => prompt conditional - %(condition.true.false)
    prompt_git_branch
    RPROMPT='%F{green}%F{white}:%~ $(prompt_git_info) $(git_prompt_status)'
    PROMPT=$'%F{red}%n %B%F{red}󰅂%f%b '
}

prompt_purification_setup
