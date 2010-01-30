# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/debootstrap/debootstrap-1.0.20.ebuild,v 1.7 2010/01/10 20:21:15 vapier Exp ${PN}/${PN}-1.0.10.ebuild,v 1.1 2008/07/15 17:46:08 jer Exp $

inherit eutils

DESCRIPTION="Fedora bootstrap scripts"
HOMEPAGE="http://people.redhat.com/~rjones/febootstrap/"
SRC_URI="http://people.redhat.com/~rjones/febootstrap/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=">=sys-apps/fakeroot-1.11
	>=sys-apps/fakechroot-2.9
	dev-lang/perl
	sys-apps/makedev
	>=sys-apps/yum-3.2.21"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc TODO
	doman febootstrap.8
}
