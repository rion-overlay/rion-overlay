# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

RPM_REV="-1"
inherit pki-dogtag

DESCRIPTION="User interface Dog Tag for Registration Authority"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	insinto /usr/share/pki/ra-ui/docroot/
	doins -r "${S}"/shared/docroot/* || die
}
