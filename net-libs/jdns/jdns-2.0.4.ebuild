# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils multibuild

DESCRIPTION="JDNS is a simple DNS implementation library"
HOMEPAGE="https://github.com/psi-im/jdns"

#EGIT_COMMIT="ae2e7264e8458d64932590bdde2417605946cb8a"
#EGIT_REPO_URI="https://github.com/psi-im/jdns.git"
SRC_URI="https://github.com/psi-im/jdns/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="qt4 qt5 tools"
REQUIRED_EUSE="tools? || ( qt4 qt5 )"

DEPEND="
	qt4? ( dev-qt/qtcore:4 )
	qt5? ( dev-qt/qtnetwork:5 )
"
RDEPEND="${DEPEND}"

pkg_setup() {
	MULTIBUILD_VARIANTS=( $(usev qt4) $(usev qt5) )
}

src_configure() {
	if [[ -z "${MULTIBUILD_VARIANTS[@]}" ]]; then
		local mycmakeargs=(
			-DBUILD_QJDNS=OFF
			-DBUILD_JDNS_TOOL=OFF
		)
		cmake-utils_src_configure
	else
		myconfigure() {
			local mycmakeargs=( -DBUILD_QJDNS=ON
				$(cmake-utils_use_build tools JDNS_TOOL) )

			[[ ${MULTIBUILD_VARIANT} == qt4 ]] && mycmakeargs+=( -DQT4_BUILD=ON )

			cmake-utils_src_configure
		}
		multibuild_foreach_variant myconfigure
	fi
}

src_compile() {
	if [[ -z "${MULTIBUILD_VARIANTS[@]}" ]]; then
		cmake-utils_src_compile
	else
		multibuild_foreach_variant cmake-utils_src_compile
	fi
}

src_install() {
	if [[ -z "${MULTIBUILD_VARIANTS[@]}" ]]; then
		cmake-utils_src_install
	else
		multibuild_foreach_variant cmake-utils_src_install
	fi
}
