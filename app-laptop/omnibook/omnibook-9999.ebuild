# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit linux-mod eutils subversion

DESCRIPTION="Linux kernel module for (but not limited to) HP Omnibook support"
HOMEPAGE="http://www.sourceforge.net/projects/omnibook"
ESVN_REPO_URI="https://omnibook.svn.sourceforge.net/svnroot/omnibook/trunk"
ESVN_PATCHES="*.patch"

LICENSE="GPL-2"
KEYWORDS=""
IUSE=""

MODULE_NAMES="omnibook(char:)"
BUILD_TARGETS=" "

pkg_setup() {
	linux-mod_pkg_setup
	BUILD_PARAMS="KERNEL=${KV_MAJOR}.${KV_MINOR} KSRC=${KV_DIR}"
}

src_compile() {
	linux-mod_src_compile
}

src_install() {
	dodoc doc/*
	docinto misc
	dodoc misc/*.patch misc/*.txt
	docinto hotkeys
	dodoc misc/hotkeys/*

	linux-mod_src_install
}
