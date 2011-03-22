# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit perl-module

DESCRIPTION="Perl extension to easily manage Certificate revocation list"
HOMEPAGE="http://search.cpan.org/~madwolf/OpenCA-CRL-0.9.17"
SRC_URI="mirror://cpan/authors/id/M/MS/MSCHOUT/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

src_prepare() {
	perl-module_src_prepare

	sed -i -e /prova.pl/d "${S}"/MANIFEST || die "sed failed"
	einfo "editing MANIFEST"
	rm -r "${S}"/prova.pl || die "Not removed prova.pl"
	einfo "removed prova.pl"
}
