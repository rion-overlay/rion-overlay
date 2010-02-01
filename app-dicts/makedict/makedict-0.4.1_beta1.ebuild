# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="Dictionary converter"
HOMEPAGE="http://sourceforge.net/projects/xdxf/"

MY_PV=${PV/_/-}
SRC_URI="mirror://sourceforge/xdxf/${PN}-${MY_PV}-Source.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND=""

src_install()
{
	emake install || die "install failed"
}
