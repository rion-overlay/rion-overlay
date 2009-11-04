# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

RPM_REV="-1"

inherit pki-dogtag
DESCRIPTION="PKI Common Framework User Interface"

KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	insinto  /usr/share/pki/common-ui/admin/console/
	doins -r "${S}"/shared/admin/console/*
}
