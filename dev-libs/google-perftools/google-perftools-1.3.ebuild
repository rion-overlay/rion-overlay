# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit

DESCRIPTION="Fast, multi-threaded malloc() and nifty performance analysis tools"
HOMEPAGE="http://code.google.com/p/google-perftools/"
SRC_URI="http://google-perftools.googlecode.com/files/"${PN}"-"${PV}".tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="minimal"

DEPEND="sys-devel/libtool"
RDEPEND=""


src_configure() {
	econf \
		$(use_enable minimal ) || die
}

src_install() {
	emake DESTDIR="${D}" install || die
}
