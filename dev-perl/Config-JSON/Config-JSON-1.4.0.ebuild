# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
MODULE_AUTHOR="RIZEN"
inherit perl-module

DESCRIPTION="A JSON based config file system."
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="perl-core/Scalar-List-Utils
		dev-perl/JSON
		dev-perl/Class-InsideOut
		dev-perl/Test-Deep
		virtual/perl-File-Temp"
RDEPEND="${DEPEND}"
SRC_TEST="do"
S="${WORKDIR}/${PN}"
