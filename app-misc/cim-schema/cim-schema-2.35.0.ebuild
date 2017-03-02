# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit versionator

MY_VER="$(replace_all_version_separators "")"

DESCRIPTION="Common Information Model (CIM) Schema"
HOMEPAGE="http://www.dmtf.org/"
SRC_URI="http://dmtf.org/sites/default/files/cim/cim_schema_v${MY_VER}/cim_schema_${PV}Experimental-MOFs.zip
doc?
( http://dmtf.org/sites/default/files/cim/cim_schema_v${MY_VER}/cim_schema_${PV}Experimental-Doc.zip )"

LICENSE="DMTF"
SLOT="${PV}"
KEYWORDS="~amd64"
IUSE="doc"

DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}"

src_prepare() {

	for i in `find . -name "*.mof"`; do
		sed -i -e 's/\r//g' $i
	done
}

src_install() {

	insinto /usr/share/mof/cim-"${PV}"/
	doins -r ./*

	dosym cim-"${PV}" /usr/share/mof/cim-current
	dosym cim_schema_"${PV}".mof  /usr/share/mof/cim-current/CIM_Schema.mof

	if use doc; then
		dohtml ./*.html
	fi
}
