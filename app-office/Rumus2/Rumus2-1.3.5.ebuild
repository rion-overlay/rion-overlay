# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# support ebuild: rion issue
EAPI=2

inherit eutils rpm
DESCRIPTION="FOREX trading and technical analis terminal"
HOMEPAGE="http://www.fxclub.org/tools_soft_rumus2"
SRC_URI="http://download.fxclub.org/"${PN}"/FxClub/"${PN}".rpm -> "${P}.rpm""

RESTRICT="mirror strip"
LICENSE="EULA"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc"

DEPEND=""
RDEPEND="virtual/opengl
		x11-libs/qt:3"

# This is binary qt package

S="${WORKDIR}"/usr/local

src_install() {
	
	dodir /opt/"${P}"
	dodir /opt/"${P}"/bin
	exeinto	/opt/"${P}"/bin
	doexe  "${S}"/bin/rumus



	insinto /opt/"${P}"
	doins -r "${S}"/lib
	doins -r "${S}"/share

	if use doc; then
		insinto /opt/"${P}"
		doins -r "${S}"/help.tar.gz
	fi

	make_wrapper Rumus2 /opt/"${P}"/bin/rumus  /opt/"${P}"/lib

}
