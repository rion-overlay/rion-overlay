# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer-meson

DESCRIPTION="Audio Filter using WebRTC Audio Processing library plugin for GStreamer"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	media-libs/webrtc-audio-processing[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
PATCHES=( "$FILESDIR/shared-gstbadaudio-dep-${PV}.patch" )
