# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

SRC_VER="1.1.0"

inherit perl-module

DESCRIPTION="OpenCA Perl extensions for LDAP"
SRC_URI="mirror://sourceforge/openca/openca-base-${SRC_VER}.tar.gz"
KEYWORDS="~amd64 x86"

SLOT="0"
IUSE=""
RDEPEND="dev-perl/X500-DN
		dev-perl/perl-ldap"

DEPEND=""

S="${WORKDIR}/openca-base-${SRC_VER}/src/modules/openca-ldap"
