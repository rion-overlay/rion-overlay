# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
GNOME_ORG_MODULE="NetworkManager-${PN##*-}"

inherit gnome.org

DESCRIPTION="Client for the proprietary Microsoft Secure Socket Tunneling
Protocol, SSTP."
HOMEPAGE="http://sourceforge.net/projects/sstp-client/"
SRC_URI="mirror://sourceforge/project/sstp-client/network-manager-sstp/${PV}-1/NetworkManager-sstp-0.9.4.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk"

RDEPEND="
	net-misc/sstp-client
	>=net-misc/networkmanager-${PV}
	>=dev-libs/dbus-glib-0.74
	"

DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/intltool
	virtual/pkgconfig
	"

src_configure() {
	ECONF=" --disable-more-warnings
			--disable-static
			--with-dist-version=Gentoo
			--with-gtkver=3
			 $(use_with gtk gnome)"

	econf ${ECONF}
}

src_install() {
	default

	find "${D}" -name '*.la' -exec rm -f {} +
}
