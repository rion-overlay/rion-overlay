# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7} )

inherit base versionator distutils-r1 fdo-mime

DESCRIPTION="Phatch is a simple to use cross-platform GUI Photo Batch Processor"
HOMEPAGE="http://photobatch.stani.be/"

SRC_URI="http://photobatch.stani.be/download/package/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/wxpython
	virtual/python-imaging"

RDEPEND="${DEPEND}
	sys-apps/mlocate"

PATCHES=( "${FILESDIR}"/*.patch )
S="${WORKDIR}/${PN}-$(get_version_component_range 1-3)"

pkg_postinst()
{
	distutils_pkg_postinst
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
