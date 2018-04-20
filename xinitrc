[ -f ~/.Xresources ] && xrdb -merge -I$CONF/Xsolarized ~/.Xresources

command -v urxvtd && urxvtd -q -o -f
command -v imwheel && imwheel

xset b off

exec i3
