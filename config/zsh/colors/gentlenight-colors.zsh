# crimson = '#cf1550',
# red = '#f05988',
# orange = '#faa45d',
# darkredorange = '#ff7680',
# redorange = '#ff8080',
# darkmauve = '#c28894',
# orchid = '#d66fd7',
# yellow = '#ffcb67',
# green = '#32a852',
# lime = '#43e870',
# olivegreen = '#98c279',
# teal = '#4Ec9b2',
# lightblue = '#9cdcfe',
# blue = '#42a6f8',
# bluegray = '#7694b4',
# lightgray = '#b0b5c2',
# gray = '#8893b3',
# darkgray = '#7f848e',
# purple = '#8a7dff',
# brown = '#d19a66',
# white = '#ffffff',
# black = '#1b1e2b',
#
# --UI
# bg = '#292d3e',
# fg = '#dcdcdc',
# selection = '#333851',
# statusline = '#963e3e',
# menu_bg = '#2d3144',
# menu_sel = '#4d5478',
# fold = '#6d76a3',
# split = '#515982',
# none = 'NONE',

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main cursor)
typeset -gA ZSH_HIGHLIGHT_STYLES

# Main highlighter styling: https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md
#
## General
### Diffs
### Markup
## Classes
## Comments
ZSH_HIGHLIGHT_STYLES[comment]='fg=#7f848e'
## Constants
## Entitites
## Functions/methods
ZSH_HIGHLIGHT_STYLES[alias]='fg=#32a852'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#32a852'
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#32a852'
ZSH_HIGHLIGHT_STYLES[function]='fg=#32a852'
ZSH_HIGHLIGHT_STYLES[command]='fg=#32a852'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#32a852,italic'
ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=#c28894,italic'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#faa45d'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#faa45d'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#faa45d'
## Keywords
## Built ins
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#32a852'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#32a852'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#32a852'
## Punctuation
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#c28894'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=#9cdcfe'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-unquoted]='fg=#9cdcfe'
ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=#9cdcfe'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]='fg=#c28894'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#c28894'
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=#c28894'
## Serializable / Configuration Languages
## Storage
## Strings
ZSH_HIGHLIGHT_STYLES[command-substitution-quoted]='fg=#d66fd7'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-quoted]='fg=#d66fd7'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#d66fd7'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]='fg=#b0b5c2'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#d66fd7'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]='fg=#b0b5c2'
ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=#d66fd7'
## Variables
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#9cdcfe'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument-unclosed]='fg=#b0b5c2'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#9cdcfe'
ZSH_HIGHLIGHT_STYLES[assign]='fg=#9cdcfe'
ZSH_HIGHLIGHT_STYLES[named-fd]='fg=#9cdcfe'
ZSH_HIGHLIGHT_STYLES[numeric-fd]='fg=#9cdcfe'
## No category relevant in spec
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#b0b5c2'
ZSH_HIGHLIGHT_STYLES[path]='fg=#9cdcfe,underline'
ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#c28894,underline'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#9cdcfe,underline'
ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='fg=#c28894,underline'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#9cdcfe'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#faa45d'
#ZSH_HIGHLIGHT_STYLES[command-substitution]='fg=?'
#ZSH_HIGHLIGHT_STYLES[command-substitution-unquoted]='fg=?'
#ZSH_HIGHLIGHT_STYLES[process-substitution]='fg=?'
#ZSH_HIGHLIGHT_STYLES[arithmetic-expansion]='fg=?'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-unclosed]='fg=#b0b5c2'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#9cdcfe'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=#9cdcfe'
ZSH_HIGHLIGHT_STYLES[default]='fg=#9cdcfe'
ZSH_HIGHLIGHT_STYLES[cursor]='fg=#9cdcfe'
