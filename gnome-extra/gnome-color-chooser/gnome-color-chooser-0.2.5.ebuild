# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-color-chooser/gnome-color-chooser-0.2.4.ebuild,v 1.2 2009/08/04 05:35:43 maekke Exp $

EAPI=1

inherit gnome2 flag-o-matic

DESCRIPTION="GTK+/GNOME color customization tool."
HOMEPAGE="http://gnomecc.sourceforge.net/"
SRC_URI="mirror://sourceforge/gnomecc/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="debug"

RDEPEND=">=dev-cpp/libglademm-2.6.0:2.4
	>=dev-cpp/gtkmm-2.8.0:2.4
	>=gnome-base/libgnome-2.16.0
	>=gnome-base/libgnomeui-2.14.0
	>=dev-libs/libxml2-2.6.0"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_compile() {
	# Don't pass --enable/disable-assert since it has broken
	# AC_ARG_ENABLE call. Pass -DNDEBUG to cppflags instead.
	use debug || append-cppflags -DNDEBUG

	econf \
		--disable-dependency-tracking \
		--disable-link-as-needed
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	dodoc AUTHORS README THANKS ChangeLog  || die "dodoc failed"
}
