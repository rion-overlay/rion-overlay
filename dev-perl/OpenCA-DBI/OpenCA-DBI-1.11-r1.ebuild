# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

SRC_VER="1.1.0"
inherit  perl-module

DESCRIPTION="Open-CA Perl module for DBI Extension"
SRC_URI="mirror://sourceforge/openca/openca-base-${SRC_VER}.tar.gz"
KEYWORDS="~amd64 ~x86"

IUSE=""
SLOT="0"
DEPEND=""
RDEPEND="dev-perl/DBI
		dev-perl/OpenCA-REQ
		dev-perl/OpenCA-X509
		dev-perl/OpenCA-CRL
		dev-perl/OpenCA-OpenSSL
		dev-perl/OpenCA-Tools
		dev-perl/libintl-perl"

S="${WORKDIR}/openca-base-${SRC_VER}/src/modules/openca-dbi"

src_prepare() {
	perl-module_src_prepare

	sed -i -e /prova.pl/d "${S}"/MANIFEST ||die "sed failed"
	einfo "editing MANIFEST"
	rm -f "${S}"/prova.pl || die "Not removed prova.pl"
	einfo "removed prova.pl"
}
