# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils toolchain-funcs multilib

DESCRIPTION="openvz tool and a library to control ploop block devices"
HOMEPAGE="http://wiki.openvz.org/Download/ploop"
SRC_URI="http://download.openvz.org/utils/ploop/${PV}/src/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-libs/libxml2"
RDEPEND="${DEPEND}"

src_prepare() {
	# Respect CFLAGS and CC
	sed -e 's|CFLAGS =|CFLAGS +=|' -e "s|\(CC=\).*|\1$(tc-getCC)|" \
		-i Makefile.inc || die
	# Avoid striping of binaries
	sed -e '/INSTALL/{s: -s::}' -i tools/Makefile || die
	epatch "${FILESDIR}/ploop-1.2-soname.patch"
}

src_compile() {
	emake V=1
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc tools/README
	ldconfig -n "${D}/usr/$(get_libdir)/" || die
}

pkg_postins() {
	elog "Warning - API changes"
	elog "1. This version requires running vzkernel >= 2.6.32-042stab061.1"
	elog "2. DiskDescriptor.xml created by older ploop versions are converted to current format"
}

#TODO
# grepping an add new udev rules to 
# 
