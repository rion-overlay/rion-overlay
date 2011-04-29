# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit games

DESCRIPTION="Elite space trading & warfare remake"
HOMEPAGE="http://oolite.org/"
FF_JS_URI="http://jens.ayton.se/oolite/deps/firefox-4.0rc1.source.js-only.tbz"
SRC_URI="mirror://berlios/oolite-linux/${PN}-dev-source-${PV}.tar.bz2
	${FF_JS_URI}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="${IUSE} debug"

RDEPEND="virtual/opengl
		gnustep-base/gnustep-gui
		media-libs/sdl-mixer
		media-libs/sdl-image
		app-accessibility/espeak"

DEPEND="${RDEPEND}
		gnustep-base/gnustep-make"

S="${WORKDIR}/${PN}-dev-source-${PV}"
PATCHES=( "${FILESDIR}/${PN}-gentoo.patch" )

pkg_setup() {
	GNUSTEP_MAKEFILES=`gnustep-config --variable=GNUSTEP_MAKEFILES` || \
		die "Something went wrong. Can't determine location of gnustep makefiles"
	source "${GNUSTEP_MAKEFILES}/GNUstep.sh"
}

src_unpack() {
	base_src_unpack
	mkdir "${S}"/deps/Cross-platform-deps/mozilla || die
	mv "${WORKDIR}/mozilla-2.0/js" "${S}"/deps/Cross-platform-deps/mozilla/ || die
	mv "${WORKDIR}/mozilla-2.0/nsprpub" "${S}"/deps/Cross-platform-deps/mozilla/ || die
	echo "${FF_JS_URI}" > "${S}"/deps/Cross-platform-deps/mozilla/current.url
}

src_prepare() {
	base_src_prepare
	sed -i -e 's/\r//g' "${S}"/deps/Cocoa-deps/scripts/update-mozilla.sh
}

src_compile() {
	emake -f Makefile $(use debug && echo debug || echo release) || die
}

src_install() {
	insinto "${GNUSTEP_LOCAL_ROOT}/Applications"
	doins -r oolite.app || die "install failed"
	echo "openapp oolite" > "${T}/oolite"
	dogamesbin "${T}/oolite"
	prepgamesdirs "${GNUSTEP_LOCAL_ROOT}/Applications"
	fperms ug+x "${GNUSTEP_LOCAL_ROOT}/Applications/oolite.app/oolite"
	doicon installers/FreeDesktop/oolite-icon.png
	domenu installers/FreeDesktop/oolite.desktop
}
