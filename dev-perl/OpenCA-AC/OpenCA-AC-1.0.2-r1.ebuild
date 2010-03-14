# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

SRC_VER="1.1.0"
inherit perl-module 

DESCRIPTION="Perl extension to OpenCA project"
SRC_URI="mirror://sourceforge/openca/openca-base-${SRC_VER}.tar.gz"
HOMEPAGE="http://www.openca.org/"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-perl/XML-Twig
		dev-perl/OpenCA-TRIStateCGI
		dev-perl/OpenCA-Tools
		dev-perl/OpenCA-Log
		dev-perl/Digest-SHA1
		dev-perl/perl-ldap"
DEPEND=""
S="${WORKDIR}/openca-base-${SRC_VER}/src/modules/openca-ac"

