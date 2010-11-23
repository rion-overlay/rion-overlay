# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: 22.02.2010 slepnoga v1.002 $


# Original author: 0xd34df00d <0xd34df00d@gmail.com> and
#				   Andrian Nord <NightNord@niifaq.ru>

# Commiter: A.Vinogradov aka slepnoga <slep@vinogradov.lv>


# Only EAPI >1 supported

case ${EAPI:-0} in
        4|3|2) ;;
		0|1) die "EAPI not supported, bug ebuild mantainer" ;;
		*) die "Unknown EAPI, Bug eclass maintainers." ;;
esac

# Exported functions
# Logic: for live ebuild call standart and src_unpack;
LEECHCRAFT_EXPR="src_configure src_install"

inherit cmake-utils

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="git://github.com/0xd34df00d/leechcraft.git"
	EGIT_PROJECT="leechcraft-${PV}"
	LEECHCRAFT_EXPR="${LEECHCRAFT_EXPR} src_unpack"	
	KEYWORDS=""

	inherit git
else
	SRC_URI="mirror://sourceforge/leechcraft/leechcraft-${PV}.tar.bz2"
	MY_P='leechcraft'
	S="${WORKDIR}/${MY_P}-${PV}"
	KEYWORDS="~amd64 ~x86"
fi

HOMEPAGE="http://leechcraft.org/"

DEPEND="${DEPEND}
		!www-client/leechcraft"

LICENSE="GPL-3"
SLOT="0"

CMAKE_MIN_VERSION="2.8"

EXPORT_FUNCTIONS ${LEECHCRAFT_EXPR}


# Set ${S} variable

if [[ ${PN} != "leechcraft-core" ]]; then
	CMAKE_USE_DIR="${S}/src/plugins/${PN#leechcraft-}"
else
	CMAKE_USE_DIR="${S}/src"
fi

# @FUNCTION:leechcraft_src_unpack
# @DESCRIPTION:
# Standart src_unpack live ebuild

leechcraft_src_unpack() {
	git_src_unpack

	cd "${S}"
}

# @FUNCTION: leechcraft_src_configure
# @DESCRIPTION:
# Use for configure leechcraft source.
# Build_type is magic :)

leechcraft_src_configure() {
	if use debug ; then
		CMAKE_BUILD_TYPE="RelWithDebInfo"
	else
		CMAKE_BUILD_TYPE="Release"
	fi

	cmake-utils_src_configure
}

# @FUNCTION: leechcraft_src_install
# @DESCRIPTION:
# Call cmake-utils_src_install :)

leechcraft_src_install() {
	cmake-utils_src_install
}
