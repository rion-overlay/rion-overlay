# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit gnome2-utils

DESCRIPTION="Elementary gnome icon theme"
HOMEPAGE="http://danrabbit.deviantart.com/art/Elementary-Icons-65437279"
SRC_URI="http://fc03.deviantart.net/fs71/f/2010/099/a/2/elementary_Icons_by_DanRabbit.zip -> ${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="monochrome"

DEPEND=""
RDEPEND=""
RESTRICT="binchecks strip"

src_unpack() {
	unpack ${A}
	tar xzpf "elementary.tar.gz"
	use monochrome && tar xzpf "elementary-monochrome.tar.gz"
}

src_install() {
	insinto /usr/share/icons
	doins -r elementary
	use monochrome && doins -r elementary-monochrome
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
