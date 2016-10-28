# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils gnome.org git-2 autotools

# NetworkManager likes itself with capital letters
MY_PN="${PN/networkmanager/NetworkManager}"

DESCRIPTION="NetworkManager L2TP plugin"
HOMEPAGE="http://www.gnome.org/projects/NetworkManager/"
#SRC_URI="${SRC_URI//${PN}/${MY_PN}}"
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
	net-misc/libreswan
	gnome? (
		>=x11-libs/gtk+-3.4:4
		gnome-base/libgnome-keyring
	)"

DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/intltool
	virtual/pkgconfig"

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	mkdir -p m4
	intltoolize --copy --force --automake 
	eautoreconf
}

src_configure() {
	ECONF="--with-pppd-plugin-dir=${EPREFIX}/usr/$(get_libdir)/pppd/2.4.7
		$(use_with gnome)
		$(use_enable static-libs static)"

	econf ${ECONF}
}

src_install() {
	emake DESTDIR="${ED}" install
	dodoc AUTHORS ChangeLog NEWS README.md
}
