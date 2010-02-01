# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit openca-perl

DESCRIPTION="OpenCA Perl extensions for LDAP"
KEYWORDS="~amd64 x86"

IUSE=""
RDEPEND="dev-perl/X500-DN
		dev-perl/perl-ldap"

DEPEND=""

openca-perl_set_s
