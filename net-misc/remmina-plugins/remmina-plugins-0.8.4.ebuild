# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/remmina/remmina-0.7.5.ebuild,v 1.2 2010/05/27 15:18:05 nyhm Exp $

EAPI=2
inherit gnome2-utils

DESCRIPTION="A GTK+ RDP, VNC, XDMCP and SSH client"
HOMEPAGE="http://remmina.sourceforge.net/"
SRC_URI="mirror://sourceforge/remmina/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="debug nls nx rdesktop ssh telepathy vnc xdmcp"

RDEPEND="nls? ( virtual/libintl )
	ssh? ( net-libs/libssh[sftp] )
	vnc? ( net-libs/libvncserver )"
DEPEND="${RDEPEND}
	dev-util/intltool
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )
	telepathy? ( >=net-libs/telepathy-glib-0.9.0 ) "
RDEPEND="${RDEPEND}
	>=net-misc/remmina-0.8.0
	rdesktop? ( net-misc/freerdp )
	nx? ( net-misc/nx )
	xdmcp? ( x11-base/xorg-server[kdrive] )"

src_prepare() {
		if has_version ">net-misc/freerdp-0.7.4"; then
			sed -i -e 's/rdp5_performanceflags/performanceflags/g' \
				rdp/remminapluginrdp.c
		fi
}

src_configure() {
	if use nx && ! use ssh; then
		ewarn "nx support requires ssh."
		ewarn "nx support will not be included."
	fi

	econf \
		--disable-dependency-tracking \
		$(use_enable debug) \
		$(use_enable nls) \
		$(use_enable ssh) \
		$(use_enable vnc) \
		$(use_enable nx ) \
		$(use_enable telepathy) \
		$(use_enable xdmcp) \
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
