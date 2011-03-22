# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit games

DESCRIPTION="a opensource cross platform jump and run game"
HOMEPAGE="http://www.frogatto.com"
SRC_URI="http://www.frogatto.com/files/${P}.tar.bz2"

LICENSE="GPL-3 free-noncomm"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-util/ccache
	media-libs/glew
	media-libs/sdl-ttf
	media-libs/sdl-mixer
	media-libs/sdl-image
	media-libs/libsdl[joystick]"
RDEPEND="${DEPEND}"

src_compile() {
	emake game server || die
}

src_install() {
	exeinto ${GAMES_PREFIX_OPT}/${PN}/
	doexe game || die
	doexe server || die
	games_make_wrapper ${PN} ./game ${GAMES_PREFIX_OPT}/${PN}/ || die
	insinto ${GAMES_PREFIX_OPT}/${PN}/
	doins -r data || die
	doins -r images || die
	doins -r music || die
	doins -r sounds || die
}
