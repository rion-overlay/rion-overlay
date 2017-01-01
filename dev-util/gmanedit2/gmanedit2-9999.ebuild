# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit gnome2 mercurial

DESCRIPTION="Gnome Manual Pages Editor"
HOMEPAGE="http://gmanedit2.sourceforge.net/"
EHG_REPO_URI="http://gmanedit2.hg.sourceforge.net:8000/hgroot/gmanedit2/gmanedit2"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="x11-libs/gtksourceview:2.0"
RDEPEND="${DEPEND}"

src_prepare()
{
	epatch "$FILESDIR"/*.patch
	gnome2_src_prepare
}
