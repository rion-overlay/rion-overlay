# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

SRC_VER="1.1.0"

inherit perl-module

DESCRIPTION="Perl extension for basic handling PKCS#7 Signatures"
SRC_URI="mirror://sourceforge/openca/openca-base-${SRC_VER}.tar.gz"
KEYWORDS="~amd64 ~x86"

IUSE=""
SLOT="0"

DEPEND=">=dev-perl/X500-DN-0.27"
RDEPEND="${DEPEND}"

S="${WORKDIR}/openca-base-${SRC_VER}/src/modules/openca-pkcs7"
