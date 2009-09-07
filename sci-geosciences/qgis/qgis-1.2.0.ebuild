# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

PYTHON_DEFINE_DEFAULT_FUNCTIONS=""

inherit python cmake-utils

DESCRIPTION="Quantum GIS (QGIS) is a user friendly Geographic Information System"
HOMEPAGE="http://www.qgis.org/"
SRC_URI="http://download.osgeo.org/qgis/src/qgis_1.2.0.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE="test mapserver"


QT_DEPEND=""
COMMON_DEPEND="
			sci-libs/proj
			dev-libs/expat
			sci-libs/gsl
			>=sci-libs/geos-3
			>=sci-libs/gdal-1.4[geos]
			>=sci-geosciences/grass-6.0
			>=dev-db/libpq-8.0
			mapserver? (
				>=dev-python/sip-4.8
				>=dev-python/PyQt4-4.4[X,opengl,sql,svg,webkit,xmlpatterns]
				)
			dev-db/sqlite:3
			x11-libs/qt-sql:4
			x11-libs/qt-core:4[qt3support,ssl,iconv]
			x11-libs/qt-gui:4[qt3support,tiff]
			x11-libs/qt-opengl:4[qt3support]
			x11-libs/qt-sql:4
			x11-libs/qt-svg:4
			x11-libs/qt-webkit:4
			test? ( x11-libs/qt-test:4 )"

DEPEND="${COMMON_DEPEND}
		 sys-devel/bison
		 sys-devel/flex"

RDEPEND="${COMMON_DEPEND}
		dev-python/pysqlite"

python_need_rebuild

src_prepare() {
	epatch "${FILESDIR}/disabe-default-cmake.patch"
}

src_configure() {
	 mycmakeargs="${mycmakeargs} \
	 		--DWITCH GRASS=ON \
			--DWITCH POSTGRESQL=ON \
			--DWITCH BINDINGS=ON \
			--DWITCH SPATIALITE=ON"

		if use test; then
			mycmakeargs="${mycmakeargs} \
			 $(cmake-utils_use_with test TEST)"
		fi
		 cmake-utils_src_configure

}
src_compile() {
	cmake-utils_src_compile
}
src_install() {
	cmake-utils_src_install
}
src_test() {
	use test && cmake-utils_srs_test
}

pkg_postinst() {
	einfo ""
}

pkg_postrm() {
	python_mod_cleanup
}
