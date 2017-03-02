# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_6,2_7} )
inherit cmake-utils python-single-r1

DESCRIPTION="Dictionary converter"
HOMEPAGE="http://sourceforge.net/projects/xdxf/"

REV=a26b847fa785ccb87a0b67940c824e29da97c2fd
SRC_URI="https://github.com/soshial/xdxf_makedict/archive/${REV}.zip -> ${P}-${PR}.zip"
S="${WORKDIR}/xdxf_makedict-${REV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-libs/glib-2.6.0
	sys-libs/zlib
	dev-libs/expat"
RDEPEND="${DEPEND}
	dev-lang/python"
