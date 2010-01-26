# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

WANT_AUTOCONF="2.5"
WANT_AUTOMAKE="1.10"

inherit autotools eutils linux-info pam

DESCRIPTION="Libcgroups  is a library that abstracts the  control group file system in Linux"
HOMEPAGE="http://libcg.sourceforge.net/"
SRC_URI="http://kent.dl.sourceforge.net/project/libcg/${PN}/v${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +pam +tools +daemon"

DEPEND="sys-devel/flex
		sys-devel/bison
		pam? ( sys-libs/pam )"

RDEPEND="pam? ( sys-libs/pam )"

CONFIG_CHECK="CGROUPS
	~CGROUP_NS ~CPUSETS ~CGROUP_CPUACCT
	~CGROUP_MEM_RES_CTLR
	~CGROUP_SCHED"

ERROR_CGROUPS="CONFIG_CGROUPS: must enabled for works"

src_prepare() {
	eautoconf
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable pam) \
		$(use_enable tools) \
		$(use_enable daemon) || die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"

	dodoc README README_daemon
	if use daemon;then
		newinitd  "${FILESDIR}"/cgred.init cgred
		newinitd  "${FILESDIR}"/cgconfig.init cgconfig
		newconfd  "${FILESDIR}"/cgred.confd cgred

		insinto /etc/"${PN}"
		doins "${S}/samples"/{cgconfig,cgrules}.conf
	fi

	rm -f "${D}"/usr/lib64/*.la

	if use pam;then
		exeinto $(getpam_mod_dir)
		doexe	"${D}"/usr/lib64/pam_cgroup.so.0.0.0

		rm -fr "${D}"/usr/lib64/pam_*
	fi
}
