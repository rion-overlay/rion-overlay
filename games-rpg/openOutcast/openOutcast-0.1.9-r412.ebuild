# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-rpg/openOutcast/openOutcast-0.1.9-r407.ebuild,v 1.3 2007/06/27 12:00:00 loux.thefuture Exp $

inherit eutils games

DESCRIPTION="Virtual fantasy world MMORPG"
HOMEPAGE="http://www.openoutcast.org/"
SRC_URI="http://dev.gentooexperimental.org/~loux/distfiles/${PF}.tar.bz2"

LICENSE="|| ( GPL-2 OpenOutcast )"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="maxoptimization debug"

RDEPEND="net-misc/curl
	>=media-libs/cal3d-0.11
	>=dev-games/crystalspace-ps-1.1-r26888
	>=dev-games/cel-ps-1.1-r2766"

S=${WORKDIR}/ooc

CS_PREFIX=/opt/planeshift/crystalspace
CEL_PREFIX=/opt/planeshift/cel
O_PREFIX=/opt/planeshift/ooc

src_compile() {
	cd system
	export CRYSTAL=${CS_PREFIX}
	export CEL=${CEL_PREFIX}
	econf --prefix=${O_PREFIX} \
		--with-cs-prefix=${CS_PREFIX} \
		--with-cel-prefix=${CEL_PREFIX} \
		$(use_enable debug) \
		--without-python \
		|| die "Error : econf failed"
	jam -aq ${MAKEOPTS} || die "failed to compile"
}

src_install() {
	cd system
	dodir ${O_PREFIX}
	dodir ${O_PREFIX}/system
	cp ooc vfs.cfg *so "${D}/${O_PREFIX}"/system/.
	cp -R config "${D}/${O_PREFIX}"/system/.
	cp -R scripts "${D}/${O_PREFIX}"/system/.
	cd ..
	cp -R data "${D}/${O_PREFIX}"/.
	prepgamesdirs ${O_PREFIX}
}
