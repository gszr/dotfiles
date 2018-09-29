[ -f ~/.Xresources ] && xrdb -merge -I$CONF/Xsolarized ~/.Xresources

command -v urxvtd && urxvtd -q -o -f
command -v imwheel && imwheel

command -v dunst && dunst &
command -v xbindkeys && xbindkeys

xset b off
#setxkbmap -layout us -variant intl

exec i3
