# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit cmake-utils eutils games

DESCRIPTION="A game similar to Super Mario Bros."
HOMEPAGE="http://super-tux.sourceforge.net"
SRC_URI="mirror://berlios/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="opengl curl debug"

RDEPEND="media-libs/libsdl[joystick]
	media-libs/sdl-image[png,jpeg]
	media-libs/libvorbis
	dev-games/physfs
	media-libs/openal
	x11-libs/libXt
	media-libs/glew
	opengl? ( virtual/opengl )
	curl? ( net-misc/curl )"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs="-DWERROR=OFF \
		-DINSTALL_SUBDIR_BIN=games/bin \
		-DINSTALL_SUBDIR_DOC=share/doc/${P} \
		$(cmake-utils_use_enable opengl OPENGL) \
		$(cmake-utils_use_enable debug SQDBG) \
		$(cmake-utils_use debug DEBUG)"

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	prepgamesdirs
}
