# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

AUTOTOOLS_AUTORECONF="yes"

inherit git-2 autotools-utils linux-info

DESCRIPTION="Library and tools set for controlling team network device"
HOMEPAGE="https://fedorahosted.org/libteam/"
EGIT_REPO_URI="git://github.com/jpirko/libteam.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+logging debug static-libs"

DEPEND="
	>=dev-libs/libnl-3.2
	dev-libs/libdaemon
	dev-libs/jansson
	sys-apps/dbus
	"
RDEPEND="${DEPEND}"

CONFIG_CHECK="~NET_TEAM ~NET_TEAM_MODE_ROUNDROBIN ~NET_TEAM_MODE_ACTIVEBACKUP"
ERROR_NET_TEAM="NET_TEAM is not enabled in this kernel!"

src_configure() {
	local myeconfargs=(
	$(use_enable debug)
	$(use_enable logging)
	)
	autotools-utils_src_configure
}
