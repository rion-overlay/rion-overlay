# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit flag-o-matic versionator eutils

DESCRIPTION="Canonical's on-screen-display notification agent."
HOMEPAGE="https://launchpad.net/notify-osd"
#SRC_URI="http://launchpad.net/${PN}/lucid/ubuntu-10.04-beta-2/+download/${P}.tar.gz"
SRC_URI="http://launchpadlibrarian.net/43419242/${P}.tar.gz"
#http://launchpad.net/notify-osd/lucid/ubuntu-10.04-beta-2/+download/notify-osd-0.9.29.tar.gz
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/dbus-glib-0.76
	>=dev-libs/glib-2.16.0
	gnome-base/gconf:2
	>=x11-libs/gtk+-2.6
	x11-libs/libwnck
	!x11-misc/notification-daemon
	x11-libs/libnotify"
DEPEND="${RDEPEND}"

src_configure() {
	append-flags -fno-strict-aliasing
	default
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
}
