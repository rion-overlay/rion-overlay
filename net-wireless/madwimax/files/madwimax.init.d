#!/sbin/runscript
# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

depend() {

	after localmount bootmisc
	before net

}

start() {

	local PARAMS="--daemonize"
	ebegin "Starting madwimax"
	if ! grep -qw tun /proc/modules; then
		modprobe tun 1>/dev/null 2>&1 || eerror "Error loading tun module"
	fi

	if $DIODE_OFF ; then
		PARAMS="$PARAMS --diode-off" 
	fi

	if [[ $EVENT_SCRIPT != "" ]]; then
		PARAMS="$PARAMS --event-script=$EVENT_SCRIPT"
	fi

	start-stop-daemon --start --quiet --exec $(which madwimax) -- $PARAMS
	eend ${?}

}

stop() {
	
	ebegin "Stopping madwimax"
	start-stop-daemon --stop --quiet --exec $(which madwimax)
	eend ${?}

}

#restart() {
#
#}
