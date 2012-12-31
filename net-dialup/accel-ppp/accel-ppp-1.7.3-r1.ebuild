# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils linux-info

DESCRIPTION="Point-to-Point Tunnelling Protocol Client/Server for Linux"
HOMEPAGE="http://accel-ppp.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm ~amd64 ~x86"
IUSE="debug doc postgres radius shaper snmp"

DEPEND="
	postgres? ( dev-db/postgresql-base )
	snmp? ( net-analyzer/net-snmp )
	dev-libs/libpcre
	dev-libs/openssl:0
	"

RDEPEND="${DEPEND}"

DOCS=( README )
CONFIG_CHECK="~CONFIG_PPTP ~CONFIG_L2TP"

src_prepare() {
	sed -i  -e "/mkdir/d" \
		-e "/echo/d" \
		-e "s: RENAME accel-ppp.conf.dist::" accel-pppd/CMakeLists.txt || die 'sed on accel-pppd/CMakeLists.txt failed'
	# Respect lib64
	for i in $(find . -name CMakeLists.txt) ; do
		sed -i -e "s:\(DESTINATION lib\):\1\${LIB_SUFFIX}:" "$i" || die 'sed failed'
	done
	# TBF shaper is obsolete by upstream, so it's disabled
	epatch "${FILESDIR}/${PN}-remove_obsolete_tbf_shaper.patch"

	epatch_user
}

src_configure() {
	# There must be also dev-libs/tomcrypt (TOMCRYPT) as crypto alternative to OpenSSL
	local mycmakeargs=(
		-DBUILD_DRIVER=FALSE
		-DCRYPTO=OPENSSL
		$(cmake-utils_use debug MEMDEBUG)
		$(cmake-utils_use debug VALGRIND)
		$(cmake-utils_use postgres LOG_PGSQL)
		$(cmake-utils_use radius RADIUS)
		$(cmake-utils_use shaper SHAPER)
		$(cmake-utils_use snmp NETSNMP)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	use doc && dodoc -r rfc

	insinto /usr/share/snmp/mibs
	use snmp && doins accel-pppd/extra/net-snmp/ACCEL-PPP-MIB.txt

	newinitd "${FILESDIR}"/${PN}d-r1.initd ${PN}d
	newconfd "${FILESDIR}"/${PN}d.confd ${PN}d

	dodir /var/log/accel-ppp
	keepdir /var/run/{accel-ppp,radattr}
}
