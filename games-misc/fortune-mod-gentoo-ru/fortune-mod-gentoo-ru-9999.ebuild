# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit mercurial

DESCRIPTION="Fortune database of quotes from gentoo.ru forum and gentoo@conference.gentoo.ru"
HOMEPAGE="http://marsoft.dyndns.info/fortunes-gentoo-ru/"
SRC_URI=""

LICENSE="as-is"
SLOT="0"
IUSE=""
EHG_REPO_URI="https://gentoo-ru-fortunes.slepnoga.googlecode.com/hg"
RDEPEND="games-misc/fortune-mod"

S="${WORKDIR}"

src_compile() {

	mv hg/gentoo-ru-9999 gentoo-ru
	/usr/bin/strfile gentoo-ru || die
}

src_install() {
	insinto /usr/share/fortune
	doins gentoo-ru gentoo-ru.dat || die
}
