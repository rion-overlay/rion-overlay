# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

WANT_AUTOCONF="2.5"
WANT_AUTOMAKE="1.10"

inherit autotools

DESCRIPTION="Libguestfs is a library for accessing and modifying virtual machine (VM) disk images"
HOMEPAGE="http://libguestfs.org/"
SRC_URI="http://libguestfs.org/download/1.5-development/${P}.tar.gz
	http://libguestfs.org/download/binaries/libguestfs-1.5.19-x86_64.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
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

src_unpack() {
	unpack ${P}.tar.gz

	cd ${WORKDIR}
	mkdir image
	cd image || die
	unpack libguestfs-1.5.19-x86_64.tar.gz
	mv "${WORKDIR}"/image/usr/local/lib/guestfs/* "${S}"/appliance/ || die
}

src_prepare() {
	#epatch "${FILESDIR}"/*.patch
	eautoreconf
}

scr_configure() {
	econf \
		--with-repo=fedora-12 \
		--disable-appliance \
		--disable-daemon || die
}

src_install() {
	emake DESTDIR="${D}" install || die
}
