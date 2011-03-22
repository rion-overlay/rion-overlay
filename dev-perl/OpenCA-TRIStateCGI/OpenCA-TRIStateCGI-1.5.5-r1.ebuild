# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

SRC_VER="1.1.0"
inherit perl-module

DESCRIPTION="Perl extension for implementing 3-state Input Objs."
SRC_URI="mirror://sourceforge/openca/openca-base-${SRC_VER}.tar.gz"
KEYWORDS="~amd64 ~x86"
IUSE=""

SLOT="0"

DEPEND="virtual/httpd-cgi
		dev-perl/CGI-Session"

RDEPEND="${DEPEND}"
S="${WORKDIR}/openca-base-${SRC_VER}/src/modules/openca-tristatecgi"
