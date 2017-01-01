# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit  cmake-utils

CMAKE_MIN_VERSION="3.1"
DESCRIPTION="Graphical interface for QEMU and KVM emulators, using Qt4"
HOMEPAGE="https://github.com/tobimensch/aqemu"
SRC_URI="https://github.com/tobimensch/aqemu/archive/v0.9.2.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="vnc"

DEPEND="${RDEPEND}"
RDEPEND="app-emulation/qemu
	vnc? ( net-libs/libvncserver )
	dev-qt/qtgui:4
	dev-qt/qttest:4
	dev-qt/qtxmlpatterns:4"

DOCS="AUTHORS CHANGELOG README TODO"

src_configure() {
	local mycmakeargs=(
		"-DMAN_PAGE_COMPRESSOR="
		"-DWITHOUT_EMBEDDED_DISPLAY=$(use vnc && echo "OFF" || echo "ON")"
	)

	cmake-utils_src_configure
}
