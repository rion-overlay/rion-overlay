# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit gnome2-utils

DESCRIPTION="Elementary gnome icon theme"
HOMEPAGE="http://danrabbit.deviantart.com/art/Elementary-Icons-65437279"
SRC_URI="http://fc06.deviantart.com/fs46/f/2009/187/1/b/elementary_Icons_by_DanRabbit.zip -> ${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 sh sparc x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND=""
RESTRICT="binchecks strip"
S="${WORKDIR}/elementary"

src_unpack() {
	unpack ${A}
	cd "${S}"
	tar xzpf "elementary_${PV}.tar.gz"
}

src_install() {
	insinto /usr/share/icons
	doins -r elementary
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
