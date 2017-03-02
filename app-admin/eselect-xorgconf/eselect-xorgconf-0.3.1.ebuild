# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="An eselect module to manage xorg.conf symlink(s)"
HOMEPAGE="https://bitbucket.org/skrattaren/eselect-xorgconf"
SRC_URI="https://bitbucket.org/skrattaren/${PN}/downloads/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	app-admin/eselect
	x11-base/xorg-server"

src_install() {
	insinto /usr/share/eselect/modules
	doins xorg.conf* || die
	dodoc README.md
}

pkg_postinst() {
	elog "Don't forget to rename your xorg.conf to something like"
	elog "xorg.conf.<your card name> prior to eselecting it"
}
