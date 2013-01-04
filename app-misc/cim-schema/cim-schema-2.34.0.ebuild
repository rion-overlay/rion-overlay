# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit versionator

MY_VER="$(replace_all_version_separators "")"

DESCRIPTION="Common Information Model (CIM) Schema"
HOMEPAGE="http://www.dmtf.org/"
SRC_URI="http://dmtf.org/sites/default/files/cim/cim_schema_v${MY_VER}/cim_schema_${PV}Experimental-MOFs.zip
doc?
( http://dmtf.org/sites/default/files/cim/cim_schema_v${MY_VER}/cim_schema_${PV}Experimental-Doc.zip )"

LICENSE="DMTF"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}"

src_install() {
	insinto /usr/share/mof
	doins -r ./*

	if use doc; then
		dohtml ./*.html
	fi
}
