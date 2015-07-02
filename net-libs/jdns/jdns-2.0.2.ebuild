# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils multibuild

DESCRIPTION="JDNS is a simple DNS implementation library"
HOMEPAGE="https://github.com/psi-im/jdns"
SRC_URI="https://github.com/psi-im/jdns/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="qt4 qt5 tools"

DEPEND="
	qt4? ( dev-qt/qtcore:4 )
	qt5? ( dev-qt/qtnetwork:5 )
"
RDEPEND="${DEPEND}"

pkg_setup() {
	MULTIBUILD_VARIANTS=( $(usev qt4) $(usev qt5) )
}

src_configure() {
	myconfigure() {
		local mycmakeargs=( -DBUILD_QJDNS=ON
			$(cmake-utils_use_build tools JDNS_TOOL) )

		[[ ${MULTIBUILD_VARIANT} == qt4 ]] && mycmakeargs+=( -DQT4_BUILD=ON )
		#[[ ${MULTIBUILD_VARIANT} == qt5 ]] && {
		#	sed -i -e 's,qjdns.pc$,qjdns5.pc,' \
		#		CMakeLists.txt
		#}

		cmake-utils_src_configure
	}
	multibuild_foreach_variant myconfigure
	
	if [[ -z "${MULTIBUILD_VARIANTS[@]}" ]]; then
		local mycmakeargs=( -DBUILD_QJDNS=OFF
			$(cmake-utils_use_build tools JDNS_TOOL) )
		cmake-utils_src_configure
	fi
}

src_compile() {
	multibuild_foreach_variant cmake-utils_src_compile

	if [[ -z "${MULTIBUILD_VARIANTS[@]}" ]]; then
		cmake-utils_src_compile
	fi
}

src_install() {
	multibuild_foreach_variant cmake-utils_src_install

	if [[ -z "${MULTIBUILD_VARIANTS[@]}" ]]; then
		cmake-utils_src_install
	fi
}
