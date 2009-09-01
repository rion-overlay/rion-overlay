# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit subversion

DESCRIPTION="Fortune database of quotes from gentoo.ru forum and gentoo@conference.gentoo.ru"
HOMEPAGE="http://marsoft.dyndns.info/fortunes-gentoo-ru/"
SRC_URI=""

LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""
ESVN_REPO_URI="http://slepnoga.googlecode.com/svn/fortunes/"
RDEPEND="games-misc/fortune-mod"

S=${WORKDIR}
src_compile() {
	/bin/gunzip gentoo-ru-9999.gz
	mv gentoo-ru-9999 gentoo-ru
	/usr/bin/strfile gentoo-ru || die
}

src_install() {
	insinto /usr/share/fortune
	doins gentoo-ru gentoo-ru.dat || die
}
