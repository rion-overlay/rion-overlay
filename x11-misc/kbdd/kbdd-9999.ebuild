# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 autotools

DESCRIPTION="Very simple layout switcher"
HOMEPAGE="https://github.com/qnikst/kbdd"
SRC_URI=""

EGIT_REPO_URI="https://github.com/qnikst/kbdd.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="dbus debug"

DEPEND="dev-libs/glib:2=
	x11-libs/libX11:0=
	dbus? (
		sys-apps/dbus:0=
		>=dev-libs/dbus-glib-0.86:0=
	)
"
RDEPEND="${DEPEND}"

src_prepare() {
	eapply_user
	eautoreconf
}

src_configure() {
	econf $(use_enable dbus) $(use_enable debug) || die "econf failed"
}
