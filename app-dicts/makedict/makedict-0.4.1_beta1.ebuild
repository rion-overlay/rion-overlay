# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit cmake-utils

DESCRIPTION="Dictionary converter"
HOMEPAGE="http://sourceforge.net/projects/xdxf/"

MY_PV=${PV/_/-}
SRC_URI="mirror://sourceforge/xdxf/${PN}-${MY_PV}-Source.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-libs/glib-2.6.0
		sys-libs/zlib
		dev-libs/expat"
RDEPEND="${DEPEND}
		dev-lang/python"

S="${WORKDIR}/${PN}-${MY_PV}-Source"
