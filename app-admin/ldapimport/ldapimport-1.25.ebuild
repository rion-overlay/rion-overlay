# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="A set of scripts to migrate from OpenLDAP to 389(FDS)"
HOMEPAGE="http://wiki.babel.com.au/index.php?area=Linux%20Projects&page=LdapImport#toc3"
SRC_URI="http://wiki.babel.com.au/uploads/LdapImport.tgz
		http://directory.fedoraproject.org/download/ol2rhds.pl
		http://directory.fedoraproject.org/download/ol-schema-migrate.pl
		http://directory.fedoraproject.org/download/ol-macro-expand.pl"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-perl/perl-ldap[ssl,sasl]
		dev-perl/Log-Log4perl"

RDEPEND="${DEPEND}"

S="${WORKDIR}"/LdapImport

src_unpack() {
	unpack LdapImport.tgz
}

src_install() {

	dodir /usr/bin
	dobin "${DISTDIR}"/ol2rhds.pl
	dobin "${DISTDIR}"/ol-macro-expand.pl
	dobin "${DISTDIR}"/ol-schema-migrate.pl
	dobin LdapImport.pl

	perlinfo

	insinto ${VENDOR_LIB}
	doins "${S}"/*.pm
}

perlinfo() {
	# perlinfo func. in perl-module.eclass

	perlinfo_done=true

	local f version install{{site,vendor}{arch,lib},archlib}
	for f in version install{{site,vendor}{arch,lib},archlib} ; do
		eval "$(perl -V:${f} )"
	done

	PERL_VERSION=${version}
	SITE_ARCH=${installsitearch}
	SITE_LIB=${installsitelib}
	ARCH_LIB=${installarchlib}
	VENDOR_LIB=${installvendorlib}
	VENDOR_ARCH=${installvendorarch}
}
