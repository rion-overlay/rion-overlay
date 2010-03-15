# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit autotools eutils linux-mod

KEYWORDS="~x86 ~amd64"
RESTRICT="mirror"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

DESCRIPTION="A set of NetFilter's modules, that not included in main tree."
HOMEPAGE="http://xtables-addons.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="virtual/modutils
	>net-firewall/iptables-1.4.1
	>virtual/linux-sources-2.6.17
	net-firewall/ipset[modules]"
DEPEND="${RDEPEND}
	virtual/linux-sources"

pkg_setup() {
	CONFIG_CHECK="NETFILTER"
	NETFILTER_ERROR="Your kernel does not support netfilter"
	CONFIG_CHECK="NF_CONNTRACK"
	NETFILTER_ERROR="You need NF_CONNTRACK compiled in or as a module"
	CONFIG_CHECK="NF_CONNTRACK_MARK"
	NETFILTER_ERROR="You need NF_CONNTRACK_MARK compiled in or as a module"
	linux-mod_pkg_setup
	BUILD_PARAMS="KERNELPATH=${KV_OUT_DIR}"
}

#Fixme (build sandbox's warnings "Access denied")
src_prepare() {
	unset ARCH
	eautoreconf
	epatch "${FILESDIR}"/xtables-addons-xt_SYSRQ.patch
	# Don't compile ipset
	sed -i s/'build_ipset=m'/'build_ipset=n'/ ./mconfig
}

src_compile() {
	emake CFLAGS="${CFLAGS}" CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	MODULE_NAMES="\
	compat_xtables(xtables_addons:"${S}:${S}"/extensions) \
	iptable_rawpost(xtables_addons:"${S}:${S}"/extensions) \
	xt_CHAOS(xtables_addons:"${S}:${S}"/extensions) \
	pknock/xt_pknock(xtables_addons:"${S}:${S}"/extensions) \
	xt_DELUDE(xtables_addons:"${S}:${S}"/extensions) \
	xt_DHCPMAC(xtables_addons:"${S}:${S}"/extensions) \
	xt_IPMARK(xtables_addons:"${S}:${S}"/extensions) \
	xt_LOGMARK(xtables_addons:"${S}:${S}"/extensions) \
	xt_RAWNAT(xtables_addons:"${S}:${S}"/extensions) \
	xt_SYSRQ(xtables_addons:"${S}:${S}"/extensions) \
	xt_STEAL(xtables_addons:"${S}:${S}"/extensions) \
	xt_TARPIT(xtables_addons:"${S}:${S}"/extensions) \
	xt_TEE(xtables_addons:"${S}:${S}"/extensions) \
	xt_condition(xtables_addons:"${S}:${S}"/extensions) \
	xt_fuzzy(xtables_addons:"${S}:${S}"/extensions) \
	xt_iface(xtables_addons:"${S}:${S}"/extensions) \
	xt_geoip(xtables_addons:"${S}:${S}"/extensions) \
	xt_ipp2p(xtables_addons:"${S}:${S}"/extensions) \
	xt_ipv4options(xtables_addons:"${S}:${S}"/extensions) \
	xt_length2(xtables_addons:"${S}:${S}"/extensions) \
	xt_lscan(xtables_addons:"${S}:${S}"/extensions) \
	xt_psd(xtables_addons:"${S}:${S}"/extensions) \
	xt_quota2(xtables_addons:"${S}:${S}"/extensions) \
"

		insinto "$(get_libdir)"/xtables
		insopts -m0755
		doins "${S}"/extensions/*.so || die "Installing of .so files failed"
		doman "${S}"/xtables-addons.8 || die "Installing of man files failed"
		# xt_SYSRQ complains about not having crypto in you need to make menuconfig and select crypto api and most likely
		# other things in there. But for now I'm just going to ignore it.

		linux-mod_src_install
}

pkg_postinst() {
		linux-mod_pkg_postinst
}

pkg_postrm() {
	linux-mod_pkg_postrm
}
