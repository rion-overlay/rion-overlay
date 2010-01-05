# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="Fortune database of quotes from gentoo.ru forum and gentoo@conference.gentoo.ru"
SRC_URI="http://slepnoga.googlecode.com/files/gentoo-ru-${PV}.gz
	http://marsoft.dyndns.info/fortunes-gentoo-ru/gentoo-ru-${PV}.gz"
HOMEPAGE="http://marsoft.dyndns.info/fortunes-gentoo-ru/"

LICENSE="as-is"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""

RESTRICT="mirror"
RDEPEND="games-misc/fortune-mod"

S=${WORKDIR}

src_compile() {
	mv gentoo-ru-${PV} gentoo-ru || die
	/usr/bin/strfile gentoo-ru || die
}

src_install() {
	insinto /usr/share/fortune
	doins gentoo-ru gentoo-ru.dat || die
}
