export PATH="$HOME/.keys/scripts:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export EDITOR=nano
export COLORTERM=truecolor
#export TERM="xterm-kitty"
export TERM=xterm-256color

#ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_UNICODE=true
HISTFILE=~/.cache/zshhistory
HISTSIZE=100000
SAVEHIST=100000

#setopt noglob #    * ^ # ? gibi karakterlerin shell tarafından özel wildcard olarak algılanmamasını sağlıyor
setopt autocd beep extendedglob		# nomatch
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
autoload -Uz compinit && compinit	# zsh autocomplete init

function zsh_add_file() {
    [ -f "$ZDOTDIR/$1" ] && source "$ZDOTDIR/$1"
}

function zsh_add_plugin() {
    PLUGIN_NAME=$(echo $1 | cut -d "/" -f 2)
    if [ -d "$ZDOTDIR/plugins/$PLUGIN_NAME" ]; then 
        zsh_add_file "plugins/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh" || \
        zsh_add_file "plugins/$PLUGIN_NAME/$PLUGIN_NAME.zsh"
    else
        git clone "https://github.com/$1.git" "$ZDOTDIR/plugins/$PLUGIN_NAME"
    fi
}

function zsh_add_file_fullpath() {
    [ -f "$1" ] && source "$1"
}

#zsh_add_file "plugins/preferences.zsh"
zsh_add_file_fullpath "$HOME/.keys/preferences.zsh"
zsh_add_file "plugins/prompt.zsh"
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
zsh_add_plugin "hlissner/zsh-autopair"
# zsh_add_plugin "davidde/git"
# For more plugins: https://github.com/unixorn/awesome-zsh-plugins
# More completions https://github.com/zsh-users/zsh-completions

function git-lazy() {
    git add .
    git commit -a -m "$1"
    git push -u origin $(git rev-parse --abbrev-ref HEAD)
}

function git-fixssh() {
	eval $(ssh-agent -s)
	ssh-add $DEFAULT_SSH_KEY
}

function git-create-push(){
    git push --set-upstream-to git@gitlab.com:yemrearslan/$1.git master
}

wifi-setdns(){
	nmcli -g name,type connection show --active | awk -F: '/ethernet|wireless/ { print $1 }' | while read connection
	do
	  nmcli con mod "$connection" ipv6.ignore-auto-dns yes
	  nmcli con mod "$connection" ipv4.ignore-auto-dns yes
	  nmcli con mod "$connection" ipv4.dns "8.8.8.8 8.8.4.4"
	  nmcli con down "$connection" && nmcli con up "$connection"
	done
}
wifi-reconnect(){
	nmcli -g name,type connection show --active | awk -F: '/ethernet|wireless/ { print $1 }' | while read connection
	do
		nmcli con down "$connection" && nmcli con up "$connection"
	done
}

# preferences
alias vi="nvim"
alias vim="vi"
alias sudo='sudo '
alias vimrc="nvim ~/.config/nvim/"
alias sshconfig="$EDITOR ~/.ssh/config"
alias zshrc="$EDITOR ~/.config/zsh/.zshrc"
alias sourcezsh="source ~/.config/zsh/.zshrc"
alias top="btop"
alias mv='mv -iv'
alias cp='cp -iv'
alias ln='ln -iv'

#zsh geçmiş
gecmis() {
  tail -n "${1:-100}" ~/.cache/zshhistory
}

if (( ${+aliases[l]} )); then unalias l; fi
if (( ${+aliases[ls]} )); then unalias ls; fi
if (( ${+aliases[ll]} )); then unalias ll; fi

function l(){ eza $1 --icons }
function ls(){ eza $1 --icons }
function ll(){ eza $1 -lahg --icons }
#alias l='eza --icons'
#alias ls='eza --icons'
#alias ll='eza -lahg --icons'
alias md='mkdir -p'
alias rd='rm -r'
alias mkdir='mkdir -p'
alias grep="grep --color='auto'"
alias wget="wget --hsts-file ~/.config/wget/wget-hsts"
alias gitfetch="onefetch"
alias yt="ytfzf"
#alias ip="ip -c"
alias s="kitty +kitten ssh"
#alias curl="curlie --pretty"
#alias rm='trash' # Use `trash` program instead of built-in irrecoverable way to delete nodes.
#alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# useful
alias kitty-update="curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin"
wifi-connect(){sudo nmcli device wifi connect $1 password $2}
check-port(){ss -plant | grep :$1}	# which pid uses that port
kill-port(){kill -9 $(lsof -t -i tcp:$1)}
burn(){sudo dd if=$1 of=$2 oflag=direct status=progress}
clone(){sudo dd if=$1 status=progress | gzip -c > $2.img.gz}
restore(){sudo umount $2s1; gunzip -cd $1 | sudo dd of=$2 iflag=fullblock status=progress}
alias watchcpu='watch -n.1 "grep \"^[c]pu MHz\" /proc/cpuinfo"'
alias ramspeed='sudo dmidecode --type 17 | grep Speed'
alias down="yt-dlp"
alias mp3="yt-dlp -f bestaudio -x --audio-format mp3 "
#alias mp3="yt-dlp -i --extract-audio --audio-format mp3 --audio-quality 0"
alias mp3playlist="yt-dlp -ict --yes-playlist --extract-audio --audio-format mp3 --audio-quality 0"
alias wifi-on="sudo nmcli radio wifi on"
alias wifi-off="sudo nmcli radio wifi off"
alias wifi-scan="nmcli device wifi list"
alias publicip="curlie ipinfo.io --pretty"
alias pi="curl -L https://ipgrab.io" # ipinfo.io/ip
alias map="telnet mapscii.me"
alias rate="curl usd.rate.sx/eth@30d"
alias matrix="neo-matrix"
#alias monitor-list="xrandr -q | grep ' connected' | head -n 1 | cut -d ' ' -f1"
#alias monitor-off="xrandr --output $(monitor-list) --off"
alias mpv-cli="mpv -vo tct"
alias setupvpn="nmcli connection import type openvpn file "  # pass .ovpn file location
alias sysinfo="sudo inxi -v8"
alias mario="$HOME/Downloads/super_mario/Super_Mario_127_0.7.2.x86_64"
alias logs="journalctl -xef -p 3"
alias weather="curl wttr.in/yenişehir+mersin"
alias serve="python3 -m http.server 9000"
alias filetypes="for file in ./*(.); do file $file; done"
alias rsync="rsync -avAXEWSlHh --no-compress --info=progress2 --inplace"
alias dc="docker compose"
alias pc="podman compose"
alias de="docker exec -it"
alias pe="podman exec -it"
alias bul="find . -name"
alias ara="find . -name"
alias syze="du -hs *"
alias icat="kitty +kitten icat"
alias clipboard="kitty +kitten clipboard"
alias sunshine-start="systemctl --user start sunshine"
alias sunshine-stop="systemctl --user stop sunshine"
fastfetch
zsh_add_file_fullpath "$HOME/.shell.zsh"

