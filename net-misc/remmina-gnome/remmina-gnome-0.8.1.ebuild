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
KEYWORDS="~x86"
IUSE="avahi nls"

RDEPEND="gnome-base/gnome-panel
	avahi? ( net-dns/avahi )
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	dev-util/intltool
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )"
RDEPEND="${RDEPEND}
	>=net-misc/remmina-0.8.0"

src_configure() {
	econf \
		--disable-dependency-tracking \
		$(use_enable avahi) \
		$(use_enable nls) \
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
