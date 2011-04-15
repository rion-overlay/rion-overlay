# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

MODULE_AUTHOR="MLEHMANN"
inherit perl-module

DESCRIPTION="Allow C/XS libraries to interrupt perl asynchronously."

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-perl/common-sense"
DEPEND="${RDEPEND}"

SRC_TEST="do"
