# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/remmina/remmina-0.7.5.ebuild,v 1.2 2010/05/27 15:18:05 nyhm Exp $

EAPI=2
inherit eutils gnome2-utils

DESCRIPTION="A GTK+ RDP, VNC, XDMCP and SSH client"
HOMEPAGE="http://remmina.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="avahi crypt debug nls ssh unique vte"

RDEPEND="x11-libs/gtk+:2
	avahi? ( net-dns/avahi )
	crypt? ( dev-libs/libgcrypt )
	nls? ( virtual/libintl )
	ssh? ( net-libs/libssh[sftp] )
	unique? ( dev-libs/libunique )
	vte? ( x11-libs/vte )"
DEPEND="${RDEPEND}
	dev-util/intltool
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )"

src_configure() {
	if use ssh && ! use vte; then
		ewarn "Enabling ssh without vte only provides sftp support."
	fi

	econf \
		--disable-dependency-tracking \
		$(use_enable avahi) \
		$(use_enable crypt gcrypt) \
		$(use_enable debug) \
		$(use_enable nls) \
		$(use_enable ssh) \
		$(use_enable unique) \
		$(use_enable vte) \
		|| die "configuration failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog README
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
