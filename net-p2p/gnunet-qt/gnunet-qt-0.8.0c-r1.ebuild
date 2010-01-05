# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

MY_PV=${PV/_pre/pre}
DESCRIPTION="Graphical front end for GNUnet."
HOMEPAGE="http://www.gnu.org/software/gnunet/"

SRC_URI="http://gnunet.org/download/${PN}-${MY_PV}.tar.bz2"

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="x11-libs/qt-gui:4
	=net-p2p/gnunet-${PV}"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}-${MY_PV}

src_configure() {
	econf \
		--with-extractor \
		--with-gnunet=/usr || die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	# einstall  || die "emake install failed"
}
