# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

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
	>=sys-apps/yum-3.2.21
	sys-fs/e2fsprogs
	sys-libs/e2fsprogs-libs"
QA_EXECSTACK="usr/bin/febootstrap-supermin-helper"

src_install() {
	emake DESTDIR="${ED}" install || die "emake install failed"
	dodoc TODO README examples/*.sh || die
}
