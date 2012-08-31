# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

inherit eutils autotools-utils

DESCRIPTION="Linux support for proprietary MIkrotik EoIP protocol"
HOMEPAGE="http://code.google.com/p/linux-eoip/"
SRC_URI="http://http://rion-overlay.googlecode.com/files/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
	esvn_clean
	autotools-utils_src_prepare
}
