# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit perl-openca

DESCRIPTION="Perl extension to easily manage Cert REQUESTs"
HOMEPAGE="http://search.cpan.org/~madwolf/OpenCA-REQ-0.9.52/"
SRC_URI="mirror://cpan/authors/id/M/MS/MSCHOUT/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="dev-perl/X500-DN"
