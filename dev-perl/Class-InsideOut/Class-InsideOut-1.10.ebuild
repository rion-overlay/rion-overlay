# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
MODULE_AUTHOR="DAGOLDEN"
inherit perl-module

DESCRIPTION="A safe, simple inside-out object construction kit"
SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="Apache-2.0"
IUSE=""

DEPEND="virtual/perl-Scalar-List-Utils
		virtual/perl-Class-ISA"
RDEPEND="${DEPEND}"
SRC_TEST="do"
