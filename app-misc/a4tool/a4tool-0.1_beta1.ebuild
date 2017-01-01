# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit user

DESCRIPTION="Tools for control your smart mouse. A4Tech G10-700F, and other Oscar mouse's"
HOMEPAGE="https://github.com/Marisa-Chan/init-gmouse"

STABLE_REV="cf30b50ccc5d52ada56b5b2a1343fdf63ee2424b"
#BEST_FORK="Marisa-Chan"
BEST_FORK="BondarenkoArtur"
SRC_URI="https://github.com/${BEST_FORK}/init-gmouse/archive/${STABLE_REV}.zip"
S="${WORKDIR}/init-gmouse-${STABLE_REV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="battery"

DEPEND="virtual/libusb:1
	battery? ( x11-libs/libnotify )"
RDEPEND="${DEPEND} virtual/udev"

pkg_setup() {
	if use battery; then
		enewgroup gmouse
	fi
}

src_compile() {
	cd libgmouse
	make || die "Failed to build libgmouse"
	cd ../a4tool
	make || die "Failed to build a4tool"
}

src_install() {
	dobin a4tool/a4tool
	dodir /usr/share/${PN}

	if use battery; then
		insinto /usr/share/${PN}
		doins a4toold/*.png
		insinto /etc
		doins a4toold/a4toold.conf
		dobin a4toold/a4toold.sh

		insinto /lib/udev/rules.d
		doins udev/*

		elog "You have enabled mouse battery notification support"
		elog "To make it working you have to.."
		elog "  1. Add yourself to 'gmouse' group."
		elog "  2. Put a4toold.sh to autostart under your user"
		elog "  3. Configure /etc/a4toold.conf"
		elog
	fi
}
