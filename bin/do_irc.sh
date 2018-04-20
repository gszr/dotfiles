#!/bin/sh
#
ssh -N -L $NETBSD_IRC &

echo "ssh'ing to NetBSD IRC ..."
while [ "`netstat -a | fgrep '7326'`" = "" ]
do
	sleep 5
done
echo "success! go ahead to your IRC client..."
