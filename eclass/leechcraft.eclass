# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: 22.02.2010 slepnoga v1.002 $
#
# @ECLASS: leechcraft.eclass
# @MAINTAINER:
# maksbotan@gentoo.org
# 0xd34df00d@gmail.com
# @BLURB: Common functions and setup utilities for the LeechCraft app
# @DESCRIPTION:
# The leechcraft eclass contains a common set of functions and steps
# needed to build LeechCraft core or its plugins.
# Though this eclass seems to be small at the moment, it seems like a
# good idea to make all plugins inherit from it, since all plugins
# have mostly the same configuring/build process.
# Thanks for original eclass to Andrian Nord <NightNord@niifaq.ru>.
#
# Only EAPI >1 supported

case ${EAPI:-0} in
	4|3|2) ;;
	0|1) die "EAPI not supported, bug ebuild mantainer." ;;
	*) die "Unknown EAPI, bug eclass maintainers." ;;
esac

inherit cmake-utils flag-o-matic

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="git://github.com/0xd34df00d/leechcraft.git"
	EGIT_PROJECT="leechcraft"

	inherit git-2
else
	SRC_URI="mirror://sourceforge/leechcraft/leechcraft-${PV}.tar.bz2"
	S="${WORKDIR}/leechcraft-${PV}"
fi

HOMEPAGE="http://leechcraft.org/"
LICENSE="GPL-3"

EXPORT_FUNCTIONS src_configure

# @ECLASS-VARIABLE: LEECHCRAFT_PLUGIN_CATEGORY
# @DEFAULT-UNSET
# @DESCRIPTION:
# Set this to the category of the plugin, if any.
: ${LEECHCRAFT_PLUGIN_CATEGORY:=}

if [ "${LEECHCRAFT_PLUGIN_CATEGORY+x}" != "x" ]; then
	CMAKE_USE_DIR="${S}/src/plugins/${LEECHCRAFT_PLUGIN_CATEGORY}/${PN#leechcraft-}"
elif [[ ${PN} != "leechcraft-core" ]]; then
	CMAKE_USE_DIR="${S}/src/plugins/${PN#leechcraft-}"
else
	CMAKE_USE_DIR="${S}/src"
fi

# @FUNCTION: leechcraft_src_configure
# @DESCRIPTION:
# Used to configure leechcraft source.
# Selects correct build type for LeechCraft sources.

leechcraft_src_configure() {
	cmake-utils_src_configure
}

