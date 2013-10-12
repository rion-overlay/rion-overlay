# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/libguestfs/libguestfs-1.20.4.ebuild,v 1.1 2013/03/25 12:15:48 maksbotan Exp $

EAPI="5"

#WANT_LIBTOOL=latest
AUTOTOOLS_AUTORECONF=1
AUTOTOOLIZE=yes
AUTOTOOLS_IN_SOURCE_BUILD=1

EGIT_HAS_SUBMODULES=1

inherit  bash-completion-r1 autotools-utils versionator eutils \
multilib linux-info perl-module git-2

DESCRIPTION="Tools for accessing, inspect  and modifying virtual machine (VM) disk images"
HOMEPAGE="http://libguestfs.org/"
EGIT_REPO_URI="https://github.com/libguestfs/libguestfs.git"

LICENSE="GPL-2 LGPL-2"
SLOT="0/9999"

KEYWORDS=""
IUSE="erlang +fuse debug +ocaml +perl ruby static-libs
selinux systemtap introspection inspect-icons lua"

COMMON_DEPEND="
	sys-libs/ncurses
	sys-devel/gettext
	>=app-misc/hivex-1.3.1
	dev-libs/libpcre
	app-arch/cpio
	dev-lang/perl
	app-cdr/cdrkit
	>=app-emulation/qemu-1.2.2[qemu_user_targets_x86_64,qemu_softmmu_targets_x86_64,tci,systemtap?,selinux?,filecaps]
	sys-apps/fakeroot
	sys-apps/file
	app-emulation/libvirt
	dev-libs/libxml2:2
	>=sys-apps/fakechroot-2.8
	>=app-admin/augeas-0.7.1
	sys-fs/squashfs-tools
	dev-libs/libconfig
	dev-libs/libpcre
	sys-libs/readline
	>=sys-libs/db-4.6
	perl? ( virtual/perl-ExtUtils-MakeMaker
			>=dev-perl/Sys-Virt-0.2.4
			virtual/perl-Getopt-Long
			virtual/perl-Data-Dumper
			dev-perl/libintl-perl
			>=app-misc/hivex-1.3.1[perl?]
			dev-perl/String-ShellQuote
			)
	fuse? ( sys-fs/fuse )
	introspection? (
		>=dev-libs/gobject-introspection-1.30.0
		dev-libs/gjs
		)
	selinux? ( sys-libs/libselinux  sys-libs/libsemanage )
	systemtap? ( dev-util/systemtap )
	dev-lang/ocaml[ocamlopt]
	dev-ml/findlib[ocamlopt]
	ocaml? ( dev-lang/ocaml[ocamlopt]
			dev-ml/findlib[ocamlopt]
			dev-ml/ocaml-gettext
			)
	erlang? ( dev-lang/erlang )
	ruby? ( dev-lang/ruby )
	inspect-icons? ( media-libs/netpbm
			media-gfx/icoutils
			)
	virtual/acl
	sys-libs/libcap
	app-text/po4a
	"

DEPEND="${COMMON_DEPEND}
	dev-util/gperf
	ruby? ( dev-lang/ruby virtual/rubygems dev-ruby/rake )
	"
RDEPEND="${COMMON_DEPEND}
	app-emulation/libguestfs-appliance
	"
#DOCS=(AUTHORS BUGS ChangeLog HACKING README  ROADMAP TODO)

pkg_setup () {
		CONFIG_CHECK="~KVM ~VIRTIO"
		[ -n "${CONFIG_CHECK}" ] && check_extra_config;
}

src_prepare() {
	epatch_user

	if [[ ${PV} = *9999* ]]; then

	# git checkouts require bootstrapping to create the configure
	# script.
	# Additionally the submodules must be cloned to the right
	# locations
	# bug #377279
		./bootstrap || die "bootstrap failed"
		(
			git submodule status | sed 's/^[ +-]//;s/ .*//'
			git hash-object bootstrap.conf
			) >.git-module-status
	fi
}

src_configure() {

	# Disable feature test for kvm for more reason
	# i.e: not loaded module in __build__ time,
	# build server not supported kvm, etc. ...
	#
	# In fact, this feature is virtio support and requires
	# configured kernel.
	export vmchannel_test=no

	local myeconfargs=(
		--disable-appliance
		--disable-daemon
		--with-extra="-gentoo"
		--with-readline
		--disable-php
		--disable-python
		--without-java
		$(use_enable perl)
		$(use_enable fuse)
		$(use_enable ocaml)
		$(use_enable ruby)
		--disable-haskell
		$(use_enable introspection gobject)
		$(use_enable erlang)
		$(use_enable systemtap probes)
		$(use_enable lua)
	)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile

}

src_test() {
	autotools-utils_src_test
}

src_install() {
	rm -rf "${S}"/usr/man
	strip-linguas -i po
	autotools-utils_src_install "LINGUAS=""${LINGUAS}"""

	dobashcomp "${D}/etc"/bash_completion.d/guestfish-bash-completion.sh

	rm -fr "${D}/etc"/bash* || die

	use perl && fixlocalpod
}