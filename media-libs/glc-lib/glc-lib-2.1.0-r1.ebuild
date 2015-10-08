# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit qmake-utils multibuild multilib

MY_PN="GLC_lib"

SRC_URI="mirror://sourceforge/${PN}/${MY_PN}_src_${PV}.zip"

DESCRIPTION="OpenGL Library Class"
HOMEPAGE="http://www.glc-lib.net/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug qt4 qt5"

REQUIRED_USE="|| ( qt4 qt5 )"

DEPEND="qt4? ( dev-qt/qtopengl:4 )
	qt5? ( dev-qt/qtopengl:5 )
	sys-libs/zlib
	virtual/glu"

RDEPEND="${DEPEND}"

S="${WORKDIR}/glc_lib"

src_prepare() {
	epatch	"${FILESDIR}/${P}-install_path.patch" \
		"${FILESDIR}/${PN}-depend_on_libGLU.patch" \
		"${FILESDIR}/${PN}-fix_inline_shared_functions.patch" \
		"${FILESDIR}/${P}-qt5.patch" \
		"${FILESDIR}/${P}-qt-multilib.patch"

	MULTIBUILD_VARIANTS=( )
	use qt4 &&  MULTIBUILD_VARIANTS+=( qt4 )
	use qt5 &&  MULTIBUILD_VARIANTS+=( qt5 )
	multibuild_copy_sources
}

src_configure() {
	configuration() {
	case "${MULTIBUILD_VARIANT}" in
		qt4)
			eqmake4
			;;
		qt5)
			eqmake5
			;;
		esac
	}
	multibuild_parallel_foreach_variant run_in_build_dir configuration
}

src_compile() {
	multibuild_foreach_variant run_in_build_dir default
}

src_install() {
	multibuild_foreach_variant run_in_build_dir emake INSTALL_ROOT="${D}" install
}
