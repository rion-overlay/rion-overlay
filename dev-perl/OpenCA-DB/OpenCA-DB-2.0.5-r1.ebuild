# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

SRC_VER="1.0.2"

inherit perl-module

DESCRIPTION="Perl Certificates DB Extention"
SRC_URI="mirror://sourceforge/openca/openca-base-${SRC_VER}.tar.gz"
KEYWORDS="~amd64 ~x86"

IUSE=""
SLOT="0"

DEPEND=""
RDEPEND=">=virtual/perl-DB_File-1.815
		dev-perl/OpenCA-REQ
		dev-perl/OpenCA-X509
		dev-perl/OpenCA-CRL
		dev-perl/OpenCA-OpenSSL
		dev-perl/OpenCA-Tools"
S="${WORKDIR}/openca-base-${SRC_VER}/src/modules/openca-db"
