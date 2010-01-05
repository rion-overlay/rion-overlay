# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit subversion games

DESCRIPTION="Elite space trading & warfare remake"
HOMEPAGE="http://oolite.org/"
rev=${PV/*_pre/}
ESVN_REPO_URI="svn://svn.berlios.de/oolite-linux/trunk@${rev}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="${IUSE}"

RDEPEND="virtual/opengl
		gnustep-base/gnustep-gui
		media-libs/sdl-mixer
		media-libs/sdl-image"

DEPEND="${RDEPEND}
		gnustep-base/gnustep-make"

S="${WORKDIR}/${PN}-dev-source-${PV}"

pkg_setup() {
	GNUSTEP_MAKEFILES=`gnustep-config --variable=GNUSTEP_MAKEFILES` || \
		die "Something went wrong. Can't determine location of gnustep makefiles"
	source "${GNUSTEP_MAKEFILES}/GNUstep.sh"
}

src_unpack() {
	default
	subversion_src_unpack
}

src_prepare() {
	default
	sed '/oolite_LIB_DIRS/d' -i GNUmakefile
	sed "s|/usr/share/GNUstep/Makefiles|${GNUSTEP_MAKEFILES}|" -i Makefile
}

src_compile() {
	cd deps/Cross-platform-deps/SpiderMonkey/js/src
	BUILD_OPT=1 make -f Makefile.ref || die "make failed"
	cd "${S}"
	make debug=no || die "make failed"
}

src_install() {
	insinto "${GNUSTEP_LOCAL_ROOT}/Applications"
	doins -r oolite.app || die "install failed"
	echo "openapp oolite" > "${T}/oolite"
	dogamesbin "${T}/oolite"
	prepgamesdirs "${GNUSTEP_LOCAL_ROOT}/Applications"
	fperms ug+x "${GNUSTEP_LOCAL_ROOT}/Applications/oolite.app/oolite"
	doicon FreeDesktop/oolite-icon.png
	domenu FreeDesktop/oolite.desktop
}
