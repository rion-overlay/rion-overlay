# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit openca-perl

DESCRIPTION="HTML OpenCA helper"
KEYWORDS="~amd64 x86"
IUSE=""

DEPEND="virtual/perl-CGI
		dev-perl/Locale-gettext
		dev-perl/Digest-SHA1"

RDEPEND="${DEPEND}"
openca-perl_set_s
