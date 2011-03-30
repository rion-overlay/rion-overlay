# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

SRC_VER="1.1.0"
inherit perl-module

DESCRIPTION="Perl module to manage the logging of OpenCA"
SRC_URI="mirror://sourceforge/openca/openca-base-${SRC_VER}.tar.gz"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/openca-base-${SRC_VER}/src/modules/openca-log"
