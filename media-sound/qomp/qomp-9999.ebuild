# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

case $PV in *9999*) VCS_ECLASS="git-r3" ;; *) VCS_ECLASS="" ;; esac

inherit gnome2-utils xdg cmake-utils ${VCS_ECLASS}

if [ -n "${VCS_ECLASS}" ]; then
	KEYWORDS=""
	EGIT_REPO_URI="https://github.com/qomp/qomp.git"
	EGIT_MIN_CLONE_TYPE="single"
else
	S="${WORKDIR}/${PN}-${P}"
	KEYWORDS="amd64 x86"
	SRC_URI="https://sourceforge.net/projects/qomp/files/${PV}/${PN}_${PV}_src.tar.gz"
fi

DESCRIPTION="Quick(Qt) Online Music Player - one player for different online music hostings"
HOMEPAGE="http://sourceforge.net/projects/qomp/"
SLOT="0"
LICENSE="GPL-3"

QOMP_PLUGINS="
	urlplugin
	prostopleerplugin
	myzukaruplugin
	notificationsplugin
	yandexmusicplugin
	lastfmplugin
	tunetofileplugin
	mprisplugin
"
IUSE="${QOMP_PLUGINS}"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtmultimedia:5[gstreamer]
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtdbus:5
	dev-qt/qtxml:5
	dev-qt/qtx11extras:5
	dev-libs/openssl:0
	media-libs/taglib
	>=media-libs/libcue-1.4.0
"

RDEPEND="
	${DEPEND}
	dev-qt/qtopengl:5
	media-plugins/gst-plugins-libav:1.0
	media-plugins/gst-plugins-soup:1.0
"

pkg_setup() {
	local plugins="filesystemplugin"
	for p in ${QOMP_PLUGINS}; do
		use "${p}" && plugins="${plugins};${p}"
	done
	MYCMAKEARGS="-DBUILD_PLUGINS=${plugins}"
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_pkg_postinst
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_pkg_postrm
}
