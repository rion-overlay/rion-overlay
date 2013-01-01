# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit qt4-r2 git-2

DESCRIPTION="Qt4 im client from Rambler, based on Vacuum-IM"
HOMEPAGE="http://developers.rambler.ru/opensource/contacts/"
EGIT_REPO_URI="git://github.com/Rambler-ru/Contacts.git"
EGIT_PROJECT="${PN}.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	>=x11-libs/qt-core-4.7:4[ssl]
	>=x11-libs/qt-gui-4.7:4
	>=x11-libs/qt-webkit-4.7:4
	net-dns/libidn
	x11-libs/libXScrnSaver
"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i \
		-e 's, ../../COPYING,,' \
		src/loader/loader.pro || die
}

src_configure() {
	eqmake4 \
		INSTALL_PREFIX="${EPREFIX}/usr" \
		INSTALL_LIB_DIR="$(get_libdir)" \
		virtus.pro
}
