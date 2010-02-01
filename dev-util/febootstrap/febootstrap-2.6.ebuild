# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="Fedora bootstrap scripts"
HOMEPAGE="http://people.redhat.com/~rjones/febootstrap/"
SRC_URI="http://people.redhat.com/~rjones/febootstrap/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
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
