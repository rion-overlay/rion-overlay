# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit cmake-utils multilib

DESCRIPTION="Sends a copy of each incoming and outgoing message to a defined smtp host"
HOMEPAGE="http://www.spmfilter.org/wiki/spmfilter/Smtpbcc"
SRC_URI="ftp://ftp.spmfilter.org/pub/sources/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/glib:2
		mail-filter/spmfilter"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

DOCS="AUTHORS ChangeLog README"

src_prepare() {
	echo "set(LIBDIR  "${EPREFIX}/usr/$(get_libdir)")" > ${S}/build.properties || die
}
