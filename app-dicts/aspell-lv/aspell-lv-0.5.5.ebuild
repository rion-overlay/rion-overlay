# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

ASPELL_LANG="Latvian"
ASPOSTFIX="6"
inherit aspell-dict

LICENSE="GPL-2"
KEYWORDS="~amd64"
IUSE=""

FILENAME="aspell6-lv-0.5.5-1"

SRC_URI="mirror://gnu/aspell/dict/lv/${FILENAME}.tar.bz2"
S="${WORKDIR}/${FILENAME}"
