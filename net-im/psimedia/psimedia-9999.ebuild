# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit qt4-r2 multilib eutils git-2

DESCRIPTION="Psi plugin for voice/video calls"
HOMEPAGE="http://delta.affinix.com/psimedia/"
EGIT_REPO_URI="git://github.com/psi-plus/psimedia.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="demo extras"

COMMON_DEPEND="
	>=dev-libs/glib-2.20.0
	media-libs/gstreamer:0.10
	media-libs/gst-plugins-base:0.10
	media-libs/gst-plugins-good:0.10
	>=dev-qt/qtgui-4.4:4
	>=media-libs/speex-1.2_rc1
	dev-libs/liboil
"
RDEPEND="${COMMON_DEPEND}
	media-plugins/gst-plugins-speex:0.10
	media-plugins/gst-plugins-vorbis:0.10
	media-plugins/gst-plugins-theora:0.10
	media-plugins/gst-plugins-alsa:0.10
	media-plugins/gst-plugins-ogg:0.10
	media-plugins/gst-plugins-v4l2:0.10
	media-plugins/gst-plugins-jpeg:0.10
	!<net-im/psi-0.13_rc1
	extras? ( >=net-im/psi-0.15_pre20110125[extras] )
"
DEPEND="${COMMON_DEPEND}
	sys-devel/qconf
	virtual/pkgconfig
"

src_prepare() {
	sed -e '/^TEMPLATE/a CONFIG += ordered' -i psimedia.pro || die
	# Don't build demo if we don't need that.
	if use !demo; then
		sed -e '/^SUBDIRS[[:space:]]*+=[[:space:]]*demo[[:space:]]*$/d;' \
			-i psimedia.pro || die
	fi
}

src_configure() {
	qconf
	# qconf generated configure script...
	./configure --no-separate-debug-info || die

	eqmake4
}

src_install() {
	if use extras; then
		pname="psi-plus"
	else
		pname="psi"
	fi
	insinto /usr/$(get_libdir)/${pname}/plugins
	doins gstprovider/libgstprovider.so

	if use demo; then
		exeinto /usr/$(get_libdir)/${PN}
		newexe demo/demo ${PN}

		# Create /usr/bin/psimedia
		cat <<-EOF > "demo/${PN}"
		#!/bin/bash

		export PSI_MEDIA_PLUGIN=/usr/$(get_libdir)/${pname}/plugins/libgstprovider.so
		/usr/$(get_libdir)/${PN}/${PN}
		EOF

		dobin demo/${PN}
	fi
}
