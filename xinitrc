function run {
  if command -v $1 > /dev/null; then
    eval $@ &
  else
    echo "<ERR> '$1' failed!"
  fi
}

#run_or_err imwheel && imwheel
run xflux -l -16.68 -g -49.26
run urxvtd -q -o -f
run xbindkeys
run dunst
run xrdb -merge ~/.Xresources
run xset b off
run setxkbmap -layout us -variant intl
run xrandr --output DP1 --right-of eDP1 --auto --mode 3840x2160

exec i3
