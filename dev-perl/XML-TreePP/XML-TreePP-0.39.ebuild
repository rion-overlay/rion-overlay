# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
MODULE_AUTHOR="KAWASAKI"
inherit perl-module

DESCRIPTION="Pure Perl implementation for parsing/writing XML documents"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="test? (
				dev-perl/Jcode
				dev-perl/libwww-perl )"
RDEPEND=""
SRC_TEST="do"
