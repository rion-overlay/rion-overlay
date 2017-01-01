# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit gnome2-utils

MY_P="elementaryicons${PV}"

DESCRIPTION="Elementary gnome icon theme"
HOMEPAGE="https://launchpad.net/elementaryicons"
SRC_URI="http://launchpad.net/elementaryicons/3.x/${PV}/+download/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="x11-themes/gnome-icon-theme
	x11-themes/hicolor-icon-theme"
RESTRICT="binchecks strip"

S="${WORKDIR}/${MY_P}"

src_install() {
	insinto /usr/share/icons/elementary
	#cd "${WORKDIR}/${PN}"
	doins -r .
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
