# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyxdg/pyxdg-0.17-r1.ebuild,v 1.9 2009/07/26 22:29:45 ranger Exp $

NEED_PYTHON=2.4

inherit distutils

DESCRIPTION="a python module to deal with freedesktop.org specifications."
SRC_URI="http://www.freedesktop.org/~lanius/${P}.tar.gz"
HOMEPAGE="http://pyxdg.freedesktop.org/"
LICENSE="LGPL-2"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
SLOT="0"
IUSE="gnome"

src_unpack() {
	distutils_src_unpack
	epatch "${FILESDIR}/${PN}-subprocess.patch"
	use gnome && epatch "${FILESDIR}/gnome-2.26.patch"
}

src_install () {
	DOCS="AUTHORS"
	distutils_src_install
	python_need_rebuild

	insinto /usr/share/doc/${P}/test
	insopts -m 755
	doins test/*
}
