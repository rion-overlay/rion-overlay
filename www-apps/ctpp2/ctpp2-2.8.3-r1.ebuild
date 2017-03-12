# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Very fast template engine for WEB."
HOMEPAGE="http://ctpp.havoc.ru/ http://ctpp.havoc.ru/en/"
SRC_URI="http://ctpp.havoc.ru/download/${P}.tar.gz"

LICENSE="BSD"
SLOT="2"
KEYWORDS="~amd64"
IUSE="debug iconv md5"

DEPEND="iconv? ( virtual/libiconv )
	md5? ( dev-libs/openssl:0 )"

RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/fix_includes.patch
	"${FILESDIR}"/fix_man_location.patch
	"${FILESDIR}"/gcc4.7_getcwd.patch
)

src_configure() {
	mycmakeargs=(
		-DENABLE_OPTIMIZATION=ON
		-DSKIP_RELINK_RPATH=ON
		-DDEBUG="$(usex debug)"
		-DMD5_SUPPORT="$(usex md5)"
		-DICONV_SUPPORT="$(usex iconv)"
	)

	cmake-utils_src_configure
}
