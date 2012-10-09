# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit subversion gnustep-2 games

DESCRIPTION="Elite space trading & warfare remake"
HOMEPAGE="http://oolite.org/"
FF_JS_URI="http://jens.ayton.se/oolite/deps/firefox-4.0.source.js-only.tbz"
MY_P="${PN}-source-${PV}"
SRC_URI="${FF_JS_URI}"
ESVN_REPO_URI="svn://svn.berlios.de/oolite-linux/trunk"

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
		gnustep-base/gnustep-make[-libobjc2]"

S="${WORKDIR}/${MY_P}"
PATCHES=( "${FILESDIR}/${PN}-gentoo.patch" )

pkg_setup() {
	games_pkg_setup
	gnustep-base_pkg_setup
}

src_unpack() {
	unpack "${A}"
	subversion_src_unpack
}

src_prepare() {
	subversion_src_prepare
	gnustep-base_src_prepare
	mkdir "${S}"/deps/Cross-platform-deps/mozilla || die
	mv "${WORKDIR}/mozilla-2.0/js" "${S}"/deps/Cross-platform-deps/mozilla/ || die
	mv "${WORKDIR}/mozilla-2.0/nsprpub" "${S}"/deps/Cross-platform-deps/mozilla/ || die
	echo "${FF_JS_URI}" > "${S}"/deps/Cross-platform-deps/mozilla/current.url
	sed -i -e 's/^\.PHONY: all$/.PHONY: .NOTPARALLEL all/' "${S}"/libjs.make || die
	sed -i -e 's:.*STRIP.*:	true:' "${S}"/GNUmakefile.postamble
	sed -i -e '/ADDITIONAL_OBJCFLAGS *=/aADDITIONAL_OBJCFLAGS += -fobjc-exceptions' \
		"${S}"/GNUmakefile || die
	subversion_wc_info
	sed "s/SVNREVISION :=.*/SVNREVISION := ${ESVN_WC_REVISION}/" -i Makefile
}

src_compile() {
	egnustep_env
	emake -f Makefile $(use debug && echo debug || echo release) || die
}

src_install() {
	#gnustep-base_src_install
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
