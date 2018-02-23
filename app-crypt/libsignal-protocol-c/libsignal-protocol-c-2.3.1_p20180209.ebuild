# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Signal Protocol C Library"
HOMEPAGE="https://www.whispersystems.org"
COMMIT="c2d8084827a2eb844a6c2b48cf61df7c82082d91"
SRC_URI="https://github.com/signalapp/libsignal-protocol-c/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/openssl:0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${COMMIT}"
mycmakeargs=( -DCMAKE_C_FLAGS=-fPIC )
