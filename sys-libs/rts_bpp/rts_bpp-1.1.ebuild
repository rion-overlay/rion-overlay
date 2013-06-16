# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils linux-mod

DESCRIPTION="Driver for realtek 5289 card reader"
HOMEPAGE="https://bugs.launchpad.net/ubuntu/+source/udisks/+bug/971876"
SRC_URI="https://bugs.launchpad.net/ubuntu/+source/udisks/+bug/971876/+attachment/2991730/+files/rts_bpp.tar.bz2 -> ${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

MODULE_NAMES="rts_bpp(char:)"
BUILD_TARGETS=" "

pkg_setup() {
	S="${WORKDIR}/${PN}"
	linux-mod_pkg_setup
}

src_prepare() {
	sed -i -e "s/\$(shell uname -r)/$KV_FULL/g" \
		"${S}"/Makefile || die "sed makefile"
	kernel_is -ge 3 8 && {
		sed -i -e "s/__devinit//" -e "s/__devexit//" \
		-e 's/ _p(\(.*\))/ \1/' rtsx.c \
		|| die "sed rtsx.c";
	}
}
