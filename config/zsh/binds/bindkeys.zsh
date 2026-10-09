bindkey "^K"     kill-whole-line                       # ctrl-k
bindkey "^R"     history-incremental-search-backward   # ctrl-r
bindkey "^A"     beginning-of-line                     # ctrl-a
bindkey "^E"     end-of-line                           # ctrl-e
bindkey "[B"     history-search-forward                # down arrow
bindkey "[A"     history-search-backward               # up arrow

# Use hjlk in menu selection (during completion)
# Doesn't work well with interactive mode
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'l' vi-forward-char
