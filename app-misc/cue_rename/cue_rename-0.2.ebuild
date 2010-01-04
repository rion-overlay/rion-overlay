# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="Rename wav files according to track names in cue"
HOMEPAGE="https://swaj.net/unix/index.html#scripts"

LICENSE="UNICNOVn"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-perl/cyrillic"
RDEPEND=""

src_install() {
	dobin "${FILESDIR}/${P}".pl
}
