# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit qmake-utils git-r3

DESCRIPTION="Telegram API tools for QtQML and Qml"
HOMEPAGE="https://github.com/Aseman-Land/TelegramQML"
EGIT_REPO_URI="https://github.com/Aseman-Land/TelegramQML.git"
RESTRICT="mirror"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	>=net-misc/libqtelegram-ae-9999
	dev-qt/qtxml:5
	dev-qt/qtimageformats:5
"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i 's/\/$$LIB_PATH//g' ./telegramqml.pro
	default
}

src_configure() {
	eqmake5 PREFIX="${EPREFIX}/usr"
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
