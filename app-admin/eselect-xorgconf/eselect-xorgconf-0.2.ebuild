# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="An eselect module to manage /etc/X11/xorg.conf symlink."
HOMEPAGE="http://code.google.com/p/krigstasks-samling/wiki/EselectXorgConf"
SRC_URI="http://krigstasks-samling.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	app-admin/eselect
	>=x11-base/xorg-server-1.8.0
	!<x11-base/xorg-server-1.8.0
	!!=app-admin/eselect-xorgconf-0.1*"

src_install() {
	insinto /usr/share/eselect/modules
	doins xorg.conf.eselect || die
}

pkg_postinst() {
	elog "Don't forget to rename your xorg.conf to something like"
	elog "xorg.conf.<your card name> prior to eselecting it"
}
