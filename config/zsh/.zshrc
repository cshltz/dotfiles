#ls colors, gentlenight dusk palette (matches wezterm + nvim): blue #42a6f8, green #32a852,
#teal #4ec9b2, yellow #ffcb67, orchid #d66fd7, red #f05988, orange #faa45d, purple #8a7dff.
#truecolor (38;2;r;g;b) is fine in wezterm; also ends the blue-on-green ow/di on drvfs mounts.
LS_COLORS='di=01;38;2;66;166;248:ln=38;2;78;201;178:ex=38;2;50;168;82:pi=38;2;214;111;215:so=38;2;214;111;215:do=38;2;214;111;215:bd=38;2;255;203;103:cd=38;2;255;203;103:su=01;38;2;240;89;136:sg=01;38;2;250;164;93:ow=38;2;66;166;248:tw=01;38;2;66;166;248:st=01;38;2;66;166;248:mi=38;2;240;89;136:or=38;2;240;89;136:*.tar=38;2;240;89;136:*.tgz=38;2;240;89;136:*.tbz=38;2;240;89;136:*.tbz2=38;2;240;89;136:*.txz=38;2;240;89;136:*.gz=38;2;240;89;136:*.bz2=38;2;240;89;136:*.xz=38;2;240;89;136:*.Z=38;2;240;89;136:*.zip=38;2;240;89;136:*.zst=38;2;240;89;136:*.png=38;2;214;111;215:*.jpg=38;2;214;111;215:*.jpeg=38;2;214;111;215:*.gif=38;2;214;111;215:*.bmp=38;2;214;111;215:*.svg=38;2;214;111;215:*.webp=38;2;214;111;215:*.ico=38;2;214;111;215:*.tif=38;2;214;111;215:*.tiff=38;2;214;111;215:*.ttf=38;2;214;111;215:*.otf=38;2;214;111;215:*.woff=38;2;214;111;215:*.woff2=38;2;214;111;215:*.mp3=38;2;250;164;93:*.m4a=38;2;250;164;93:*.flac=38;2;250;164;93:*.ogg=38;2;250;164;93:*.opus=38;2;250;164;93:*.wav=38;2;250;164;93:*.mp4=38;2;138;125;255:*.mkv=38;2;138;125;255:*.avi=38;2;138;125;255:*.mov=38;2;138;125;255:*.webm=38;2;138;125;255:*.pdf=38;2;255;128;128:'
export LS_COLORS

#nvm (node version manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

autoload -U compinit; compinit
_comp_options+=(globdots)


source $ZDOTDIR/completion/completion.zsh
source $ZDOTDIR/alias/aliases.zsh
source $ZDOTDIR/prompt/prompt.zsh

source $ZDOTDIR/colors/gentlenight-colors.zsh
source $ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
