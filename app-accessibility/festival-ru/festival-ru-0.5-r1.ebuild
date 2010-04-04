# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

DESCRIPTION="Russian language for Festival Text to Speech engine"
HOMEPAGE="https://developer.berlios.de/projects/festlang/"
SRC_URI="mirror://berlios/festlang/msu_ru_nsh_clunits-${PV}.tar.bz2"

LICENSE="FESTIVAL BSD as-is"

SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=app-accessibility/festival-1.96_beta-r1"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/msu_ru_nsh_clunits

src_install() {

	# Install the main libraries
	insinto /usr/share/festival/voices/russian/msu_ru_nsh_clunits
	doins -r * || die "install failed"

	dodoc NOTES README
}
