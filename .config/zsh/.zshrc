
HISTFILE=~/.cache/zsh/history
HISTSIZE=500

SAVEHIST=1000
setopt autocd extendedglob nomatch
unsetopt beep
bindkey -v
zstyle :compinstall filename '/home/bruh/.zshrc'

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION
_comp_options+=(globdots)		# Include hidden files.

#nsrc () {
#	nvim src/main* $(/usr/bin/ls -X src | tr '\n' ' ' | sed -e 's/ / src\//g' | sed -e 's/^/src\//' | sed -e 's/ src\/$//')
#}
nsrc () {
	nvim src/main* 2>/dev/null || nvim src/bin/main* 2>/dev/null || nvim src/
}

c () {
	tmp="$(exa -aa1D| fzf --reverse)"
	if [ $tmp ]; then
		cd $tmp
	fi
}

#export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[2 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[4 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[4 q"
}
zle -N zle-line-init
echo -ne '\e[4 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[4 q' ;} # Use beam shape cursor for each new prompt.

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lfub -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' 'lfcd\n'

bindkey -s '^P' 'lazygit\n'

bindkey -s '^N' 'nvim -c "Telescope oldfiles"\n'

bindkey -s '^W' 'wiki\n'

# Prompt ZSH
autoload -U colors && colors
PS1="%B%{$fg[cyan]%}%~%{$fg[magenta]%} ❯ %{$reset_color%}%b"
PS2="%B%{$fg[magenta]%}❯ %{$reset_color%}%b"

alias bluetooth="bluetoothctl"
alias getweather="curl wttr.in/west+bloomfield+township/\?m && cal && date"
alias cbonsair="cbonsai --seed 119"
alias offon="doas loginctl reboot"
alias offnow="doas loginctl poweroff"
alias discordgpu="LIBVA_DRIVER_NAME=i915 discord --enable-gpu-rasterization &"
alias sudo="doas"
alias locknow="loginctl suspend && betterlockscreen -l blur"
alias block="betterlockscreen -l blur"
alias reboot="doas loginctl reboot"
alias poweroff="doas loginctl poweroff"
alias fortnite="osu"
alias nvimconf="nvim ~/.config/nvim/init.vim"
alias vim="nvim"
alias nano="nvim"
alias dwm-conf="cd ~/gitclone/suckless/dwm && nvim ~/gitclone/suckless/dwm/config.h"
alias osu-dir="cd ~/.local/share/osu-wine/OSU/"
alias skool="cd ~/Documents/vimwiki/school/"
alias xinitrc="nvim ~/.xinitrc"
alias codef="cd ~/Documents/code"
alias todo="nvim ~/Documents/wiki/todo.wiki"
alias vi="nvim"
alias l="exa -a1 --icons --sort=type"
alias ls="exa -a --icons --sort=type"
alias nsxiv="devour nsxiv"
alias mupdf="devour mupdf"
alias zathura="devour zathura"
alias n="nsxiv . -t"
alias nshuf="/usr/bin/ls {*jpg,*png,*jpeg,*gif} | shuf | nsxiv -iat"
alias newsboat="newsboat -u ~/.config/newsboat/urls"
alias mocp="ncmpcpp"
alias lf="lfub"
alias startx="startx $XINITRC"
alias wiki="nvim ~/Documents/wiki/index.wiki"
alias svim="sudoedit"
alias gbookmark="nvim ~/.local/share/bookmarks/bookmarks"
alias bc="bc --mathlib"
alias uncrustify="uncrustify -c ~/.config/uncrustify/uncrustify.cfg"
alias rs="rsync -urvP"
alias wget=wget --hsts-file="$XDG_DATA_HOME/wget-hsts"
alias yta="yt-dlp -x --audio-format mp3"

# Load zsh-syntax-highlighting; should be last.
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
. /usr/share/z/z.sh
