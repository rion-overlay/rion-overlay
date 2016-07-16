# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="6"

inherit git-r3 linux-mod

DESCRIPTION="Driver for realtek 5289/8411 card readers"
HOMEPAGE="https://bugs.launchpad.net/ubuntu/+source/udisks/+bug/971876"
EGIT_REPO_URI="https://github.com/Ri0n/rts_bpp"

LICENSE="GPL-2"
KEYWORDS=""
IUSE=""

MODULE_NAMES="rts_bpp(char:)"
BUILD_TARGETS=" "

pkg_setup() {
	linux-mod_pkg_setup
}

src_prepare() {
	default
	sed -i -e "s/\$(shell uname -r)/$KV_FULL/g" \
		"${S}"/Makefile || die "sed makefile"
}
