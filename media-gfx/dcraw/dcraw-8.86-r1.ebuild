# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/dcraw/dcraw-8.86.ebuild,v 1.1 2008/05/26 12:25:32 wschlich Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Converts the native (RAW) format of various digital cameras into netpbm portable pixmap (.ppm) image"
HOMEPAGE="http://www.cybercom.net/~dcoffin/dcraw/"
SRC_URI="http://dev.gentoo.org/~wschlich/src/media-gfx/dcraw/${P}.tar.bz2"
LICENSE="freedist GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="gimp jpeg lcms"

DEPEND="virtual/libc
	jpeg? ( >=media-libs/jpeg-6b )
	lcms? ( media-libs/lcms )
	gimp? ( media-gfx/gimp )"

RDEPEND="${DEPEND}
	media-libs/netpbm"

src_compile() {
	local mymakeopts
	use lcms || mymakeopts="${mymakeopts} NO_LCMS=yes"
	use jpeg || mymakeopts="${mymakeopts} NO_JPEG=yes"
	emake CC=$(tc-getCC) ${mymakeopts} || die "make failed"

	# rawphoto gimp plugin
	if use gimp; then
		# find gimptool
		local gimptool=$(which gimptool 2>/dev/null || which gimptool-2.0 2>/dev/null)
		if [ ! -x ${gimptool} ]; then
			die "Couldn't find gimptool. Please reinstall gimp."
		fi
		${gimptool} --build rawphoto.c || die "gimptool failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc doc/conversion-examples.txt doc/dcwrap

	# rawphoto gimp plugin
	if use gimp; then
		# find gimptool
		local gimptool=$(which gimptool 2>/dev/null || which gimptool-2.0 2>/dev/null)
		if [ ! -x ${gimptool} ]; then
			die "Couldn't find gimptool. Please reinstall gimp."
		fi
		exeinto $(${gimptool} --gimpplugindir)/plug-ins
		doexe rawphoto
	fi
}

pkg_postinst() {
	elog ""
	elog "See conversion-examples.txt.gz on how to convert"
	elog "the PPM files produced by dcraw to other image formats."
	elog ""
	ewarn "The functionality of the external program 'fujiturn' was"
	ewarn "incoporated into dcraw and is automatically used now."
	elog ""
	elog "There's an example wrapper script included called 'dcwrap'."
	elog ""
	elog "This package also includes 'dcparse', which extracts"
	elog "thumbnail images (preferably JPEGs) from any raw digital"
	elog "camera formats that have them, and shows table contents."
	elog ""
}
