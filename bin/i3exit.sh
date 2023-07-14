#!/bin/sh

case "$1" in
    logout)
        i3-msg exit
        ;;
    suspend)
        # TODO
        ;;
    reboot)
        systemctl reboot -i
        ;;
    shutdown)
        systemctl poweroff
        ;;
    *)
        echo "Usage: $0 {logout|suspend|reboot|shutdown}"
        exit 2
esac

exit 0
