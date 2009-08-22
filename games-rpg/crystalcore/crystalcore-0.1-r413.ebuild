# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-rpg/crystalcore/crystalcore-0.1-r413.ebuild,v 1.3 2007/07/20 12:00:00 loux.thefuture Exp $

inherit eutils games

DESCRIPTION="Crystal Core Demo game"
HOMEPAGE="http://www.crystalspace3d.org/"
SRC_URI="http://dev.gentooexperimental.org/~loux/distfiles/${PF}.tar.bz2"

LICENSE="|| ( GPL-2 GPL )"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="server static debug maxoptimization debug"

RDEPEND="net-misc/curl
	>=media-libs/cal3d-0.11
	>=dev-games/crystalspace-ps-1.1-r26888
	>=dev-games/cel-ps-1.1-r2766"

S=${WORKDIR}/cc

CS_PREFIX=/opt/planeshift/crystalspace
CEL_PREFIX=/opt/planeshift/cel
CC_PREFIX=/opt/planeshift/crystalcore

src_install() {
	dodir ${CC_PREFIX}
	cp *sh *cfg ${D}/${CC_PREFIX}/.
	sed -e "s!\$CEL.*celstart!${CEL_PREFIX}/bin/celstart!g" -i start_crystalcore.sh
	chmod +x ${D}/${CC_PREFIX}/*sh
	cp -R art ${D}/${CC_PREFIX}/.
	cp -R data ${D}/${CC_PREFIX}/.
	prepgamesdirs ${CC_PREFIX}
}
