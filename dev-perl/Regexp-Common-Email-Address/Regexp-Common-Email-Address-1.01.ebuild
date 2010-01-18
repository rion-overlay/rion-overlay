# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

MODULE_AUTOR=CWES
inherit perl-module

DESCRIPTION="Returns a pattern for Email Addresses"
SRC_URI="mirror://cpan/authors/id/C/CW/CWEST/"${P}".tar.gz"

IUSE=""

SLOT="0"
KEYWORDS="~x86 ~amd64"

RDEPEND=">=dev-perl/regexp-common-2.122
		dev-perl/Email-Address"
