# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Implementation of ZRTP keys exchange protocol"
HOMEPAGE="http://www.linphone.org"
SRC_URI="http://www.linphone.org/releases/sources/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=net-libs/bctoolbox-0.6.0
	dev-libs/libxml2:2
	dev-db/sqlite:3"
RDEPEND="${DEPEND}"
