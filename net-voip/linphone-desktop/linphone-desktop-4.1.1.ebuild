# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PLOCALES="ar cs de es fi fr he hu it ja lt nb-NO nl pl pt-BR ru sr sv tr zh-CN zh-TW"

EGIT_CLONE_TYPE=shallow

inherit l10n multilib pax-utils cmake-utils git-r3

DESCRIPTION="Video softphone based on the SIP protocol"
HOMEPAGE="http://www.linphone.org/"
EGIT_REPO_URI="https://gitlab.linphone.org/BC/public/linphone-desktop.git"
EGIT_COMMIT="${PV}"
EGIT_MIRROR_URI="https://gitlab.linphone.org/BC/public/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# TODO: run-time test for ipv6: does it need mediastreamer[ipv6]?
IUSE="assistant -doc gsm-nonstandard ipv6 ldap libnotify -ncurses nls +sqlite tools upnp vcard video zlib"

RDEPEND="
	virtual/udev
	media-video/ffmpeg
	ldap? (
		dev-libs/cyrus-sasl
		net-nds/openldap
	)
	ncurses? (
		sys-libs/readline:0
		sys-libs/ncurses:0
	)
	sqlite? ( dev-db/sqlite:3 )
	tools? ( dev-libs/libxml2 )
	upnp? ( net-libs/libupnp:0 )
	zlib? ( sys-libs/zlib )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-text/sgmltools-lite )
	nls? ( dev-util/intltool )
"
