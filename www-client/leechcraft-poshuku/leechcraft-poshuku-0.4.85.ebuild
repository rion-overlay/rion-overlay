# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/leechcraft-poshuku/leechcraft-poshuku-0.4.85.ebuild,v 1.1 2011/08/23 19:16:49 maksbotan Exp $

EAPI="2"

inherit confutils leechcraft

DESCRIPTION="Poshuku, the full-featured web browser plugin for LeechCraft."

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug idn +sqlite postgres"

DEPEND="=net-misc/leechcraft-core-${PV}[postgres?,sqlite?]
		x11-libs/qt-webkit
		>=dev-libs/qjson-0.7.1-r1
		idn? ( net-dns/libidn )"
RDEPEND="${DEPEND}
		virtual/leechcraft-downloader-http"

pkg_setup() {
	confutils_require_any postgres sqlite
}

src_configure() {
	local mycmakeargs="$(cmake-utils_use_enable idn IDN)"

	cmake-utils_src_configure
}
