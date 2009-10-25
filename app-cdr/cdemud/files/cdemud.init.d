#!/sbin/runscript
# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/cdemud/files/cdemud.init.d,v 1.1 2008/05/20 02:24:04 vanquirius Exp $

depend() {
	need dbus
#ifdef ALSA
	[ "${CDEMUD_BACKEND}" == ALSA ] && need alsasound
#endif
}

start() {
	ebegin "Loading CDemu userspace daemon"
	if ! grep -qw vhba /proc/modules; then
		/sbin/modprobe vhba || eerror $? "Error loading vhba module"
	fi
	i=0; until [ -c /dev/vhba_ctl ]; do ((i++<=10)) || break; sleep 1; done
#ifndef ALSA
	CDEMUD_ARGS="-a null"
#else
	if [ "${CDEMUD_BACKEND}" == ALSA ]; then
		CDEMUD_ARGS="-a ${CDEMUD_BACKEND} -o ${CDEMUD_AUDIODEV:-default}"
	else
		CDEMUD_ARGS="-a null"
	fi
#endif
	CDEMUD_ARGS="-s -d -c /dev/vhba_ctl -n ${CDEMUD_DEVICES:-1} ${CDEMUD_ARGS}"
	start-stop-daemon --quiet --start --exec /usr/bin/cdemud -- ${CDEMUD_ARGS}
	eend $?
}

stop() {
	ebegin "Stopping CDemu userspace daemon"
	/usr/bin/cdemud -k; status=$?
	/sbin/rmmod vhba || eerror $? "Error unloading vhba module"
	eend "${status}"
}
