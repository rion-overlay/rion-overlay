# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
MODULE_AUTHOR="BINGOS"
inherit perl-module

DESCRIPTION="A POE Component providing TCP server services for test cases"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-perl/POE-1.004"
RDEPEND="${DEPEND}"
SRC_TEST="do"
