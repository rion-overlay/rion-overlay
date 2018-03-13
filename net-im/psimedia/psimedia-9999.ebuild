# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils multilib eutils git-r3

DESCRIPTION="Psi plugin for voice/video calls"
HOMEPAGE="http://delta.affinix.com/psimedia/"
EGIT_REPO_URI="https://github.com/psi-im/psimedia.git"
EGIT_BRANCH="gstreamer-1.0"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug demo extras qt5"

COMMON_DEPEND="
	dev-libs/glib
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
	media-libs/gst-plugins-good:1.0
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
"
RDEPEND="${COMMON_DEPEND}
	media-plugins/gst-plugins-opus:1.0
	media-plugins/gst-plugins-v4l2:1.0
	media-plugins/gst-plugins-jpeg:1.0
	net-im/psi
"
DEPEND="${COMMON_DEPEND}
	sys-devel/qconf
"

src_configure() {
	qconf
	./configure --prefix=${EPREFIX}/usr --qtselect=5
}

src_install() {
	if use extras; then
		pname="psi-plus"
	else
		pname="psi"
	fi

	insinto ${EPREFIX}/usr/$(get_libdir)/${pname}/plugins
	doins gstprovider/libgstprovider.so
}
