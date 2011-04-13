# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

MODULE_AUTHOR="RJBS"
inherit  perl-module

DESCRIPTION="Extensions to Class-DBI for MSSQL"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE="test"

RDEPEND="dev-perl/Class-DBI"
DEPEND="test? ( dev-perl/Test-Pod )"

SRC_TEST=do
