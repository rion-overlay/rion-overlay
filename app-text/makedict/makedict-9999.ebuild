# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_6,2_7} )
inherit cmake-utils python-single-r1 git-r3

DESCRIPTION="Dictionary converter"
HOMEPAGE="http://sourceforge.net/projects/xdxf/"

EGIT_REPO_URI="https://github.com/soshial/xdxf_makedict"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=dev-libs/glib-2.6.0
	sys-libs/zlib
	dev-libs/expat"
RDEPEND="${DEPEND}
	dev-lang/python"
