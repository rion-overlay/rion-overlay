# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit git-2 autotools

DESCRIPTION="Very simple layout switcher"
HOMEPAGE="http://github.com/qnikst/kbdd"
SRC_URI=""

EGIT_REPO_URI="git://github.com/qnikst/kbdd.git
			https://github.com/qnikst/kbdd.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="dbus debug"

DEPEND="dev-libs/glib
		x11-libs/libX11
		dbus? (
			sys-apps/dbus
			>=dev-libs/dbus-glib-0.86
			)"
RDEPEND="${DEPEND}"

S="${WORKDIR}/qnikst-kbdd"

src_prepare() {
	eautoreconf
}
src_configure() {
	econf $(use_enable dbus) $(use_enable debug) || die "econf failed"
}
