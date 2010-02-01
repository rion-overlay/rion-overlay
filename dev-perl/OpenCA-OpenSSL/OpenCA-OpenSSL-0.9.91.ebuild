# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit openca-perl

DESCRIPTION="Perl Crypto Extention to OpenSSL"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-perl/X500-DN
		dev-libs/openssl
		dev-perl/Locale-gettext"

openca-perl_set_s
