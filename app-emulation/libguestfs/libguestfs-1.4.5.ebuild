# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

WANT_AUTOCONF="2.5"
WANT_AUTOMAKE="1.10"

inherit autotools

DESCRIPTION="Libguestfs is a library for accessing and modifying virtual machine (VM) disk images"
HOMEPAGE="http://libguestfs.org/"
SRC_URI="http://libguestfs.org/download/1.4-stable/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-x86-interix"
IUSE="ocaml ruby kvm haskell perl python readline nls debug doc"

DEPEND="dev-lang/perl
	virtual/cdrtools
	kvm? ( app-emulation/qemu-kvm )
	!kvm? ( >=app-emulation/qemu-0.10 )
	>=sys-apps/fakechroot-2.8
	dev-util/febootstrap
	nls? ( >=sys-devel/gettext-0.17 )
	readline? ( sys-libs/readline )
	doc? ( dev-libs/libxml2 )
	ocaml? ( dev-lang/ocaml )
	ruby? ( dev-lang/ruby )
	haskell? ( dev-lang/ghc )"

RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/*.patch
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die
}
