# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
MODULE_AUTHOR="DMUEY"
inherit perl-module

DESCRIPTION="Methods for getting localized CLDR language/territory names"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="test? ( dev-perl/Test-Pod-Coverage
				dev-perl/Test-Pod )"
RDEPEND=""
SRC_TEST="do parallel"
