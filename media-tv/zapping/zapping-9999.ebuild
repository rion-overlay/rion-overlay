# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-tv/zapping/zapping-0.10_rc6.ebuild,v 1.3 2008/09/09 13:47:08 cardoe Exp $

inherit gnome2 cvs

DESCRIPTION="TV- and VBI- viewer for the Gnome environment"
ECVS_SERVER="zapping.cvs.sourceforge.net:/cvsroot/zapping"
ECVS_MODULE="zapping"
ECVS_TOP_DIR="${DISTDIR}/cvs-src/${PN}"
SRC_URI=""

HOMEPAGE="http://zapping.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS=""
IUSE="arts esd lirc nls pam vdr zvbi X"

DEPEND=">=gnome-base/libgnomeui-2.0
	>=gnome-base/libglade-2.0
	>=gnome-base/gconf-2.0
	>=x11-libs/gtk+-2.4.0
	dev-libs/libxml2
	>=sys-devel/gettext-0.10.36
	zvbi? ( >=media-libs/zvbi-0.2.11 )
	x86? ( vdr? ( >=media-libs/rte-0.5.2 ) )
	lirc? ( app-misc/lirc )
	esd? ( >=media-sound/esound-0.2.34 )
	arts? ( kde-base/arts )
	>=app-text/scrollkeeper-0.3.5
	sys-apps/sed"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_unpack() {
	cvs_src_unpack
}

src_compile() {
	./autogen.sh --prefix=/usr `use_enable nls` \
		`use_enable pam` \
		`use_with zvbi` \
		`use_with X x` || die "econf failed"

	emake || die "emake failed"
}

src_install() {
	gnome2_src_install

	# thx to Andreas Kotowicz <koto@mynetix.de> for mailing me this fix:
	rm "${D}"/usr/bin/zapping_setup_fb
	dobin zapping_setup_fb/zapping_setup_fb
	dodoc AUTHORS BUGS ChangeLog NEWS README README.plugins THANKS TODO
}
