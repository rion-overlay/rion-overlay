# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-power/kpowersave/kpowersave-0.7.3-r1.ebuild,v 1.1 2009/03/23 21:54:05 AntiCrust Exp $

inherit kde eutils

PATCH_LEVEL=3

DESCRIPTION="KDE front-end to powersave daemon"
HOMEPAGE="http://powersave.sf.net/"
SRC_URI="mirror://sourceforge/powersave/${P}.tar.bz2
	mirror://gentoo/kde-admindir-3.5.5.tar.bz2
	mirror://debian/pool/main/${PN:0:1}/${PN}/${P/-/_}-${PATCH_LEVEL}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND=">=sys-apps/hal-0.5.4
	dev-libs/dbus-qt3-old
	x11-libs/libXScrnSaver
	x11-libs/libXext
	x11-libs/libXtst
	>=kde-base/kdelibs-3"
DEPEND="${RDEPEND}"
IUSE="icons"
need-kde 3.5.7

src_unpack() {
	unpack ${A}
	rm -rf "${S}/admin" "${S}/configure"
	ln -s "${WORKDIR}/admin" "${S}/admin"
	epatch "${WORKDIR}/${P/-/_}-${PATCH_LEVEL}.diff"
	epatch "${S}/debian/patches/05-battery_rescan.patch"
	if use icons; then
		cd ${P}
		epatch "${FILESDIR}/${P}-icons.patch"
	fi	
}

pkg_postinst() {
	einfo "Making sure that config directory is readable"
	einfo "chmod 755 ${ROOT}/usr/share/config"
	chmod 755 "${ROOT}/usr/share/config"
	if use icons; then
	einfo "Message from author of icons patch:"
	einfo "By default it is no icons 'out of the box', but you can download example package for this patch"
	einfo "for example here: http://www.kde-look.org/content/show.php?content=95754"
	einfo "and then you should upnpack archive to the $YOUR_ICONS_TMEME_DIR/22x22/actions directory"
	fi
}
