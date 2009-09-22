# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools


DESCRIPTION="GTK based GUI for xneur"
HOMEPAGE="http://www.xneur.ru/"
if [[ "${PV}" = 9999 ]] ; then
	inherit subversion
	SRC_URI=""
	ESVN_REPO_URI="svn://xneur.ru:3690/xneur/${PN}"
else
	SRC_URI="http://dists.xneur.ru/release-${PV}/tgz/${P}.tar.bz2"
fi
LICENSE="GPL-2"

IUSE="nls kde"
SLOT="0"

KEYWORDS="~x86 ~amd64"

RDEPEND=">=x11-apps/xneur-0.9.0
	 >=x11-libs/gtk+-2.0.0
	 >=sys-devel/gettext-0.16.1
	 >=gnome-base/libglade-2.6.0
	 !x11-apps/kxneur"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.20"

src_unpack() {
	if [[ ${SRC_URI} == "" ]] ; then
		subversion_src_unpack
		cd "${S}"

		# -Werror should not occure in resulting build.
		sed -i "s/\(CFLAGS.*\)-Werror\(.*\)/\1\2/" configure.in
		eautoreconf
	else
		unpack ${A}
		cd "${S}"

		eautoreconf
	fi
##if use kde; then
##svn co svn://xneur.ru:3690/xneur/icons
##fi
}

src_compile() {
	XNEUR_CFLAGS="${CFLAGS}" econf $(use_enable nls) || die "configure failed"
	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS
	make_desktop_entry "${PN}" "${PN}" ${PN} "GTK;Gnome;Utility;TrayIcon"
}
