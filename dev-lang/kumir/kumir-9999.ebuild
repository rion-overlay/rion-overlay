# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit subversion qt4 fdo-mime


DESCRIPTION="Implementation of Kumir programming language, designed by academic Ershov"
HOMEPAGE="http://www.infomir.ru/"
SRC_URI=""

ESVN_REPO_URI="http://lpm.org.ru/svn/kumir/trunk/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="x11-libs/qt-core:4
		x11-libs/qt-gui:4
		x11-libs/qt-script:4
		x11-libs/qt-svg:4
		x11-libs/qt-xmlpatterns:4
		"
RDEPEND="${DEPEND}"

src_unpack() {

	subversion_src_unpack
}

src_configure() {

	eqmake4 "${PN}".pro \
		INSTALL_DIR=/usr || die
}

src_install() {
	# IMHO.stub build system
	dobin "${S}"/kumir

	insinto /usr/share/"${PN}"
	doins "${S}"/*.qm
	doins  "${S}"/*.msg
	doins "${S}"/*.lang
	doins "${S}"/macro5.macro
	doins "${S}"/*.rules
	doins "${S}"/pd_init.js

	# install help files
	insinto /usr/share/"${PN}"/help
	doins -r "${S}"/help/*

	#install examples
	insinto /usr/share/"${PN}"/examples/robot/
	doins "${S}"/RoboExamples/obkhod_labirinta.kum

	# Desktop support files
	doicon "${S}"/icons/kumir.png

	insinto /usr/share/mime/packages/
	doins "${S}"/x-kumir-program.xml
	
	domenu "${S}"/x-kumir-program.desktop

	insinto /usr/share/mimelnk/application/
	doins "${S}"/x-kumir-program.xml

	# KDE3 Support - icons && theme


}

pkg_preinst() {
	 subversion_pkg_preinst
}
