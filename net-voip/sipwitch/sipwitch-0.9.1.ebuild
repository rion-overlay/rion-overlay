# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit autotools confutils

DESCRIPTION="GNU SIP Witch is a call and registration server for the SIP protocol"
HOMEPAGE="http://www.gnu.org/software/sipwitch"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test doc debug openssl gnutls gcrypt avahi notify"

COMMON_DEP=">=dev-libs/ucommon-3.3.4
			>=net-libs/libeXosip-3.1.0
			openssl? ( dev-libs/openssl )
			gnutls? ( net-libs/gnutls )
			gcrypt? ( dev-libs/libgcrypt )
			avahi? ( net-dns/avahi )
			notify? ( x11-libs/libnotify )"

DEPEND="dev-util/pkgconfig
	sys-devel/libtool
	${COMMON_DEP}"

RDEPEND="${COMMON_DEP}"

pkg_config() {
	confutils_require_one openssl gnutls gcrypt
}
src_prepare() {
	# Dirty hack, disable avahi patch
	use !avahi && epatch "${FILESDIR}"/disable_avahi-configure.ac.patch
	eautoreconf
}
src_configure() {
	local crypto=""
	use openssl && crypto="openssl"
	use gnutls && crypto="gnutls"
	use gcrypt && crypto="gcrypt"

	econf \
		--with-pkg-config \
		$(use_enable debug) \
		--with-crypto=${crypto} \
		--localstatedir=/var/ \
		|| die "econf failed"
}
src_test() {
	use test && emake check || die "test failed"
}
src_install() {
	emake DESTDIR="${ED}" install || die "install failed"

	dodir /var/log/
	dodir /var/run/"${PN}"
	dodoc AUTHORS BUILDS ChangeLog FEATURES INSTALL MODULES README NOTES
	dodoc NEWS TODO SUPPORT
}
