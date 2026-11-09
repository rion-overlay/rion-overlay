# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="JDNS is a simple DNS implementation library"
HOMEPAGE="https://github.com/psi-im/jdns"

#EGIT_COMMIT="ae2e7264e8458d64932590bdde2417605946cb8a"
#EGIT_REPO_URI="https://github.com/psi-im/jdns.git"
SRC_URI="https://github.com/psi-im/jdns/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="tools qt6"

DEPEND="qt6? ( dev-qt/qtbase:6[network] )"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
	    $(cmake-utils_use_build qt6 QJDNS)
		$(cmake-utils_use_build tools JDNS_TOOL)
	)

	cmake_src_configure
}
