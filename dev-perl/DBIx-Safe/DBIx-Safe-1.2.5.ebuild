# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

MODULE_AUTHOR="TURNSTEP"
inherit perl-module

DESCRIPTION="Safe wrapper to DBI interface"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-perl/DBD-Pg
		dev-perl/DBI"
RDEPEND="${DEPEND}"
SRC_TEST="do"
