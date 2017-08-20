# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="mediastreamer plugin: add H264 support"
HOMEPAGE="http://www.linphone.org/"
SRC_URI="http://www.linphone.org/releases/sources/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="unicode"

src_configure() {
	mycmakeargs=(
		-DENABLE_SHARED=ON
		-DENABLE_STATIC=OFF
		-DCONFIG_EBML_WRITING=ON
		-DCONFIG_EBML_UNICODE=$(usex unicode)
	)
	cmake-utils_src_configure
}
