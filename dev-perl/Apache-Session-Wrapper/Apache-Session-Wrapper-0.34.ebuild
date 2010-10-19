# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

MODULE_AUTHOR=YVES
inherit perl-module

DESCRIPTION="A simple wrapper around Apache::Session"
IUSE="test"
SLOT="0"
KEYWORDS="~x86 ~amd64"

COMM_DEPEND="dev-perl/Exception-Class
	>=dev-perl/Params-Validate-0.91
	>=dev-perl/Apache-Session-1.88
	dev-perl/Class-Container"
DEPEND="${DEPEND}
		test? ( dev-perl/Test-Pod )"
RDEPEND="${COMM_DEPEND}"

SRC_TEST="do"
