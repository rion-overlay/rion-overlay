# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit openca-perl

DESCRIPTION="Perl extension for support OpenCA CGI session"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-perl/CGI-Session
		dev-perl/OpenCA-Log"
RDEPEND="${DEPEND}"
openca-perl_set_s
