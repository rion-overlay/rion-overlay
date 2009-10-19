# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4 eutils fdo-mime

DESCRIPTION="NetEmul is a program for simulating computer networks"
HOMEPAGE="http://www.sourceforge.net/project/netemul/"
SRC_URI="mirror://sourceforge/netemul/release-0.9.8/netemul-0.9.8.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/qt-script:4
		x11-libs/qt-opengl:4
		x11-libs/qt-gui:4
		x11-libs/qt-core:4"
RDEPEND="${DEPEND}"


src_prepare() {

	epatch "${FILESDIR}"/netemul-pro.patch

}

src_configure() {
	eqmake4 || die "eqmake failed"
}

src_install() {

	emake INSTALL_ROOT="${D}" install || die "emake install failed"

	#insinto /usr/share/"${PN}"/images
	#doins -r "${S}"/images/*

	doicon "${S}"/images/NetEmul.png

	domenu "${FILESDIR}/netemul.desktop"

}

pkg_postinst() {
	fdo-mime_desktop_database_update
}
