# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnustep-2

DESCRIPTION="Elite space trading & warfare remake"
HOMEPAGE="http://oolite.org/"
FF_JS_URI="http://jens.ayton.se/oolite/deps/firefox-4.0.source.js-only.tbz"
BINRES_REV=f5aed27fefc32c24775b39fce25402b970b09b84
SRC_URI="https://github.com/OoliteProject/oolite/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/OoliteProject/oolite-binary-resources/archive/${BINRES_REV}.zip -> oolite-binary-resources-${PV}.zip
	${FF_JS_URI}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="${IUSE} debug"

RDEPEND="virtual/opengl
		gnustep-base/gnustep-gui
		media-libs/sdl-mixer
		media-libs/sdl-image
		app-accessibility/espeak
		media-libs/libvorbis
		dev-libs/nspr
		media-libs/libpng:0
		media-libs/openal
		sys-libs/zlib[minizip]"

DEPEND="${RDEPEND}
		gnustep-base/gnustep-make[-libobjc2]"

PATCHES=( "${FILESDIR}/${PN}-gentoo.patch" )

src_prepare() {
	gnustep-base_src_prepare
	mv "${WORKDIR}/mozilla-2.0/js" "${S}"/deps/mozilla/ || die
	mv "${WORKDIR}/mozilla-2.0/nsprpub" "${S}"/deps/mozilla/ || die
	mv "${WORKDIR}/oolite-binary-resources-${BINRES_REV}"/* "${S}"/Resources/Binary/
	echo "${FF_JS_URI}" > "${S}"/deps/mozilla/current.url
	sed -i -e 's/^\.PHONY: all$/.PHONY: .NOTPARALLEL all/' "${S}"/libjs.make || die
	sed -i -e 's:.*STRIP.*:	true:' \
		-e '/ADDITIONAL_OBJCFLAGS *=/aADDITIONAL_OBJCFLAGS += -fobjc-exceptions' \
		-e '/ADDITIONAL_OBJC_LIBS *=/aADDITIONAL_OBJC_LIBS += -lminizip' \
		-e 's|:src/Core/MiniZip||g' \
		-e 's|-Isrc/Core/MiniZip|-I/usr/include/minizip|' \
		"${S}"/GNUmakefile || die
	sed "/void png_error/d" -i src/Core/Materials/OOPNGTextureLoader.m
}

src_compile() {
	egnustep_env
	# explicit Makefile because there are many and Makefile is choosen by default
	emake -f Makefile $(use debug && echo debug || echo release)
}

src_install() {
	#gnustep-base_src_install
	egnustep_env
	install_root="$(gnustep-config --variable=GNUSTEP_LOCAL_APPS)"
	insinto "${install_root}"
	doins -r oolite.app

	echo "openapp oolite" > "${T}/oolite"
	dobin "${T}/oolite"
	fperms a+rx "${install_root}/oolite.app/oolite"
	doicon installers/FreeDesktop/oolite-icon.png
	domenu installers/FreeDesktop/oolite.desktop
}
