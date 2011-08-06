# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

SRC_VER="1.1.0"

inherit perl-module eutils

DESCRIPTION="Perl Crypto Extention to OpenSSL"
SRC_URI="mirror://sourceforge/openca/openca-base-${SRC_VER}.tar.gz"
KEYWORDS="~x86 ~amd64"

SLOT="0"
IUSE=""

DEPEND="dev-perl/X500-DN
		dev-libs/openssl
		dev-perl/Locale-gettext
		dev-perl/MIME-tools"
RDEPEND="${DEPEND}"

S="${WORKDIR}/openca-base-${SRC_VER}/src/modules/openca-openssl"
isrc_prepare() {
	perl-module_src_prepare

	sed -i -e /prova.pl/d "${S}"/MANIFEST || die "sed failed"
	einfo "editing MANIFEST"
	rm -r "${S}"/prova.pl || die "Not removed prova.pl"
	einfo "removed prova.pl"
}
