# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit openca-perl

DESCRIPTION="Perl Crypto Extention to OpenSSL"
KEYWORDS="~x86 ~amd64"
IUSE=""
DEPEND="dev-perl/X500-DN
		dev-libs/openssl
		dev-perl/Locale-gettext
		dev-perl/MIME-tools"
RDEPEND="${DEPEND}"
openca-perl_set_s
