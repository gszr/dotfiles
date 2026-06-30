#!/bin/sh
#

if [ -z "$NETBSD_IRC" ]; then
  echo "ERROR: NETBSD_IRC is not set" >&2
  exit 1
fi

ssh -N -L $NETBSD_IRC &

echo "ssh'ing to NetBSD IRC ..."
while [ "`netstat -a | fgrep '7326'`" = "" ]
do
	sleep 5
done
echo "success! go ahead to your IRC client..."
