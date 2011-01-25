# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit qt4-r2 multilib eutils subversion

DESCRIPTION="Psi plugin for voice/video calls"
HOMEPAGE="http://delta.affinix.com/psimedia/"
ESVN_REPO_URI="http://delta.affinix.com/svn/trunk/psimedia"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="demo extras"

COMMON_DEPEND="
	>=dev-libs/glib-2.20.0
	>=media-libs/gstreamer-0.10.22
	>=media-libs/gst-plugins-base-0.10.22
	media-libs/gst-plugins-good
	>=dev-libs/liboil-0.3
	>=x11-libs/qt-gui-4.4:4
	>=media-libs/speex-1.2_rc1
"
RDEPEND="${COMMON_DEPEND}
	media-plugins/gst-plugins-speex
	>=media-plugins/gst-plugins-vorbis-0.10.22
	>=media-plugins/gst-plugins-theora-0.10.22
	>=media-plugins/gst-plugins-alsa-0.10.22
	>=media-plugins/gst-plugins-ogg-0.10.22
	>=media-plugins/gst-plugins-v4l-0.10.22
	media-plugins/gst-plugins-v4l2
	media-plugins/gst-plugins-jpeg
	!<net-im/psi-0.13_rc1
	extras? ( >=net-im/psi-0.15_pre20110125[extras] )
"
DEPEND="${COMMON_DEPEND}
	sys-devel/qconf
	dev-util/pkgconfig
"

src_unpack() {
	subversion_src_unpack

	if use extras; then
		S="${WORKDIR}/patches" \
		ESVN_PROJECT="${PN}/patches" \
		subversion_fetch \
			"http://psi-dev.googlecode.com/svn/trunk/patches/psimedia"
	fi
}

src_prepare() {
	use extras && epatch "${WORKDIR}"/patches/*

	subversion_src_prepare

	sed -e '/^TEMPLATE/a CONFIG += ordered' -i psimedia.pro || die
	# Don't build demo if we don't need that.
	if use !demo; then
		sed -e '/^SUBDIRS[[:space:]]*+=[[:space:]]*demo[[:space:]]*$/d;' \
			-i psimedia.pro || die
	fi
}

src_configure() {
	qconf
	# qconf generaged configure script...
	./configure || die

	eqmake4
}

src_install() {
	if use extras; then
		pname="psi-plus"
	else
		pname="psi"
	fi
	insinto /usr/$(get_libdir)/${pname}/plugins
	doins gstprovider/libgstprovider.so || die

	if use demo; then
		exeinto /usr/$(get_libdir)/${PN}
		newexe demo/demo ${PN} || die

		# Create /usr/bin/psimedia
		cat <<-EOF > "demo/${PN}"
		#!/bin/bash

		export PSI_MEDIA_PLUGIN=/usr/$(get_libdir)/${pname}/plugins/libgstprovider.so
		/usr/$(get_libdir)/${PN}/${PN}
		EOF

		dobin demo/${PN} || die
	fi
}
