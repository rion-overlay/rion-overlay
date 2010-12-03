# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="Collection of dicts for stardict."
HOMEPAGE="http://gnome.msiu.ru/stardict.php"
SRC_URI="ftp://ftp.msiu.ru/education/FSF-Windows/stardict/dicts/stardict-dicts.exe -> ${P}.rar"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="|| ( app-text/stardict app-text/qstardict app-dicts/goldendict )
	!app-dicts/stardict-freedict-eng-rus"

DEPEND="|| ( app-arch/unrar app-arch/rar )"

src_install() {
	insinto /usr/share/stardict/dic
	doins *
}
