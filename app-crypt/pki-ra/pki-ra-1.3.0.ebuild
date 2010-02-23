# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit depend.apache

DESCRIPTION="Dogtag Certificate System - Registration Authority"
HOMEPAGE="http://pki.fedoraproject.org"
SRC_URI="http://pki.fedoraproject.org/pki/sources/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""

RDEPEND="${DEPEND}
	www-apache/mod_nss
	www-apache/mod_perl:1
	www-apache/libapreq2:2
	dev-libs/mozldap
	dev-perl/DBD-SQLite
	dev-perl/DBI
	dev-perl/HTML-Parser
	dev-perl/HTML-Tagset
	dev-perl/Parse-RecDescent
	dev-perl/URI
	dev-perl/XML-NamespaceSupport
	dev-perl/XML-Parser
	dev-perl/XML-Simple
	app-misc/pki-setup
	virtual/mta
	dev-db/sqlite:3"

need_apache2_2

src_compile() {

	ant \
		-Dinit.d="etc/init.d" \
		-Dproduct.ui.flavor.prefix="" \
		-Dproduct.prefix="pki" \
		-Dproduct="ra" \
		-Dversion="${PV}" || die

}

src_install() {
	local base="/usr/share/pki/ra"

	dodir "${base}"

	cd "${D}"

	unzip "${S}"/dist/binary/"${P}".zip -d "${D}" || die

	#doinitd foo bla

	#dodit localstatedir/lock/pki/ra
	#dodit /run/pki/ra

}
