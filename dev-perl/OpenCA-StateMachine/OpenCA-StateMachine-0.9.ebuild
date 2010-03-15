# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

SRC_VER="1.1.0"
inherit perl-module

DESCRIPTION="Managing OpenCA config files"
SRC_URI="mirror://sourceforge/openca/openca-base-${SRC_VER}.tar.gz"
KEYWORDS="~amd64 ~x86"

IUSE=""
SLOT="0"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/openca-base-${SRC_VER}/src/modules/openca-statemachine"
