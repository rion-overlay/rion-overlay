# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

MY_PV="${PV/_beta/B}"
DESCRIPTION="iod Suite theme for gnome and emerald"
HOMEPAGE="http://scnd101.deviantart.com/art/iod-Suite-1-0-BETA-104263022"
SRC_URI="http://fc01.deviantart.com/fs39/f/2008/327/3/c/iod_Suite_1_0_BETA_by_Scnd101.gz -> iod-${MY_PV}.tar.gz"
S="${WORKDIR}/iod-${MY_PV}"

LICENSE="deviantART"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="emerald gdm gtk"

DEPEND=""
RDEPEND="gtk? ( >=x11-themes/gtk-engines-murrine-0.54 )
	emerald? ( x11-wm/emerald )
	gdm? ( <gnome-base/gdm-2.26 )
	media-fonts/ttf-bitstream-vera"

src_install()
{
	#intalling emerald theme
	if use emerald; then
		mkdir -p "${D}"/usr/share/emerald/themes/iod
		tar xzpf 'emerald/iod 1.0.emerald' -C "${D}"/usr/share/emerald/themes/iod
	fi

	#installing gdm theme
	if use gdm; then
		mkdir -p "${D}"/usr/share/gdm/themes
		tar xzpf 'gdm/iodgdm.tar.gz' -C "${D}"/usr/share/gdm/themes/
	fi

	#installing gtk theme
	if use gtk; then
		mkdir -p "${D}"/usr/share/themes
		tar  xzpf 'gtk/iod.tar.gz' -C "${D}"/usr/share/themes/
	fi

	insinto /usr/share/pixmaps/"${PN}"
	doins -r panel-background*

	elog "Panel backgrounds installed to /usr/share/pixmaps/${PN}"
}
