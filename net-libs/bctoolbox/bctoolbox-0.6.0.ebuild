# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Utilities library used by Belledonne Communications softwares"
HOMEPAGE="https://savannah.nongnu.org/projects/linphone/"
SRC_URI="http://www.linphone.org/releases/sources/${PN}/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=">=dev-util/bcunit-3.0.2
	net-libs/mbedtls"
RDEPEND="${DEPEND}"
