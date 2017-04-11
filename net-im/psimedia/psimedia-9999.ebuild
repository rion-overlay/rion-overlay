# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils multilib eutils git-r3

DESCRIPTION="Psi plugin for voice/video calls"
HOMEPAGE="http://delta.affinix.com/psimedia/"
EGIT_REPO_URI="git://github.com/psi-plus/psimedia.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug demo extras qt4 qt5"

REQUIRED_USE="^^ ( qt4 qt5 )"

COMMON_DEPEND="
	>=dev-libs/glib-2.20.0
	media-libs/gstreamer:0.10
	media-libs/gst-plugins-base:0.10
	media-libs/gst-plugins-good:0.10
	qt4? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
		)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
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
	net-im/psi
"
DEPEND="${COMMON_DEPEND}
"

src_configure() {
	if use debug; then
		CMAKE_BUILD_TYPE="Debug"
	fi
	if use extras; then
		pname="psi-plus"
	else
		pname="psi"
	fi
	INSTPATH=/usr/$(get_libdir)/${pname}/plugins
	local mycmakeargs=(
		-DQT4_BUILD="$(usex qt4)"
		-DDEMO="$(usex demo)"
		$(echo -DLIB_INSTALL_DIR=${INSTPATH})
	)
	cmake-utils_src_configure
}
