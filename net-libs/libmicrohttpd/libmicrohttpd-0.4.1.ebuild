# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

inherit eutils libtool

MY_PV="${PV/_/}"

DESCRIPTION="small and easy to use C library to run an HTTP server as part of another application."
HOMEPAGE="http://gnunet.org/libmicrohttpd/"
SRC_URI="ftp://ftp.gnu.org/gnu/${PN}/${PN}-${MY_PV}.tar.gz"
RESTRICT="mirror"

IUSE=""
KEYWORDS="~amd64 ~x86"
LICENSE="LGPL-2"
SLOT="0"

DEPEND="net-misc/curl"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/"${PN}"-"${MY_PV}"

src_compile() {
	econf || die "econf failed"
	make || die "emake failed"
}

src_install() {
	make install DESTDIR="${D}" || die "make install failed"
}
