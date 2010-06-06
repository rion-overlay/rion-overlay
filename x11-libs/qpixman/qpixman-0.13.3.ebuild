# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

# based on pixman-0.16.4.ebuild,v 1.1 2010/01/22 09:24:07 scarabeus

EAPI=2

WANT_AUTOMAKE="1.10"

inherit x-modular toolchain-funcs versionator autotools

SRC_URI="http://www.spice-space.org/download/qpixman-0.13.3-git20090127.tar.bz2"
DESCRIPTION="Low-level pixel manipulation routines"

KEYWORDS="~amd64 ~x86"
IUSE=" mmx sse2"

S="${WORKDIR}/${P}-git20090127"

src_prepare(){
	eautoreconf
}

pkg_setup() {
	CONFIGURE_OPTIONS="--disable-gtk"

	local enable_mmx="$(use mmx && echo 1 || echo 0)"
	local enable_sse2="$(use sse2 && echo 1 || echo 0)"

	# this block fixes bug #260287
	if use x86; then
		if use sse2 && ! $(version_is_at_least "4.2" "$(gcc-version)"); then
			ewarn "SSE2 instructions require GCC 4.2 or higher."
			ewarn "pixman will be built *without* SSE2 support"
			enable_sse2="0"
		fi
	fi

	# this block fixes bug #236558
	case "$enable_mmx,$enable_sse2" in
	'1,1')
		CONFIGURE_OPTIONS="${CONFIGURE_OPTIONS} --enable-mmx --enable-sse2" ;;
	'1,0')
		CONFIGURE_OPTIONS="${CONFIGURE_OPTIONS} --enable-mmx --disable-sse2" ;;
	'0,1')
		ewarn "You enabled SSE2 but have MMX disabled. This is an invalid."
		ewarn "pixman will be built *without* MMX/SSE2 support."
		CONFIGURE_OPTIONS="${CONFIGURE_OPTIONS} --disable-mmx --disable-sse2" ;;
	'0,0')
		CONFIGURE_OPTIONS="${CONFIGURE_OPTIONS} --disable-mmx --disable-sse2" ;;
	esac
}
