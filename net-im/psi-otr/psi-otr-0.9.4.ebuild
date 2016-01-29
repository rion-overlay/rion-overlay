# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit psiplus-plugin

MY_PN="otrplugin"
S="${WORKDIR}/${MY_PN}"
DESCRIPTION="OTR Plugin for Psi"
HOMEPAGE="http://public.tfh-berlin.de/~s30935/"
SRC_URI="http://psi-dev.googlecode.com/files/${MY_PN}-${PV}-src.tar.gz"

KEYWORDS=""
IUSE=""

DEPEND="
	app-text/htmltidy
	net-libs/libotr
"
RDEPEND="${DEPEND}"

src_prepare() {
	psiplus-plugin_src_prepare
	sed -i -e "s@tidy/tidy\\.h@tidy.h@" -e "s@tidy/buffio\\.h@buffio.h@" \
		./src/HtmlTidy.hpp
}
