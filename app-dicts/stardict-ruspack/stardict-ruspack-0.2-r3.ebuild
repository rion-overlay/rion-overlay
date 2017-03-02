# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="Collection of dicts for stardict."
HOMEPAGE="http://web.archive.org/web/20131111152446/http://gnome.msiu.ru/stardict.php"
SRC_URI="http://tkn.me/gentoo/distfiles/stardict-ruspack-0.2.rar"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="!app-dicts/stardict-freedict-eng-rus"

DEPEND="|| ( app-arch/unrar app-arch/rar )"

S="${WORKDIR}"

src_install() {
	insinto /usr/share/stardict/dic
	doins *
}
