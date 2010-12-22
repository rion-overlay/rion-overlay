# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

SRC_VER="1.1.0"

inherit perl-module

DESCRIPTION="Perl extension for support OpenCA CGI session"
SRC_URI="mirror://sourceforge/openca/openca-base-${SRC_VER}.tar.gz"
KEYWORDS="~amd64 ~x86"

IUSE=""
SLOT="0"

DEPEND="dev-perl/CGI-Session
		dev-perl/OpenCA-Log"
RDEPEND="${DEPEND}"

S="${WORKDIR}/openca-base-${SRC_VER}/src/modules/openca-session"
