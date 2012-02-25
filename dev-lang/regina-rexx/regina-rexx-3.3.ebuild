# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/regina-rexx/regina-rexx-3.3.ebuild,v 1.16 2009/07/23 23:27:45 vostorga Exp $

WANT_AUTOCONF="2.1"

inherit autotools

DESCRIPTION="Portable Rexx interpreter"
HOMEPAGE="http://regina-rexx.sourceforge.net"
SRC_URI="mirror://sourceforge/regina-rexx/Regina-REXX-${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 hppa ppc s390 sparc x86"
IUSE=""

DEPEND=""
RDEPEND=""

S=${WORKDIR}/Regina-${PV}

src_unpack() {
	unpack ${A}
	cd "${S}"
	eautoreconf || die "eautoreconf problem"
}

src_compile() {
	econf || die "econf failed"
	sed -i \
		-e 's|-$(INSTALL) -m 755 -c ./rxstack.init.d $(STARTUPDIR)/rxstack||' \
		-e "s|/usr/share/regina|${D}/usr/share/regina|" \
		Makefile || die
	emake CC=$(tc-getCC) CFLAGS="${CFLAGS} -fno-strict-aliasing" -j1 || die "make problem"
}

src_install() {
	einstall datadir="${D}"/usr/share/regina || die
	rm -rf "${D}"/etc/rc.d

	doinitd "${FILESDIR}"/rxstack

	dodoc BUGS HACKERS.txt README.Unix README_SAFE TODO

	# Fix Shebang line in example scripts
	sed -e 's:/var/tmp/portage/dev-lang/regina-rexx-3.3/image::' \
		-i "${D}"/usr/share/regina/regina/*.rexx
}

pkg_postinst() {
	elog "You may want to run"
	elog
	elog "\trc-update add rxstack default"
	elog
	elog "to enable Rexx queues (optional)."
}
