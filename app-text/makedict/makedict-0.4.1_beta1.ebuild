# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit cmake-utils python

DESCRIPTION="Dictionary converter"
HOMEPAGE="http://sourceforge.net/projects/xdxf/"

MY_PV=${PV/_/-}
SRC_URI="mirror://sourceforge/xdxf/${PN}-${MY_PV}-Source.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-libs/glib-2.6.0
	sys-libs/zlib
	dev-libs/expat"
RDEPEND="${DEPEND}
	dev-lang/python"

S="${WORKDIR}/${PN}-${MY_PV}-Source"

src_install() {
	cmake-utils_src_install

	makedict_install() {
		cp "${D}/usr/lib/makedict-codecs/apresyan.py" "${D}/usr/lib/makedict-codecs/apresyan.py-${PYTHON_ABI}"
		cp "${D}/usr/lib/makedict-codecs/mueller7_parser.py" "${D}/usr/lib/makedict-codecs/mueller7_parser.py-${PYTHON_ABI}"
	}

	python_execute_function makedict_install

	python_generate_wrapper_scripts --force "${D}/usr/lib/makedict-codecs/apresyan.py"
	python_generate_wrapper_scripts --force "${D}/usr/lib/makedict-codecs/mueller7_parser.py"
}
