# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

MODULE_AUTOR=MISHOO

inherit perl-module

DESCRIPTION="Provides methods to access an IMAP server"
SRC_URI="mirror://cpan/authors/id/M/MI/MISHOO/"${P}".tar.gz"

IUSE="test"

SLOT="0"
KEYWORDS="~x86 ~amd64"

DEPEND="dev-perl/List-MoreUtils
		 test? ( >=dev-perl/Test-Pod-1.26
		 		dev-perl/Test-Pod-Coverage
				)"

RDEPEND="dev-perl/IO-Socket-SSL"
SRC_TEST="do"
