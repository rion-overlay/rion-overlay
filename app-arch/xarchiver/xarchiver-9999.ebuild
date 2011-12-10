# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit xfconf git-2

DESCRIPTION="a GTK+ based and advanced archive manager that can be used with Thunar"
HOMEPAGE="http://xarchiver.sourceforge.net/"
EGIT_REPO_URI="git://github.com/Ri0n/xarchiver.git"
EGIT_BOOTSTRAP="./autogen.sh --prefix=${EPREFIX}/usr"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug"

RDEPEND=">=x11-libs/gtk+-2.10:2
	>=dev-libs/glib-2.10:2"
DEPEND="${RDEPEND}
	dev-util/intltool
	dev-util/pkgconfig"

pkg_setup() {
	XFCONF=( $(xfconf_use_debug) )
	DOCS=( ChangeLog README TODO )
}

src_prepare() {
	sed -i -e '/COPYING/d' doc/Makefile.in || die
	xfconf_src_prepare
}

src_install() {
	xfconf_src_install DOCDIR="${ED}/usr/share/doc/${PF}"
}

pkg_postinst() {
	xfconf_pkg_postinst
	elog "You need external programs for some formats, including"
	elog "7zip - app-arch/p7zip"
	elog "arj - app-arch/unarj app-arch/arj"
	elog "lha - app-arch/lha"
	elog "lzop - app-arch/lzop"
	elog "rar - app-arch/unrar app-arch/rar"
	elog "zip - app-arch/unzip app-arch/zip"
}
