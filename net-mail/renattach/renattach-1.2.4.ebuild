# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils

DESCRIPTION="Filter that renames/deletes dangerous email attachments."
SRC_URI="http://www.pc-tools.net/files/unix/${P}.tar.gz"
HOMEPAGE="http://www.pc-tools.net/unix/renattach/"

DEPEND=""
RDEPEND="${DEPEND}"
SLOT="0"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE=""

src_install () {
	emake DESTDIR="${D}" install || die "install error"
	dodoc AUTHORS ChangeLog README INSTALL NEWS
}
