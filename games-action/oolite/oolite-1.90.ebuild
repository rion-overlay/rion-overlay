# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnustep-2 desktop

DESCRIPTION="Elite space trading & warfare remake"
HOMEPAGE="http://oolite.space/"
BINRES_REV=1fe395fe185611b2de54b027cda6c29f15a9f3a0
OOLITE_REV=1.90
SDLDEL_REV=dd17796b2ee1257bea04aeffaec660f6c75eadf2
SM_REV=c463e95ea5d1d780301e7f3792783771381125f0
SRC_URI="https://github.com/OoliteProject/oolite/archive/${OOLITE_REV}.tar.gz -> ${P}.tar.gz
	https://github.com/OoliteProject/oolite-binary-resources/archive/${BINRES_REV}.tar.gz -> oolite-binary-resources-${PV}.tar.gz
	https://github.com/OoliteProject/oolite-sdl-dependencies/archive/${SDLDEL_REV}.tar.gz -> oolite-sdl-dependencies-${PV}.tar.gz
	https://github.com/OoliteProject/spidermonkey-ff4/archive/${SM_REV}.tar.gz -> oolite-spidermonkey-${PV}.tar.gz
"
S="${WORKDIR}/${PN}-${OOLITE_REV}"
SPIDERMONKEY_SRC="${WORKDIR}/spidermonkey-ff4-${SM_REV}/js/src"
OOLITE_VER_GITREV=6897 # git rev-list --count HEAD # depends on OOLITE_REV

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="${IUSE} debug"

RDEPEND="virtual/opengl
		gnustep-base/gnustep-gui
		media-libs/sdl-mixer
		media-libs/sdl-image
		app-accessibility/espeak-ng
		media-libs/libvorbis
		dev-libs/nspr
		media-libs/libpng:0
		media-libs/openal
		sys-libs/zlib[minizip]"

DEPEND="${RDEPEND}
		gnustep-base/gnustep-make[-libobjc2]"

PATCHES=( "${FILESDIR}/${P}-gentoo.patch" )

src_prepare() {
	gnustep-base_src_prepare
	mv "${WORKDIR}/oolite-binary-resources-${BINRES_REV}"/* "${S}"/Resources/Binary/
	mv "${WORKDIR}/oolite-sdl-dependencies-${SDLDEL_REV}"/* "${S}"/deps/Cross-platform-deps/
	sed -i -e 's:.*STRIP.*:	true:' \
		-e "/ADDITIONAL_OBJCFLAGS *=/aADDITIONAL_OBJCFLAGS += -fobjc-exceptions" \
		-e '/ADDITIONAL_OBJC_LIBS *=/aADDITIONAL_OBJC_LIBS += -lminizip' \
		-e 's|:src/Core/MiniZip||g' \
		-e 's|-Isrc/Core/MiniZip|-I/usr/include/minizip|' \
		-e 's|lespeak|lespeak-ng|' \
		"${S}"/GNUmakefile || die
	sed "/void png_error/d" -i src/Core/Materials/OOPNGTextureLoader.m
	rm -rf src/Core/MiniZip/
	eapply -d $SPIDERMONKEY_SRC -- "${FILESDIR}/${PN}-recent-compiler-compat.patch"
}

src_compile() {
	egnustep_env
	local LIBJS_DIR="${SPIDERMONKEY_SRC}/build"
	emake -f libjs.make \
		debug=$(usex debug yes no) \
		LIBJS_BUILD_DIR="${LIBJS_DIR}"
	# explicit Makefile because there are many and "Makefile" is not choosen by default
	emake -f Makefile \
		$(use debug && echo debug || echo release) \
		DEPS= \
		VER_GITHASH=${OOLITE_REV:0:7} \
		VER_GITREV=${OOLITE_VER_GITREV} \
		LIBJS_DIR="${LIBJS_DIR}" \
		LIBJS_INC_DIR="${LIBJS_DIR}/dist/include"
}

src_install() {
	#gnustep-base_src_install
	egnustep_env
	install_root="$(gnustep-config --variable=GNUSTEP_SYSTEM_APPS)"
	insinto "${install_root}"
	doins -r oolite.app

	echo '#!/bin/sh' > "${T}/oolite"
	echo "exec openapp oolite" >> "${T}/oolite"
	dobin "${T}/oolite"
	fperms a+rx "${install_root}/oolite.app/oolite"
	doicon installers/FreeDesktop/oolite-icon.png
	domenu installers/FreeDesktop/oolite.desktop
}
