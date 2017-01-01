# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="6"

inherit psiplus-plugin

DESCRIPTION="OTR Plugin for Psi"
HOMEPAGE="http://public.tfh-berlin.de/~s30935/"

KEYWORDS=""
IUSE=""

DEPEND="
	app-text/tidy-html5
	net-libs/libotr
"
RDEPEND="${DEPEND}"
