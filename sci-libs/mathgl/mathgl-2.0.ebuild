# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI="4"

# TODO
#PYTHON_DEPEND="python? 2"
#SUPPORT_PYTHON_ABIS="1"
#RESTRICT_PYTHON_ABIS="3.* 2.7-pypy-* *-jython"

inherit cmake-utils wxwidgets

DESCRIPTION="Math Graphics Library"
HOMEPAGE="http://mathgl.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

LANGS="ru"

IUSE="+doc double-precision gif glut +gsl hdf5 jpeg mpi +opengl qt4 threads wxwidgets"

for x in ${LANGS}; do
	IUSE+=" linguas_${x}"
done

RDEPEND="
	media-libs/libpng:0
	>=sys-libs/zlib-1.2.7
	opengl? ( virtual/opengl )
	gif? ( media-libs/giflib )
	glut? ( media-libs/freeglut )
	gsl? ( sci-libs/gsl )
	hdf5? ( >=sci-libs/hdf5-1.8[mpi=] )
	jpeg? ( virtual/jpeg )
	qt4? ( x11-libs/qt-gui:4 )
	!sci-visualization/udav
"
DEPEND="${RDEPEND}
	doc? ( app-text/texi2html virtual/texi2dvi )
"

src_prepare() {
	epatch "${FILESDIR}"/${P}-fix_hardcoded_paths.patch
	sed -e "s/enable-/ENABLE_/g" -i "${S}/CMakeLists.txt"
}

#MAKEOPTS="${MAKEOPTS} -j1"

src_configure() {
	if use wxwidgets; then
		WX_GTK_VER="2.8"
		need-wxwidgets unicode
	fi
	mycmakeargs=(
		$(cmake-utils_use_enable double-precision double)
		$(cmake-utils_use_enable threads pthread)
		$(cmake-utils_use_enable gsl)
		$(cmake-utils_use_enable jpeg)
		$(cmake-utils_use_enable gif)
		$(cmake-utils_use_enable hdf5 hdf5_18)
		$(cmake-utils_use_enable opengl)
		$(cmake-utils_use_enable glut)
		$(cmake-utils_use_enable qt4 qt)
		$(cmake-utils_use_enable doc)
		$(cmake-utils_use_enable wxwidgets wx)
	)
# TODO
#		$(cmake-utils_use_enable ltdl)
#		$(cmake-utils_use_enable fltk)
#		$(cmake-utils_use_enable python)
#		$(cmake-utils_use_enable octave)

	cmake-utils_src_configure
}

src_compile() {
# Parallel build unhappy
	cmake-utils_src_make -j1
}

src_install() {
	cmake-utils_src_install
	if use qt4 ; then
		insinto /usr/share/udav
		for lang in ${LANGS} ; do
			use "linguas_${lang}" && doins "udav/udav_${lang}.qm"
		done
	fi
}
