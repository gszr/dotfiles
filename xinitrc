function run_or_err {
	if command -v "$1"; then
		$1 &
	else
		echo "<ERR> '$1' failed!"
		exit 1
	fi
}

#run_or_err imwheel && imwheel
run_or_err xflux -l -16.68 -g -49.26
run_or_err urxvtd -q -o -f
run_or_err xbindkeys
run_or_err dunst
xrdb -merge ~/.Xresources
xset b off
setxkbmap -layout us -variant intl
xrandr --output DP1 --right-of eDP1 --auto --mode 3840x2160

exec i3
