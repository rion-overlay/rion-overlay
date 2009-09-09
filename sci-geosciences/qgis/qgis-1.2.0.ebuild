# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4 cmake-utils


DESCRIPTION="Quantum GIS (QGIS) is a Geographic Information System (GIS)"
HOMEPAGE="http://www.qgis.org/"
SRC_URI="http://download.osgeo.org/"${PN}"/src/"${PN}"_"${PV}".tar.gz
	samples? ( http://download.osgeo.org/"${PN}"/data/"${PN}"_sample_data.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="debug gps +grass gsl +postgres +python samples test"

DEPEND=">=sci-libs/gdal-1.3.1
		x11-libs/qt-core:4[qt3support]
		x11-libs/qt-gui:4
		x11-libs/qt-svg:4
		x11-libs/qt-sql:4
		dev-db/sqlite:3
		sci-libs/geos
		sci-libs/proj
		postgres? ( >=virtual/postgresql-base-8
				dev-db/postgis[proj] )
		grass? ( sci-geosciences/grass:6[python=,largefile] )
		gps? ( dev-libs/expat
			sci-geosciences/gpsbabel )
		gsl? ( sci-libs/gsl )"

RDEPEND="${DEPEND}
		sys-devel/bison
		sys-devel/flex
		python? ( >=dev-lang/python-2.5
			>=dev-python/PyQt4-4.1
			>=dev-python/sip-4.7 )
		gps? ( sci-geosciences/gpsbabel )
		test? ( x11-libs/qt-test:4 )"

src_unpack() {
	unpack ""${PN}"_"${PV}".tar.gz"
	use samples && unpack ""${PN}"_sample_data.tar.gz"
}
src_prepare() {
		
		epatch "${FILESDIR}"/gentofy-cmake.patch
	
	if use python; then
		epatch "${FILESDIR}"/gentofy-py-cmake.patch
	fi

}

src_configure() {
	local mycmakeargs
	mycmakeargs="${mycmakeargs} -DBUILD_SHARED_LIBS:BOOL=ON \
		$(cmake-utils_use_with postgres POSTGRESQL) \
		$(cmake-utils_use_with grass GRASS) \
		$(cmake-utils_use_with gps EXPAT) \
		$(cmake-utils_use_with gsl GSL) \
		$(cmake-utils_use_with python BINDINGS) \
		$(cmake-utils_use_with test TEST) "

	if use grass; then
		GRASS_ENVD="/etc/env.d/99grass /etc/env.d/99grass-6 /etc/env.d/99grass-cvs";
		for file in ${GRASS_ENVD}; do
			if test -r ${file}; then
				GRASSPATH=$(sed -n 's/LDPATH="\(.*\)\/lib"$/\1/p' ${file});
			fi
		done
		mycmakeargs="${mycmakeargs} -DGRASS_PREFIX=${GRASSPATH}"
	fi
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	newicon images/icons/qgis-icon.png qgis.png
	make_desktop_entry qgis Qgis qgis.png 'Science;Geoscience'

	if use samples; then
		cd "${WORKDIR}"
		insinto /usr/share/doc/${PF}/sample_data
		doins -r qgis_sample_data/* || die "Unable to install sample data"
	fi
	use python &&  python_need_rebuild
		
}

src_test() {
	use test && cmake-utils_src_test
}
pkg_postinst() {
	if use samples; then
		einfo "You can find sample data to use with qgis in"
		einfo "/usr/share/doc/${PF}/sample_data/"
	fi
}
pkg_postrm() {
	use python && python_mod_cleanup
}
