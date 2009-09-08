# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Alternative project management plugin for Geany IDE"
HOMEPAGE="http://geany-plugins.sourceforge.net/geanyprj/"
SRC_URI="http://users.cosmostv.by/yurand/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-util/geany-0.15"

DEPEND="${RDEPEND}"

src_compile() {
	econf || die "econf failed."
	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
}

