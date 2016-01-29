# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit psiplus-plugin

DESCRIPTION="OTR Plugin for Psi"
HOMEPAGE="http://public.tfh-berlin.de/~s30935/"

KEYWORDS=""
IUSE=""

DEPEND="
	app-text/htmltidy
	net-libs/libotr
"
RDEPEND="${DEPEND}"
