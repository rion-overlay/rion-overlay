# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools-utils

DESCRIPTION="SBLIM Base Providers"
HOMEPAGE="http://sblim.wiki.sourceforge.net"
SRC_URI="mirror://sourceforge/project/sblim/providers/${PN}/${PV}/${P}.tar.bz2"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static-libs"

DEPEND="
	|| ( sys-apps/tog-pegasus app-admin/sblim-sfcb app-admin/openwbem )
	app-admin/sblim-sfcb
	dev-libs/sblim-cmpi-devel
	dev-libs/sblim-indication_helper
	"
RDEPEND="${DEPEND}"

PATCHES=("${FILESDIR}"/*.patch)
