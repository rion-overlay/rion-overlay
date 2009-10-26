# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/cdemu/cdemu-1.1.0-r1.ebuild,v 1.2 2009/03/12 08:08:46 dev-zero Exp $

EAPI="2"

inherit multilib python

DESCRIPTION="Client of cdemu suite, which mounts all kinds of cd images"
HOMEPAGE="http://cdemu.org"
SRC_URI="mirror://sourceforge/cdemu/cdemu-client-${PV}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-lang/python-2.4
	dev-python/dbus-python
	~app-cdr/cdemud-${PV}"
DEPEND="${RDEPEND}
	dev-util/intltool"

S="${WORKDIR}/cdemu-client-${PV}"

src_prepare() {
	# disable compilation of python modules
	rm py-compile || die
	ln -s "$(type -P true)" py-compile || die
}

src_install() {
	emake install DESTDIR="${D}" || die "install failed"
	dodoc AUTHORS ChangeLog README
}

pkg_postinst() {
	python_version
	python_mod_optimize $(python_get_sitedir)/cdemu
	python_need_rebuild
}

pkg_postrm() {
	python_mod_cleanup
}
