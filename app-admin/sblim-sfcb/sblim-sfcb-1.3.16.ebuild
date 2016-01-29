# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

AUTOTOOLS_IN_SOURCE_BUILD=1

inherit eutils autotools-utils flag-o-matic user

DESCRIPTION="Small Footprint CIM Broker (sfcb)"
HOMEPAGE="http://www.sblim.org/"
SRC_URI="mirror://sourceforge/project/sblim/${PN}/1.3%20branch%20(maintenance)/${P}.tar.bz2"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug ssl slp ipv6"

DEPEND="
	dev-libs/sblim-sfcCommon
	dev-libs/sblim-cmpi-devel
	net-misc/curl
	sys-libs/zlib
	virtual/pam
	net-libs/openslp
	"
RDEPEND="${DEPEND}
	app-misc/cim-schema
	"

PATCHES=( "${FILESDIR}"/*.patch )

spkg_setup() {
	enewgroup sfcb
	enewuser sfcb
}

src_configure() {

	local myeconfargs=(
		--enable-ssl
		--enable-pam
		--enable-uds
		--enable-ipv6
		)
	autotools-utils_src_configure
}

src_compile() {
	append-flags -D_GNU_SOURCE

	emake -j1
}
