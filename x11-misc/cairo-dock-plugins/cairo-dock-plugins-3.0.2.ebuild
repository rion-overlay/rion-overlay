# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit cmake-utils

DESCRIPTION="Official plugins for cairo-dock"
HOMEPAGE="https://launchpad.net/cairo-dock-plug-ins/"
SRC_URI="https://launchpad.net/cairo-dock-plug-ins/3.0/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="alsa disks doncky gmenu gnome kde network-monitor scooby webkit xfce
ical xklavier terminal python ruby mono vala"

RDEPEND="
	~x11-misc/cairo-dock-${PV}
	alsa? ( media-libs/alsa-lib )
	gmenu? ( gnome-base/gnome-menus )
	kde? ( kde-base/kdelibs )
	terminal? ( x11-libs/vte )
	webkit? ( >=net-libs/webkit-gtk-1.0 )
	xfce? ( xfce-base/thunar )
	xklavier? ( x11-libs/libxklavier )
	python? ( dev-lang/python )
	ruby? ( dev-lang/ruby )
	mono? ( dev-lang/mono )
	vala? ( dev-lang/vala )
"

DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
"

src_configure() {
	enabler() {
		local flag=$1
		local enable=$2
		[ -z "$enable" ] && enable=$flag
		use $flag && echo "-Denable-${enable}=yes" || echo "-Denable-${enable}=no"
	}

	MYCMAKEARGS="-DROOT_PREFIX=${D}
		$(enabler alsa alsa-mixer)
		$(enabler disks)
		$(enabler doncky)
		$(enabler gmenu)
		$(enabler gnome gnome-integration)
		$(enabler kde kde-integration)
		$(enabler network-monitor)
		$(enabler scooby scooby-do)
		$(enabler webkit weblets)
		$(enabler xfce)" cmake-utils_src_configure
}

