# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="jQuery is a fast and concise JavaScript Library"
HOMEPAGE="http://jquery.com/"
SRC_URI="http://code.jquery.com/${P}.min.js"

LICENSE="MIT GPL-2"
SLOT="1.5"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}"

src_unpack() {
	cp "${DISTDIR}"/${A}  "${WORKDIR}" || die  "unpack failed"
}

src_install() {
	ln -s ${A} "${PN}-${SLOT}.min.js"
	insinto /usr/share/"${PN}-${SLOT}"
	doins ./*
}
