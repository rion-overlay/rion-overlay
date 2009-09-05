# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Source: http://bugs.gentoo.org/show_bug.cgi?id=76213
# Submitted-By: Nathaniel Copa
# Reviewed-By: rl03 2005-12-11

DESCRIPTION="HTML And Shell Embedded Report Language"
HOMEPAGE="http://haserl.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
RESTRICT="mirror"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="lua"

RDEPEND="lua? ( dev-lang/lua )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"


src_compile() {
	econf --prefix=/usr $(use_with lua)
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS ChangeLog README THANKS TODO
}
