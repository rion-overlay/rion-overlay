# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit openca-perl

DESCRIPTION="Perl extension for basic handling PKCS#7 Signatures"
KEYWORDS="~amd64 x86"
IUSE=""

DEPEND=">=dev-perl/X500-DN-0.27"
RDEPEND="${DEPEND}"

openca-perl_set_s
