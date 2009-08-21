# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
#  $Header: $

EAPI=2

MODULE_AUTHOR=DROLSKY
inherit perl-module

S=${WORKDIR}/Apache-Session-Wrapper-0.33-hc59Rw

DESCRIPTION="A simple wrapper around Apache::Session"
IUSE=""
SLOT="0"
KEYWORDS="~x86 ~amd64"

RDEPEND="dev-perl/Exception-Class
	>=dev-perl/Params-Validate-0.91
	>=dev-perl/Apache-Session-1.88
	dev-perl/Class-Container"
