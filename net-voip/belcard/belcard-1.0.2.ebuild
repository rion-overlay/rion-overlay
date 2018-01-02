# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="C++ library to manipulate VCard standard format"
HOMEPAGE="https://savannah.nongnu.org/projects/linphone/"
SRC_URI="http://www.linphone.org/releases/sources/${PN}/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-3"
IUSE=""

DEPEND="net-libs/bctoolbox
	>=dev-libs/belr-0.1.3"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}-0"
