# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit psi-plugin

DESCRIPTION="Psi plugin for OTR message ecnryption"
HOMEPAGE="http://public.tfh-berlin.de/~s30935/"

KEYWORDS=""
IUSE=""

DEPEND="
	app-text/htmltidy
	net-libs/libotr
"
RDEPEND="${DEPEND}"
