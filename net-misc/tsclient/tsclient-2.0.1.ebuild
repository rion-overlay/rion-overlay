# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2-utils flag-o-matic

DESCRIPTION="GTK2 frontend for rdesktop"
HOMEPAGE="http://tsclient.sourceforge.net/"
SRC_URI="http://downloads.sourceforge.net/tsclient/${P}.tar.bz2"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug vnc"

RDEPEND=">=x11-libs/gtk+-2.0
	>=dev-libs/glib-2.0
	>=net-misc/rdesktop-1.3.0
	>=gnome-base/libgnomeui-2.0
	>=gnome-base/gnome-panel-2.0
	net-misc/networkmanager
	vnc? (
		|| (
			net-misc/vnc
			net-misc/tightvnc ) )"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.27
	dev-util/pkgconfig"

src_compile() {
	filter-ldflags -Wl,--as-needed #fix link with libnotify
	econf $(use_enable debug) || die "configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS NEWS README
}

pkg_postinst() {
	gnome2_icon_cache_update
}
