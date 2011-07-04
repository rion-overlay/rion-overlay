# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit libtool

DESCRIPTION="Provide an easy-to-use PKI library for PKI enabled application development."
HOMEPAGE="http://www.openca.org/projects/libpki"
SRC_URI="mirror://sourceforge/project/openca/${PN}/releases/v${PV}/sources/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples mysql postgres"

DEPEND="dev-libs/libxml2
	dev-libs/openssl
	net-nds/openldap
	mysql? ( virtual/mysql  )
	postgres? ( dev-db/postgresql-base )"

RDEPEND="${DEPEND}"

src_prepare() {
	elibtoolize
}

src_configure () {
	econf \
		--enable-ldap \
		$(use_enable mysql) \
		$(use_enable postgres pg) \
		--enable-openssl \
		--disable-kmf \
		--enable-ecdsa \
		--disable-openssl-engine || die

#Openss engines need more optional test
}

src_install() {
	emake DESTDIR="${ED}" install

	if use examples; then
		insinto /usr/share/doc/"${PF}"
		doins -r examples
	fi
	dodoc AUTHORS ChangeLog INSTALL NEWS README
}

pkg_postinst() {
	einfo "For more inf, see"
	einfo "http://wiki.openca.org/wiki/index.php/LibPKI_configuration_files"
}
