# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="Utilities library used by Belledonne Communications softwares"
HOMEPAGE="https://gitlab.linphone.org/BC/public/bctoolbox"
SRC_URI="https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/${PV}/${P}.tar.bz2"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=">=dev-util/bcunit-4.3
	net-libs/mbedtls"
RDEPEND="${DEPEND}"
