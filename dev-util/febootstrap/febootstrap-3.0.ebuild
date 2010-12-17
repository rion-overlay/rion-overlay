# Copyright 1999-2010 Gentoo Foundation
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

RDEPEND="dev-lang/ocaml[ocamlopt]
	dev-ml/findlib
	dev-lang/perl
	=app-arch/rpm-4*
	>=sys-apps/yum-3.2.21
	sys-fs/e2fsprogs
	sys-libs/e2fsprogs-libs"

src_install() {
	emake DESTDIR="${ED}" install || die "emake install failed"
}
