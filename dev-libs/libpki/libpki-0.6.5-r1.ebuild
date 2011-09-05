# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit libtool autotools  autotools-utils

DESCRIPTION="Provide an easy-to-use PKI library for PKI enabled application development."
HOMEPAGE="http://www.openca.org/projects/libpki"
SRC_URI="mirror://sourceforge/project/openca/${PN}/releases/v${PV}/sources/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples mysql postgres ssl static-libs ldap"

DEPEND="dev-libs/libxml2
	dev-libs/openssl
	ldap? ( net-nds/openldap )
	mysql? ( virtual/mysql  )
	postgres? ( dev-db/postgresql-base )"

RDEPEND="${DEPEND}"
DOCS=(AUTHORS ChangeLog INSTALL NEWS README)
AUTOTOOLS_IN_SOURCE_BUILD=1

#need internet connections
RESTRICT="test"

src_prepare() {
	epatch "${FILESDIR}"/*.patch
	eautoreconf
}

src_configure () {
	local myeconfargs=(
		$(use_enable ldap) \
		--with-package-prefix="${EPREFIX}" \
		$(use_enable mysql) \
		$(use_enable postgres pg) \
		--disable-kmf \
		--enable-ecdsa \
		$(use_enable ssl openssl-engine) \
		--disable-iphone)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	if use examples; then
		insinto /usr/share/doc/"${PF}"
		doins -r examples
	fi
}

pkg_postinst() {
	einfo "For more inf, see"
	einfo "http://wiki.openca.org/wiki/index.php/LibPKI_configuration_files"
}
