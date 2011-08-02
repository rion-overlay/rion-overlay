# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/vanilla-dmz-xcursors/vanilla-dmz-xcursors-0.4.ebuild,v 1.10 2008/07/07 19:13:53 bluebird Exp $

MY_PN="Chameleon"
DESCRIPTION="Style neutral scalable cursor theme"
HOMEPAGE="http://www.egregorion.net/2007/03/26/chameleon/"

EAPI="3"

COLOURS="Anthracite DarkSkyBlue SkyBlue Pearl White"
SRC_URI=""
for COLOUR in ${COLOURS} ; do
	SRC_URI="${SRC_URI} http://www.egregorion.net/works/${MY_PN}-${COLOUR}-${PV}.tar.bz2"
done

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

S=${WORKDIR}/${MY_PN}

src_install() {
	rename "-${PV}" '' ${MY_PN}-*
	insinto /usr/share/cursors/xorg-x11/
	doins -r * || die "doins failed"
}

pkg_postinst() {
	elog "To use one of these sets of cursors, edit or create the file ~/.Xdefaults"
	elog "and add the following line:"
	elog "Xcursor.theme: ${MY_PN}-Pearl-Regular"
	elog "(for example)"
	elog
	elog "You can change the size by adding a line like:"
	elog "Xcursor.size: 48"
	elog
	elog "Also, to globally use this set of mouse cursors edit the file:"
	elog "    /usr/share/cursors/xorg-x11/default/index.theme"
	elog "and change the line:"
	elog "    Inherits=[current setting]"
	elog "to"
	elog "    Inherits=${MY_PN}-Pearl-Regular"
	elog
	elog "Note this will be overruled by a user's ~/.Xdefaults file."
	elog
	ewarn "If you experience flickering, try setting the following line in"
	ewarn "the Device section of your xorg.conf file:"
	ewarn "    Option  \"HWCursor\"  \"false\""
}
