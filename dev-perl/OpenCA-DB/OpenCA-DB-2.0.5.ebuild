# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit openca-perl

DESCRIPTION="Perl Certificates DB Extention"
KEYWORDS="~amd64 x86"
IUSE=""

DEPEND=""
RDEPEND=">=virtual/perl-DB_File-1.815
		dev-perl/OpenCA-REQ
		dev-perl/OpenCA-X509
		dev-perl/OpenCA-CRL
		dev-perl/OpenCA-OpenSSL
		dev-perl/OpenCA-Tools"
openca-perl_set_s
