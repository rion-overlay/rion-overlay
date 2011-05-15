# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools-utils

AUTOTOOLS_IN_SOURCE_BUILD=1

DESCRIPTION="GNU SIP Witch is a call and registration server for the SIP protocol"
HOMEPAGE="http://www.gnu.org/software/sipwitch"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc debug ssl avahi notify static-libs"

COMMON_DEP=">=dev-libs/ucommon-4.2.0
	>=net-libs/libeXosip-3.1.0
	ssl? ( dev-libs/openssl )
	avahi? ( net-dns/avahi )
	notify? ( x11-libs/libnotify )"

DEPEND="dev-util/pkgconfig
	sys-devel/libtool
	${COMMON_DEP}"

RDEPEND="${COMMON_DEP}"

DOCS=(AUTHORS BUILDS ChangeLog FEATURES INSTALL MODULES README NOTES NEWS TODO
SUPPORT)
PATCHES=("${FILESDIR}"/disable_avahi-automagic.patch)

src_prepare() {
	autotools-utils_src_prepare
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--with-pkg-config \
		--localstatedir=/var/ \
		--enable-commands \
		$(use_enable debug) \
		$(use_enable ssl openssl) \
		$(use_enable avahi zeroconf)
		)
	autotools-utils_src_configure
}
src_test() {

emake check
}

src_install() {
	dodir /var/log/
	dodir /var/run/"${PN}"
	autotools-utils_src_install
}
