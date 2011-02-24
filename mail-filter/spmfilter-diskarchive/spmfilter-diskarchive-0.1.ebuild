# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit cmake-utils multilib

DESCRIPTION="plugin for spmfilter that enables spmfilter to generate a copy for each local user on local disk."
HOMEPAGE="http://www.spmfilter.org/wiki/spmfilter/Diskarchive"
SRC_URI="http://www.spmfilter.org/attachments/download/48/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/glib:2
	mail-filter/spmfilter"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	echo "set(LIBDIR  "${EPREFIX}/usr/$(get_libdir)")" > ${S}/build.properties || die
}
