# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit qt4-r2 git-2

DESCRIPTION="Adds tabs to Skype"
HOMEPAGE="https://github.com/kekekeks/skypetab-ng"
EGIT_REPO_URI="git://github.com/kekekeks/skypetab-ng.git"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	!amd64? ( x11-libs/qt-core
		x11-libs/qt-gui )
	amd64? ( app-emulation/emul-linux-x86-qtlibs )"
RDEPEND="${DEPEND}
	net-im/skype"

src_prepare()
{
	use amd64 && { sed -i -e "s:/usr/lib:/usr/lib32:" \
	        skypetab-ng.pro || die; }

	sed -i -e "s:/usr:${EPREFIX}/usr:" \
		skypetab-ng.pro || die

	use amd64 && multilib_toolchain_setup x86
	qt4-r2_src_prepare
}

