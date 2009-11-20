# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
MODULE_AUTHOR="CFAERBER"
inherit perl-module

DESCRIPTION="Simple calculations with RGB colors"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-perl/Graphics-ColorNames
		dev-perl/Graphics-ColorNames-WWW
		dev-perl/Params-Validate"
RDEPEND="${DEPEND}"
SRC_TEST="do"
