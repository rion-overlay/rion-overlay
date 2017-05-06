# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

AT_M4DIR="m4"

inherit eutils gnome.org git-r3 autotools

DESCRIPTION="NetworkManager L2TP plugin"
HOMEPAGE="https://github.com/nm-l2tp/network-manager-l2tp"
SRC_URI=""

EGIT_REPO_URI="https://github.com/nm-l2tp/network-manager-l2tp"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome static-libs"

RDEPEND="
	>=net-misc/networkmanager-1.0[ppp]
	dev-libs/dbus-glib
	net-dialup/ppp
	net-dialup/xl2tpd
	>=dev-libs/glib-2.32
	net-vpn/libreswan
	gnome? (
		x11-libs/gtk+:3
		gnome-base/libgnome-keyring
	)"

DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/intltool
	virtual/pkgconfig"

src_prepare() {
	eautoreconf
	eapply_user
}

src_configure() {
	export runstatedir="${EPREFIX}/run/NetworkManager"
	local myeconfargs=(
		$(use_with gnome)
		$(use_enable static-libs static)
	)

	econf "${myeconfargs[@]}"
}
