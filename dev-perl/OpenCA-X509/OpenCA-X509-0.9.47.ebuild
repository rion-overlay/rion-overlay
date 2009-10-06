# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
inherit perl-openca

DESCRIPTION="Perl extension to easily manage X509 Cert"
HOMEPAGE="http://search.cpan.org/~madwolf/OpenCA-X509-0.9.47/"
SRC_URI="mirror://cpan/authors/id/M/MS/MSCHOUT/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

DEPEND="dev-perl/X500-DN
		virtual/perl-Digest-MD5"
RDEPEND="${DEPEND}"
