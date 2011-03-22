# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

WANT_AUTOMAKE="1.11"

JAVA_PKG_OPT_USE="java"
JAVA_PKG_ALLOW_VM_CHANGE="yes"

APLANCE_PV="1.7.18"

PYTHON_DEPEND="python? 2:2.6"

USE_RUBY="ruby18"
RUBY_OPTIONAL="yes"

inherit autotools bash-completion confutils java-utils-2 java-pkg-opt-2 \
perl-module python ruby-ng
# php-ext-base-r1 haskell-cabal(?)

DESCRIPTION="Libguestfs is a library for accessing and modifying virtual machine (VM) disk images"
HOMEPAGE="http://libguestfs.org/"
SRC_URI="http://libguestfs.org/download/1.7-development/${P}.tar.gz
	http://rion-overlay.googlecode.com/files/libguestfs-1.7.18-x86_64.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="fuse +ocaml perl python ruby haskell php readline nls debug doc nls source javadoc"

COMMON_DEPEND="
	virtual/perl-Getopt-Long
	dev-perl/Sys-Virt
	>=app-misc/hivex-1.2.1[perl]
	dev-perl/libintl-perl
	dev-perl/String-ShellQuote
	dev-libs/libpcre
	app-arch/cpio
	dev-lang/perl
	virtual/cdrtools
	>=app-emulation/qemu-kvm-0.13
	sys-apps/fakeroot
	sys-apps/file
	app-emulation/libvirt
	dev-libs/libxml2:2
	dev-util/febootstrap
	>=sys-apps/fakechroot-2.8
	app-admin/augeas
	sys-fs/squashfs-tools
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
	php? ( dev-lang/php )"

DEPEND="${COMMON_DEPEND}
	dev-util/gperf
	java? ( >=virtual/jdk-1.6
		source? ( app-arch/zip ) )
	doc? ( app-text/po4a )"
RDEPEND="${COMMON_DEPEND}
	java? ( >=virtual/jre-1.6 )"

pkg_setup() {
	java-pkg-opt-2_pkg_setup

	python_set_active_version 2
	python_pkg_setup
	python_need_rebuild

	confutils_use_depend_all source java
	confutils_use_depend_all javadoc java

	ruby-ng_pkg_setup

	use php && ( ewarn "PHP bindings are incomplete and may not compile." &&
	ewarn "If so, remove php flag" )
}

src_unpack() {
	unpack ${P}.tar.gz

	cd "${WORKDIR}"
	mkdir image
	cd image || die
	unpack libguestfs-${APLANCE_PV}-x86_64.tar.gz
	cp "${WORKDIR}"/image/usr/local/lib/guestfs/* "${S}"/appliance/ || die
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
		--disable-rpath \
		$(use_with java java-home) \
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
		$(use_with tools) || die
}

src_compile() {
	emake -j1 || die
}

src_test() {
	emake -j1 check || die
}

src_install() {
	emake -j1 DESTDIR="${D}" install || die

	dodoc BUGS HACKING README RELEASE-NOTES TODO

	if use bash-completion;then
	dobashcompletion \
	"${ED}/etc"/bash_completion.d/guestfish-bash-completion.sh
	fi

	rm -fr "${ED}/etc"/bash* || die

	insinto /usr/$(get_libdir)/guestfs/
	doins "${WORKDIR}/image/usr/local/lib/"guestfs/*

	find "${ED}/usr"/$(get_libdir) -name \*.la -delete
	if use java; then
		java-pkg_newjar  java/${P}.jar ${PN},jar
		rm  -fr  "${D}/usr"/share/java
		rm  -fr  "${D}/usr"/share/javadoc
		if use source;then
			java-pkg_dosrc java/com/redhat/et/libguestfs/*
		fi
		if use javadoc;then
			java-pkg_dojavadoc java/api
		fi
	fi
	fixlocalpod
	python_clean_installation_image -q
}

pkg_preinst() {
	java-pkg-opt-2_pkg_preinst
}
