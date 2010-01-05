# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit openca-perl

DESCRIPTION="Perl extension for implementing 3-state Input Objs."
KEYWORDS="~amd64 x86"
IUSE=""

DEPEND="virtual/httpd-cgi
		dev-perl/CGI-Session"
RDEPEND="${DEPEND}"
openca-perl_set_s
