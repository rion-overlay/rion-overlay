# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
MODULE_AUTHOR="CFAERBER"
inherit perl-module

DESCRIPTION="WWW color names and equivalent RGB values"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-perl/Graphics-ColorNames"
RDEPEND="${DEPEND}"
SRC_TEST="do"
