#!/sbin/runscript
# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Victor Tseng (palatis@gmail.com)  #213624$
# in rion - slepnoga

depend() {
	need localmount
	after bootmisc modules
}

start() {
	if [ "${LOAD_ON_START}" = "yes" ] ; then
		einfo "Loading ramzswap module..."
		modprobe ramzswap num_devices=${NUM_DEVICES}
		eend $?
	fi

	for I in `seq 0 \`expr ${NUM_DEVICES} - 1\`` ; do
		eval _a=\${RAMZSWAP_OPTS_${I}}
		einfo "Enabling swap /dev/ramzswap${I}..."
		rzscontrol "/dev/ramzswap${I}" --init $_a
		swapon ${SWAPON_OPTS} "/dev/ramzswap${I}"
		eend $?
	done
}

stop() {
	for I in `seq 0 \`expr ${NUM_DEVICES} - 1\`` ; do
		einfo "Disabling swap /dev/ramzswap${I}..."
		swapoff "/dev/ramzswap${I}" && \
		rzscontrol "/dev/ramzswap${I}" --reset
		eend $?
	done

	if [ "${UNLOAD_ON_STOP}" = "yes" ] ; then
		einfo "Unloading ramzswap module..."
		rmmod ramzswap
		eend $?
	fi
}

info() {
	for I in `seq 0 \`expr ${NUM_DEVICES} - 1\`` ; do
		rzscontrol "/dev/ramzswap${I}" --stats
	done
}

reload() {
	for I in `seq 0 \`expr ${NUM_DEVICES} - 1\`` ; do
		swapoff "/dev/ramzswap${I}" && \
		rzscontrol "/dev/ramzswap${I}" --reset && \
		swapon ${SWAPON_OPTS} "/dev/ramzswap${I}"
	done
}
