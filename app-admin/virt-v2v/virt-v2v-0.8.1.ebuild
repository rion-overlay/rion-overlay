# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit perl-module rpm

DESCRIPTION="Convert a virtual machine to run on KVM"
HOMEPAGE="http://git.fedorahosted.org/git/?p=virt-v2v.git"
SRC_URI="http://kojipkgs.fedoraproject.org/packages/${PN}/${PV}/1.fc14/src/${P}-1.fc14.src.rpm"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

COMMON_DEP="dev-perl/TimeDate
	dev-perl/IO-String
	dev-perl/libintl-perl
	virtual/perl-Module-Pluggable
	dev-perl/Net-HTTP
	dev-perl/Crypt-SSLeay
	app-emulation/libguestfs[perl]
	dev-perl/Sys-Virt
	dev-perl/Term-ProgressBar
	dev-perl/URI
	dev-perl/XML-DOM
	dev-perl/XML-DOM-XPath
	dev-perl/XML-Writer
	app-misc/hivex[perl]"

DEPEND="sys-devel/gettext
	virtual/perl-Module-Build
	${COMMON_DEP}
	test? ( dev-perl/Module-Find
			virtual/perl-ExtUtils-Manifest
			dev-perl/Test-Pod-Coverage )"

RDEPEND="${COMMON_DEP}
	>=app-emulation/libvirt-0.8.8
	virtual/cdrtools
	app-emulation/qemu-kvm
	"

S="${WORKDIR}/${PN}-v${PV}"

SRC_TEST="do"

src_install() {
	perl-module_src_install

	insinto /etc
	doins v2v/virt-v2v.conf

	dodoc -r windows

	cd "${S}"/v2v
	pod2man --name=virt-v2v.conf --section 5 --stderr -u virt-v2v.conf.pod > virt-v2v.conf.5
	doman  virt-v2v.conf.5
}
