# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit versionator distutils-r1 xdg-utils git-r3

DESCRIPTION="Phatch is a simple to use cross-platform GUI Photo Batch Processor"
HOMEPAGE="http://photobatch.stani.be/"

#SRC_URI="http://photobatch.stani.be/download/package/${P}.tar.gz"
EGIT_REPO_URI="https://github.com/tibor95/phatch-python2.7.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-python/wxpython:=
	dev-python/pillow"

RDEPEND="${DEPEND}
	sys-apps/mlocate"

PATCHES=( "${FILESDIR}"/crash_fix.patch )
S="${WORKDIR}/${PN}-$(get_version_component_range 1-3)"

pkg_postinst()
{
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
