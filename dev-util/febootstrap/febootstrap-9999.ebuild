# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

AUTOTOOLS_IN_SOURCE_BUILD=1
EGIT_HAS_SUBMODULES=yes

inherit autotools-utils git-2 autotools

DESCRIPTION="Fedora bootstrap scripts"
HOMEPAGE="http://people.redhat.com/~rjones/febootstrap/"
EGIT_REPO_URI="git://git.annexia.org/git/febootstrap.git"
EGIT_PROJECT="febootstrap"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-lang/ocaml[ocamlopt]
	dev-ml/findlib
	dev-lang/perl
	sys-fs/e2fsprogs
	sys-libs/e2fsprogs-libs
	=app-arch/rpm-4*
	>=sys-apps/yum-3.2.21"

DEPEND="${RDEPEND}"

src_prepare() {
	./gnulib/gnulib-tool --update
	eautoreconf
}
