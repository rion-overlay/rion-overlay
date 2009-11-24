# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
MODULE_AUTHOR="SCOTTW"
inherit perl-module

DESCRIPTION="PayPal API"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-perl/SOAP-Lite"
RDEPEND="${DEPEND}"
SRC_TEST="do"
