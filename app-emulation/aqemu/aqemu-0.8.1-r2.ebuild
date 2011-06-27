# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit  cmake-utils

DESCRIPTION="Graphical interface for QEMU and KVM emulators. Using Qt4."
HOMEPAGE="http://sourceforge.net/projects/aqemu"
SRC_URI="mirror://sourceforge/aqemu/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="kvm vnc spice"

DEPEND="${RDEPEND}"
RDEPEND="
	vnc? ( net-libs/libvncserver )
	virtual/qemu[kvm=,spice=]
	x11-libs/qt-gui:4
	x11-libs/qt-test:4
	x11-libs/qt-xmlpatterns:4"

REQUIRED_USE="spice? ( kvm )"

DOCS="AUTHORS CHANGELOG README TODO"

src_configure() {

	local mycmakeargs=" -DCMAKE_VERBOSE_MAKEFILE=OFF"
	if use vnc; then
		mycmakeargs+=" -DWITHOUT_EMBEDDED_DISPLAY=OFF "
	else
		mycmakeargs+=" -DWITHOUT_EMBEDDED_DISPLAY=ON "
	fi

	cmake-utils_src_configure
}
