# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools-utils eutils

DESCRIPTION="Toolkit for CMPI indication providers"
HOMEPAGE="http://sblim.wiki.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/sblim/development%20pkgs/${PN}/${PV}/${P}.tar.bz2"

LICENSE="CPL-1.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static-libs"

DEPEND=""

RDEPEND="${DEPEND}"

PATCHES=("${FILESDIR}"/*.patch)

src_install() {
	autotools-utils_src_install
	prune_libtool_files
}
