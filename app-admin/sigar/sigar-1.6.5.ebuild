# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools autotools-utils

DESCRIPTION="System Information Gatherer And Reporter"
HOMEPAGE="http://support.hyperic.com/display/SIGAR"
SRC_URI="http://rion-overlay.googlecode.com/files/sigar-1.6.5-833ca18.tbz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static-libs"

RESTRICT="test"
DEPEND=""
RDEPEND=""

DOCS=(README)
src_prepare() {
	epatch "${FILESDIR}"/all.patch
	sed -e '/netware/d' -i src/os/Makefile.am
	sed -e '/stub/d' -i src/os/Makefile.am
	sed -e '/osf1/d' -i src/os/Makefile.am
	eautoreconf
}
