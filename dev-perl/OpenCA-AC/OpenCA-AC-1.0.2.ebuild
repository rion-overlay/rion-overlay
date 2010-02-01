# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit openca-perl

DESCRIPTION="Perl extension to OpenCA project"
HOMEPAGE="http://www.openca.org/"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-perl/XML-Twig
		dev-perl/OpenCA-TRIStateCGI
		dev-perl/OpenCA-Tools
		dev-perl/OpenCA-Log
		dev-perl/Digest-SHA1
		dev-perl/perl-ldap"
DEPEND=""
openca-perl_set_s
