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
run_or_err xrdb -merge ~/.Xresources
run_or_err xset b off
run_or_err setxkbmap -layout us -variant intl
run_or_err xrandr --output DP1 --right-of eDP1 --auto --mode 3840x2160

exec i3
