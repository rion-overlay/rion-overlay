# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: slepnoga to tau project - 22.12.2012 $

EAPI=5

inherit cmake-utils

DESCRIPTION="Point-to-Point Tunnelling Protocol Client/Server for Linux"
HOMEPAGE="http://accel-ppp.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="postgres debug shaper radius snmp"

DEPEND="
	dev-libs/libnl:3
	dev-libs/openssl:0
	dev-libs/libpcre
	postgres? ( dev-db/postgresql-base )
	snmp? ( net-analyzer/net-snmp )
	"

RDEPEND="${DEPEND}"

DOCS=(README)

src_prepare() {
		sed -i -e "/mkdir/d" "${S}/accel-pppd/CMakeLists.txt"
		sed -i -e "/echo/d" "${S}/accel-pppd/CMakeLists.txt"
		sed -i -e "/INSTALL/d" "${S}/driver/CMakeLists.txt"
}

src_configure() {
# cmake autocrap, not troll me to autocrap ;)

	local mycmakeargs=( "-DBUILD_DRIVER=FALSE" )
		if use debug; then
			CMAKE_BUILD_TYPE=Debug
		fi

		if  use postgres; then
				mycmakeargs+=( "-DLOG_PGSQL=TRUE" )
			else
				mycmakeargs+=( "-DLOG_PGSQL=FALSE" )
		fi

		if use shaper; then
				mycmakeargs+=( "-DSHAPER=TRUE" )
			else
				mycmakeargs+=( "-DSHAPER=FALSE" )
		fi

		if use radius; then
				mycmakeargs+=( "-DRADIUS=TRUE" )
			else
				mycmakeargs+=( "-DRADIUS=FALSE" )
		fi

		if use snmp; then
				mycmakeargs+=( "-DNETSNMP=TRUE" )
			else
				mycmakeargs+=( "-DNETSNMP=FALSE" )
		fi
# -DLOG_FILE=
# -DLOG_TCP=

		cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	dodoc -r rfc

	newinitd "${FILESDIR}"/pptp-init accel-pppd
	newconfd "${FILESDIR}"/accel-pppd-confd accel-pppd

	dodir /var/log/accel-ppp
	dodir /var/run/accel-ppp
	dodir /var/run/radattr
}
