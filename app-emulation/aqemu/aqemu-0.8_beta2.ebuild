# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

WANT_CMAKE="always"
MY_P="AQEMU-0.8-Beta2"

inherit  cmake-utils

DESCRIPTION="Graphical interface for QEMU and KVM emulators. Using Qt4."
HOMEPAGE="http://sourceforge.net/projects/aqemu/"
SRC_URI="mirror://sourceforge/aqemu/0.8/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="kvm linguas_ru vnc debug"

DEPEND="x11-libs/qt-gui:4
	x11-libs/qt-test:4
	x11-libs/qt-xmlpatterns:4
	vnc? ( net-libs/libvncserver ) "

RDEPEND="kvm? ( app-emulation/qemu-kvm )
	!kvm? ( >=app-emulation/qemu-0.9.0 )
	${DEPEND}"

DOCS="AUTHORS CHANGELOG README TODO"
S="${WORKDIR}/${MY_P}"

src_configure() {

	local mycmakeargs=" -DCMAKE_VERBOSE_MAKEFILE=OFF"

	if use vnc; then
		mycmakeargs+=" -DWITHOUT_EMBEDDED_DISPLAY=OFF "
	else
		mycmakeargs+=" -DWITHOUT_EMBEDDED_DISPLAY=ON "
	fi

	if use debug; then
		mycmakeargs+=" -DDEBUG=on "
	fi

	cmake-utils_src_configure
}

src_install() {

	if use linguas_ru; then
		insinto /usr/share/aqemu
		doins "${S}"_build/Russian.qm || die
	fi
	cmake-utils_src_install
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update

	elog ""
	elog "Files VM versions below 0.5 are NOT supported!"
	elog "When you upgrade from version 0.5	or above, simply"
	elog "click Apply for each VM to keep it in the new version."
	elog ""
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
