# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

WANT_AUTOMAKE="1.11"

inherit autotools bash-completion
# php-ext-base-r1 java-utils-2 java-pkg-opt python ruby-ng haskell-cabal(?)

DESCRIPTION="Libguestfs is a library for accessing and modifying virtual machine (VM) disk images"
HOMEPAGE="http://libguestfs.org/"
SRC_URI="http://libguestfs.org/download/1.5-development/${P}.tar.gz
	http://libguestfs.org/download/binaries/libguestfs-1.5.19-x86_64.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="fuse ocaml ocaml-viewer  perl python ruby java haskell +tools php readline nls debug doc"
# Not allowed flags: daemon appliance
# in now uclibc contain rpcgen ? in 2006 me compile openrpcgen for use db :(
# If no - use libc_uclibc is needed

# Add EXTRA_ECONF in elog:--with-drive-if=ide|scsi|virtio
#--with-net-if=virtio-net-pci|ne2k_pci

COMMON_DEPEND="dev-libs/libpcre
	app-arch/cpio
	dev-lang/perl
	virtual/cdrtools
	app-emulation/qemu-kvm
	sys-apps/fakeroot
	sys-apps/file
	app-emulation/libvirt
	dev-libs/libxml2:2
	dev-util/febootstrap
	>=sys-apps/fakechroot-2.8
	app-admin/augeas
	sys-fs/squashfs-tools
	>=app-misc/hivex-1.2.1
	fuse? ( sys-fs/fuse )
	readline? ( sys-libs/readline )
	doc? ( dev-libs/libxml2 )
	ocaml? ( dev-lang/ocaml )
	ruby? ( dev-lang/ruby
			dev-ruby/rake )
	java? ( virtual/jre )
	haskell? ( dev-lang/ghc )
	tools? ( >=app-misc/hivex-1.2.1[perl]
		virtual/perl-Getopt-Long
		dev-perl/XML-Writer
		app-misc/hivex[perl]
			)
	php? ( dev-lang/php )"

#ocaml? ( xml-light )
#tools?  Sys::Virt Data::Dumper
DEPEND="${COMMON_DEPEND}
	java? ( >=virtual/jdk-1.6 )"
RDEPEND="${DEPEND}
	java? ( >=virtual/jre-1.6 )"

src_unpack() {
	unpack ${P}.tar.gz

	cd "${WORKDIR}"
	mkdir image
	cd image || die
	unpack libguestfs-1.5.19-x86_64.tar.gz
	mv "${WORKDIR}"/image/usr/local/lib/guestfs/* "${S}"/appliance/ || die
}

src_prepare() {
	#epatch "${FILESDIR}"/*.patch
	declare vmchannel_test=no
	eautoreconf
}

src_configure() {
	declare vmchannel_test=no
	econf -C \
		--with-repo=fedora-12 \
		--disable-appliance \
		--disable-daemon \
		--with-java-home=no \
		$(use_with readline) \
		$(use_enable ocaml-viewer) \
		|| die
}

src_install() {
	emake DESTDIR="${D}" install || die

	dodoc BUGS HACKING README RELEASE-NOTES TODO
}
