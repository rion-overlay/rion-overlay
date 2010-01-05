# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/
# This ebuild is a small modification of the official gnunet-gtk ebuild

inherit eutils autotools

MY_PV=${PV/_pre/pre}
DESCRIPTION="Graphical front end for GNUnet."
HOMEPAGE="http://gnunet.org/"
SRC_URI="http://gnunet.org/download/${PN}-${MY_PV}.tar.bz2"

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND=">=x11-libs/gtk+-2.6.0
	>=net-p2p/gnunet-${PV}
	>=gnome-base/libglade-2.0"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}-${MY_PV}

src_unpack() {
	unpack ${A}
	cd "${S}"
	AT_M4DIR="${S}/m4" eautoreconf
}

src_compile() {
	econf --with-gnunet=/usr || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
