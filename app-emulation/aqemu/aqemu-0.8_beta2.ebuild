# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P="AQEMU-0.8-Beta2"
EAPI=2

inherit qt4 flag-o-matic fdo-mime eutils cmake-utils

DESCRIPTION="Graphical interface for QEMU and KVM emulators. Using Qt4."
HOMEPAGE="http://sourceforge.net/projects/aqemu/"
SRC_URI="mirror://sourceforge/aqemu/0.8/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="${DEPEND}"

DEPEND="kvm? ( app-emulation/qemu-kvm )
	!kvm? ( >=app-emulation/qemu-0.9.0 )
	vnc? ( net-libs/libvncserver )
	x11-libs/qt-gui:4"

DOCS="AUTHORS CHANGELOG README TODO"

S="${WORKDIR}/${MY_P}"
pkg_postinst() {

	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update

	echo
	elog "Files VM versions below 0.5 are NOT supported!"
	elog "When you upgrade from version 0.5 or above, simply"
	elog "click Apply for each VM to keep it in the new version."
	echo
}
pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
