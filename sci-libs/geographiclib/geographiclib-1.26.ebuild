# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

AUTOTOOLS_IN_SOURCE_BUILD=1
AUTOTOOLS_AUTORECONF=1

SUPPORT_PYTHON_ABIS="1"
PYTHON_DEPEND="python? *"

inherit autotools-utils distutils

DESCRIPTION="Small set of C++ classes for performing various geographic and geodesic conversions"
HOMEPAGE="http://geographiclib.sourceforge.net/"
MY_P="GeographicLib-${PV}"
SRC_URI="mirror://sourceforge/${PN}/${MY_P/_p/-pl}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc python static-libs"

DEPEND=""
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/strip_py_from_mkfile.patch )

S="${WORKDIR}/${MY_P%_p[^digit]*}"

src_prepare() {
	autotools-utils_src_prepare
}

src_compile() {
	autotools-utils_src_compile
	if use python; then
		cd "${S}/python"
		distutils_src_compile
		cd "${S}"
	fi
}

src_install() {
	autotools-utils_src_install
	rm -rf "${D}"/usr/share/doc/
	if use python; then
		cd "${S}/python"
		distutils_src_install
		cd "${S}"
	fi
	if use doc; then
		dohtml -r doc/* || die "Installing HTML documentation failed"
	fi
}

pkg_postinst() {
	if use python; then
		distutils_pkg_postinst;
	fi
}

pkg_postrm() {
	if use python; then
		distutils_pkg_postrm;
	fi
}
