# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: GNUnet-Qt. Ebuild for Qt4-based Frontend for GNUnet client.$

EAPI="2"

inherit eutils autotools 

MY_PV=${PV/_pre/pre}
DESCRIPTION="Graphical front end for GNUnet."
HOMEPAGE="http://gnunet.org/"

SRC_URI="http://gnunet.org/download/${PN}-${MY_PV}.tar.bz2"

KEYWORDS="~amd64 ~ppc64 ~x86"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

## FR #1

DEPEND="x11-libs/qt-gui
	=net-p2p/gnunet-${PV}"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}-${MY_PV}

src_unpack() {
	unpack ${A}
}
src_configure() {
	econf --with-extractor --with-gnunet=/usr || die "econf failed"
}
src_compile() {
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}

