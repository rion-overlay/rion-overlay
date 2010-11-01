# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/remmina/remmina-0.7.5.ebuild,v 1.2 2010/05/27 15:18:05 nyhm Exp $

EAPI=3
inherit xfconf

DESCRIPTION="XFCE panel plugin for remmina"
HOMEPAGE="http://remmina.sourceforge.net/"
SRC_URI="mirror://sourceforge/remmina/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="avahi nls"

RDEPEND="xfce-base/xfce4-panel
	xfce-base/libxfce4util
	avahi? ( net-dns/avahi )
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	dev-util/intltool
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )"
RDEPEND="${RDEPEND}
	>=net-misc/remmina-0.8.0"

pkg_setup() {
	XFCONF="--disable-dependency-tracking
		$(use_enable avahi)
		$(use_enable nls)"
	DOCS="AUTHORS ChangeLog NEWS README"
}
