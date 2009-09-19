# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

inherit distutils fdo-mime

DESCRIPTION="Phatch is a simple to use cross-platform GUI Photo Batch Processor"
HOMEPAGE="http://photobatch.stani.be/"

SRC_URI="http://sd-2469.dedibox.fr/photobatch/download/package/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/python
	dev-python/wxpython
	dev-python/imaging"

RDEPEND="${DEPEND}"

src_unpack() {
	distutils_src_unpack
	epatch "${FILESDIR}/${P}.patch"
}

pkg_postinst()
{
	distutils_pkg_postinst
	# # update mime and desktop databases (removed from setup.py by the patch)
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update
}
