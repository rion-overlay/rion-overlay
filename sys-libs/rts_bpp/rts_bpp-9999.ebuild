# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 linux-mod

DESCRIPTION="Driver for realtek 5289/8411 card readers"
HOMEPAGE="https://bugs.launchpad.net/ubuntu/+source/udisks/+bug/971876"
EGIT_REPO_URI="https://github.com/Ri0n/rts_bpp"

LICENSE="GPL-2"
KEYWORDS=""
IUSE=""

MODULE_NAMES="rts_bpp(kernel/drivers/scsi:)"
BUILD_TARGETS=" "

pkg_setup() {
	linux-mod_pkg_setup
	BUILD_PARAMS="MOD_DIR=/lib/modules/${KV_FULL}"
}
