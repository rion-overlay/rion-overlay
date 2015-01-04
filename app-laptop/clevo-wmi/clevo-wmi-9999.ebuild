# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-r3 linux-mod

DESCRIPTION="WMI driver for Clevo laptops"
HOMEPAGE="http://forum.notebookreview.com/linux-compatibility-software/708796-clevo-p150em-p170em-sager-np9150-9170-backlit-keyboard-driver-beta-testers-needed.html"
EGIT_REPO_URI="git://git.code.sf.net/p/${PN}/code"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="virtual/linux-sources
	sys-kernel/linux-headers"
RDEPEND=""

MODULE_NAMES="clevo_wmi(wmi:${S})"

pkg_pretend() {
	CONFIG_CHECK="ACPI_WMI"
	check_extra_config
}

pkg_setup() {
	linux-mod_pkg_setup
	BUILD_TARGETS="all"
}

src_prepare() {
	sed -i -e "s|KDIR :=.*|KDIR := ${KERNEL_DIR}|" \
	  Makefile || die "Failed to change Makefile"
}
