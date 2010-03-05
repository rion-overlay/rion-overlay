# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
NEED_PYTHON="2.5"

inherit  python qt4-r2

DESCRIPTION="PythonQt is a dynamic Python binding for Qt. (Revert dev-python/PyQt4  task)"
HOMEPAGE="http://pythonqt.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/pythonqt/pythonqt/PythonQt%201.1/${P}.zip"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test doc examples"

COM_DEPEND="app-arch/zip
		x11-libs/qt-core:4
		x11-libs/qt-gui:4"
DEPEND="${COM_DEPEND}
	test? ( x11-libs/qt-test:4 )"
RDEPEND="${COM_DEPEND}"

python_need_rebuild
src_prepare() {
	python_set_active_version 2
	python_version

	sed -e "s:PYTHON_VERSION=2.5:PYTHON_VERSION=${PYVER}:" -i build/python.prf|| die
	sed -i -e 's/python$${PYTHON_VERSION}-config/python-config/' build/python.prf|| die
}

src_test() {
	if use test; then
		cd "${S}"/tests
		./PythonQtTest
	fi
}

src_install() {

	# install main dir
	insinto usr/include/${PN}
	doins -r src/*.h
	doins -r src/gui/*.h

	dolib.so lib/lib*.so*

	# PythonQtGui headers
	insinto usr/include/${PN}
	doins -r extensions/PythonQtGui/*.h

	if use doc;then
		dohtml -r "${S}/"doxygen/*
	fi
	if use examples;then
		insinto usr/share/${P}
		doins  lib/Py*
	fi
}
