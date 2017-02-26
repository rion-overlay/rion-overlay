# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit gnome2-utils xdg cmake-utils git-r3

DESCRIPTION="Quick(Qt) Online Music Player - one player for different online music hostings"
HOMEPAGE="http://sourceforge.net/projects/qomp/"
EGIT_REPO_URI="https://github.com/qomp/qomp.git"
EGIT_MIN_CLONE_TYPE="single"

SLOT="0"
KEYWORDS=""
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
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5
	dev-qt/qtdbus:5
	dev-qt/qtxml:5
	dev-qt/qtx11extras:5
	dev-libs/openssl
	media-libs/taglib
	>=media-libs/libcue-1.4.0
"

RDEPEND="
	${DEPEND}
	dev-qt/qtopengl:5
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
