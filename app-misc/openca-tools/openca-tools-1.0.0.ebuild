# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils multilib

DESCRIPTION="This package contains the prerequisites for installing OpenCA"
HOMEPAGE="http://www.openca.org"
SRC_URI="mirror://sourceforge/openca/${P}.tar.gz"

RESTRICT="mirror"
LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug doc"

DEPEND="app-arch/gzip"
RDEPEND="dev-libs/openssl
		app-crypt/mit-krb5"




src_configure () {
	econf \
	--with-openca-user=openca \
	--with-openca-group=openca \
	$( use_enable  debug debug )
}

src_install () {

	einstall || die "einstall failed"

	for i in usr/include /usr/sbin/ ; do
		rm -fr	"${D}"/$i
	done
	rm -fr "${D}"/usr/$(get_libdir) || die

	dodoc AUTHORS INSTALL  NEWS README  VERSION
}


pkg_setup() {
		enewgroup openca
		enewuser openca -1 -1 /dev/null openca
}
