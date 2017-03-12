# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

AUTOTOOLS_IN_SOURCE_BUILD=1

inherit eutils flag-o-matic user

DESCRIPTION="Small Footprint CIM Broker (sfcb)"
HOMEPAGE="http://www.sblim.org/"
SRC_URI="mirror://sourceforge/project/sblim/${PN}/1.4%20branch%20(current)/${P}.tar.bz2"

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

PATCHES=(
	"${FILESDIR}"/sblim-sfcb-1.3.9-sfcbrepos-schema-location.patch
)

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
	econf "${myeconfargs[@]}"
}

src_compile() {
	append-flags -D_GNU_SOURCE

	emake -j1
}
