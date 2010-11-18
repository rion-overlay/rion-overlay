# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

WANT_AUTOMAKE="1.11"
JAVA_PKG_OPT_USE="java"

inherit autotools bash-completion confutils java-pkg-opt-2 perl-module
# php-ext-base-r1 java-utils-2 java-pkg-opt python ruby-ng haskell-cabal(?)

DESCRIPTION="Libguestfs is a library for accessing and modifying virtual machine (VM) disk images"
HOMEPAGE="http://libguestfs.org/"
SRC_URI="http://libguestfs.org/download/1.7-development/${P}.tar.gz
	http://libguestfs.org/download/binaries/libguestfs-1.7.0-x86_64.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="fuse ocaml +perl python ruby  haskell +tools php +readline
nls debug doc"
# Not allowed flags: daemon appliance
# in now uclibc contain rpcgen ? in 2006 me compile openrpcgen for use db :(
# If no - use libc_uclibc is needed

# Add EXTRA_ECONF in elog:--with-drive-if=ide|scsi|virtio
#--with-net-if=virtio-net-pci|ne2k_pci

PERL_DEPEND="
	virtual/perl-Getopt-Long
	dev-perl/Sys-Virt
	dev-perl/XML-Writer
	>=app-misc/hivex-1.2.1[perl]
	dev-lang/perl
	dev-perl/libintl-perl"

COMMON_DEPEND="dev-libs/libpcre[cxx,unicode]
	app-arch/cpio
	dev-lang/perl
	virtual/cdrtools
	>=app-emulation/qemu-kvm-0.13[qemu_softmmu_targets_x86_64,qemu_user_targets_x86_64]
	sys-apps/fakeroot
	sys-apps/file
	app-emulation/libvirt
	dev-libs/libxml2:2
	dev-util/febootstrap
	>=sys-apps/fakechroot-2.8
	app-admin/augeas
	sys-fs/squashfs-tools
	>=app-misc/hivex-1.2.1
	perl? ( virtual/perl-ExtUtils-MakeMaker )
	fuse? ( sys-fs/fuse )
	readline? ( sys-libs/readline )
	doc? ( dev-libs/libxml2 )
	ocaml? ( dev-lang/ocaml
		dev-ml/xml-light
		dev-ml/findlib )
	ruby? ( dev-lang/ruby
			dev-ruby/rake )
	java? ( virtual/jre )
	haskell? ( dev-lang/ghc )
	tools? ( ${PERL_DEPEND} )
	php? ( dev-lang/php )"

DEPEND="${COMMON_DEPEND}
	java? ( >=virtual/jdk-1.6 )
	doc? ( app-text/po4a )
	dev-util/gperf"
RDEPEND="${COMMON_DEPEND}
	java? ( >=virtual/jre-1.6 )"

pkg_setup() {
	java-pkg-opt-2_pkg_setup
	confutils_use_depend_all tools perl
	use php && ( ewarn "PHP bindings are incomplete and may not compile." &&
	ewarn "If so, remove php flag" )
}

src_unpack() {
	unpack ${P}.tar.gz

	cd "${WORKDIR}"
	mkdir image
	cd image || die
	unpack libguestfs-1.7.0-x86_64.tar.gz
	mv "${WORKDIR}"/image/usr/local/lib/guestfs/* "${S}"/appliance/ || die
}

src_prepare() {
	java-pkg-opt-2_src_prepare
	epatch "${FILESDIR}"/remove-root-check.patch
	eautoreconf
}

src_configure() {
	econf -C \
		--with-repo=fedora-12 \
		--disable-appliance \
		--disable-daemon \
		--with-drive-if=virtio \
		--with-net-if=virtio-net-pci \
		--with-java-home=no \
		--with-qemu=qemu-system-x86_64 \
		$(use_enable nls) \
		$(use_with readline) \
		$(use_enable ocaml-viewer) \
		$(use_enable perl) \
		$(use_enable fuse) \
		$(use_enable ocaml) \
		$(use_enable python) \
		$(use_enable ruby) \
		$(use_enable haskell) \
		$(use_enable php) \
		$(use_with doc po4a) \
		$(use_with inspector) \
		$(use_with tools) || die
}

src_install() {
	emake DESTDIR="${D}" install || die

	dodoc BUGS HACKING README RELEASE-NOTES TODO

	if !use bash-completion;then
		rm -fr "${S}"/etc/bash-completion || die
	fi

	fixlocalpod
}
