# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# rion overlay;

EAPI=2

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

DEPEND="net-misc/curl
		>=dev-libs/libgcrypt-1.4.4
		"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/"${PN}"-"${MY_PV}"

src_install() {
	einstall || die "make install failed"
	dodoc AUTHORS INSTALL  NEWS   README
}

