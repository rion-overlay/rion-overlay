# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
MODULE_AUTHOR="JNEYSTADT"

inherit perl-module

DESCRIPTION="Routines for converting from one cyrillic charset to another"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-perl/Unicode-Map8
		dev-perl/Unicode-String"
RDEPEND=""
SRC_TEST="do"
