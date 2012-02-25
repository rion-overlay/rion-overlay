# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

EAPI=2

inherit toolchain-funcs autotools

DESCRIPTION="Portable Rexx interpreter"
HOMEPAGE="http://regina-rexx.sourceforge.net"
SRC_URI="mirror://sourceforge/regina-rexx/Regina-REXX-${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~s390 ~sparc ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/Regina-REXX-${PV}"

src_configure() {
	econf || die
	sed -i \
		-e 's|-$(INSTALL) -m 755 -c ./rxstack.init.d $(STARTUPDIR)/rxstack||' \
		-e "s|/usr/share/regina|${D}/usr/share/regina|" \
	Makefile || die
}

src_compile() {
	emake CC=$(tc-getCC) -j1  || die "make problem"
}

src_install() {
	einstall datadir="${D}"/usr/share/regina || die
	rm -rf "${D}"/etc/rc.d

	doinitd "${FILESDIR}"/rxstack

	dodoc BUGS HACKERS.txt README.Unix README_SAFE TODO

	# Fix Shebang line in example scripts
	sed -e 's:/var/tmp/portage/dev-lang/regina-rexx-3.6/image::' \
		-i "${D}"/usr/share/regina/regina/*.rexx || die
}

pkg_postinst() {
	elog "You may want to run"
	elog
	elog "\trc-update add rxstack default"
	elog
	elog "to enable Rexx queues (optional)."
}
