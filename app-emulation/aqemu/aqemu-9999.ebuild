# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit git cmake-utils

DESCRIPTION="Graphical interface for QEMU emulator. Using Qt4."
HOMEPAGE="http://sourceforge.net/projects/aqemu/"
EGIT_REPO_URI="git://aqemu.git.sourceforge.net/gitroot/aqemu/aqemu"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="kvm linguas_ru vnc"

DEPEND="${RDEPEND}"

RDEPEND="kvm? ( app-emulation/qemu-kvm )
		!kvm? ( >=app-emulation/qemu-0.9.0 )
		 vnc? ( net-libs/libvncserver )
		 x11-libs/qt-gui:4"
DOCS="AUTHORS CHANGELOG README TODO"

src_unpack() {
	git_src_unpack
}
