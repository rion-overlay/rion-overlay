# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit openca-perl perl-openca

DESCRIPTION="Open-CA Perl module for DBI Extension"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-perl/DBI
		dev-perl/OpenCA-REQ
		dev-perl/OpenCA-X509
		dev-perl/OpenCA-CRL
		dev-perl/OpenCA-OpenSSL
		dev-perl/OpenCA-Tools
		dev-perl/libintl-perl"

openca-perl_set_s
