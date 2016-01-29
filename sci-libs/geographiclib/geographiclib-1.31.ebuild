# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

AUTOTOOLS_IN_SOURCE_BUILD=1
AUTOTOOLS_AUTORECONF=1

PYTHON_COMPAT=( python{2_5,2_6,2_7,3_1,3_2,3_3} )
DISTUTILS_OPTIONAL="true"

inherit autotools-utils distutils-r1

DESCRIPTION="Small set of C++ classes for performing various geographic and geodesic conversions"
HOMEPAGE="http://geographiclib.sourceforge.net/"
MY_P="GeographicLib-${PV}"
SRC_URI="mirror://sourceforge/${PN}/${MY_P/_p/-pl}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc python static-libs"

DEPEND="python? ( ${PYTHON_DEPS} )"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/strip_py_from_mkfile.patch )

S="${WORKDIR}/${MY_P%_p[^digit]*}"

src_prepare() {
	autotools-utils_src_prepare
}

src_configure() {
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile
	if use python; then
		pushd "${S}/python"
		distutils-r1_src_compile
		popd
	fi
}

src_install() {
	autotools-utils_src_install
	rm -rf "${D}"/usr/share/doc/
	if use python; then
		pushd "${S}/python"
		distutils-r1_src_install
		popd
	fi
	if use doc; then
		dohtml -r doc/* || die "Installing HTML documentation failed"
	fi
}
