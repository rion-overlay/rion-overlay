# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit qt4 flag-o-matic fdo-mime eutils

DESCRIPTION="Graphical interface for QEMU and KVM emulators. Using Qt4."
HOMEPAGE="http://sourceforge.net/projects/aqemu/"
SRC_URI="mirror://sourceforge/aqemu/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="kvm linguas_ru vnc"

RDEPEND="${DEPEND}"

DEPEND="kvm? ( app-emulation/qemu-kvm )
	!kvm? ( >=app-emulation/qemu-0.9.0 )
	vnc? ( net-libs/libvncserver )
	x11-libs/qt-gui:4"

DOCS="AUTHORS CHANGELOG README TODO"

src_configure() {
	append-ldflags --as-needed

	if use  vnc;then
		eqmake4  "AQEMU.pro" || die "eqmake4 AQEMU.pro failed"
	else
		eqmake4 "AQEMU_Without_VNC.pro" \
			|| die "eqmake4 AQEMU_Without_VNC.pro failed "
	fi
}

src_install() {

	dobin AQEMU

	if use linguas_ru;then
		insinto /usr/share/aqemu
		doins Russian.qm
	fi

	insinto /usr/share/aqemu/os_icons
	doins "${S}"/os_icons/*.png

	insinto /usr/share/aqemu/os_templates/
	doins "${S}"/os_templates/*.aqvmt

	sed -i '/Exec/s:aqemu:AQEMU:' menu_data/aqemu.desktop || die "sed failed"

	domenu "${S}/menu_data/aqemu.desktop"
	doicon "${S}"/menu_data/aqemu_*.png

}

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
