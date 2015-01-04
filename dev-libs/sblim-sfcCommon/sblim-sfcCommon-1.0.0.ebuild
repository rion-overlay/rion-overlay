# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils autotools-utils

DESCRIPTION="Provides a common library for functions shared between sfcb and sfcc."
HOMEPAGE="http://sblim.wiki.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/sblim/${P}.tar.bz2"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static-libs"

DEPEND=""
RDEPEND="${DEPEND}"

DOCS=(AUTHORS ChangeLog NEWS README)

src_install() {
	autotools-utils_src_install

	prune_libtool_files
}
