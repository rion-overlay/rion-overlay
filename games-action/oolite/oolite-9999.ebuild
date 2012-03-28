# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit games subversion

DESCRIPTION="Elite space trading & warfare remake"
HOMEPAGE="http://oolite.org/"
ESVN_REPO_URI="svn://svn.berlios.de/oolite-linux/trunk"
SRC_URI="http://jens.ayton.se/oolite/deps/firefox-4.0.source.js-only.tbz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="${IUSE} debug"

RDEPEND="virtual/opengl
		gnustep-base/gnustep-gui
		media-libs/sdl-mixer
		media-libs/sdl-image
		app-accessibility/espeak"

DEPEND="${RDEPEND}
		gnustep-base/gnustep-make"

S="${WORKDIR}/${PN}-dev-source-${PV}"
ESVN_PATCHES="${PN}-gentoo.patch ${PN}-clang.patch"

pkg_setup() {
	GNUSTEP_MAKEFILES=`gnustep-config --variable=GNUSTEP_MAKEFILES` || \
		die "Something went wrong. Can't determine location of gnustep makefiles"
	source "${GNUSTEP_MAKEFILES}/GNUstep.sh"
}

src_unpack() {
	base_src_unpack
	subversion_src_unpack
	mkdir "${S}"/deps/Cross-platform-deps/mozilla || die
	mv "${WORKDIR}/mozilla-2.0/js" "${S}"/deps/Cross-platform-deps/mozilla/ || die
	mv "${WORKDIR}/mozilla-2.0/nsprpub" "${S}"/deps/Cross-platform-deps/mozilla/ || die
	echo "${SRC_URI}" > "${S}"/deps/Cross-platform-deps/mozilla/current.url
}

src_prepare() {
	subversion_src_prepare
	subversion_wc_info
	sed "s/SVNREVISION :=.*/SVNREVISION := ${ESVN_WC_REVISION}/" -i Makefile
}

src_compile() {
	emake -f Makefile $(use debug && echo debug || echo release) || die
}

src_install() {
	install_root="$(gnustep-config --variable=GNUSTEP_LOCAL_APPS)"
	insinto "${install_root}"
	doins -r oolite.app || die "install failed"

	echo "openapp oolite" > "${T}/oolite"
	dogamesbin "${T}/oolite"
	prepgamesdirs "${install_root}"
	fperms ug+x "${install_root}/oolite.app/oolite"
	doicon installers/FreeDesktop/oolite-icon.png
	domenu installers/FreeDesktop/oolite.desktop
}
