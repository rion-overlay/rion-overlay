# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/vzctl/vzctl-3.3-r1.ebuild,v 1.1 2012/08/11 13:57:38 ssuominen Exp $

EAPI="4"

inherit bash-completion-r1 eutils toolchain-funcs

DESCRIPTION="OpenVZ ConTainers control utility"
HOMEPAGE="http://openvz.org/"
SRC_URI="http://download.openvz.org/utils/${PN}/${PV}/src/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="+ploop download +cgroup"

RDEPEND="
	net-firewall/iptables
	sys-apps/ed
	>=sys-apps/iproute2-3.0
	sys-fs/vzquota
	ploop? ( >=sys-cluster/ploop-1.5 )
	cgroup? ( >=dev-libs/libcgroup-0.37 )
	download? ( app-crypt/gpgme )
	"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	# Set default OSTEMPLATE on gentoo added
	sed -e 's:=redhat-:=gentoo-:' -i etc/dists/default || die

	local udevdir=/lib/udev
	has_version sys-fs/udev && udevdir="$($(tc-getPKG_CONFIG) --variable=udevdir udev)"
	sed -i -e "s:/lib/udev:${udevdir}:" src/lib/dev.c || die
}

src_configure() {
	econf \
		--localstatedir=/var \
		--enable-udev \
		--enable-bashcomp \
		--enable-logrotate \
		$(use_with ploop) \
		$(use_with cgroup)
}

src_install() {
	local udevdir=/lib/udev
	has_version sys-fs/udev && udevdir="$($(tc-getPKG_CONFIG) --variable=udevdir udev)"
	emake DESTDIR="${D}" udevdir="${udevdir}"/rules.d install install-gentoo

	# install the bash-completion script into the right location
	rm -rf "${ED}"/etc/bash_completion.d
	newbashcomp etc/bash_completion.d/vzctl.sh ${PN}

	# We need to keep some dirs
	keepdir /vz/{dump,lock,root,private,template/cache}
	keepdir /etc/vz/names /var/lib/vzctl/veip
}

pkg_postinst() {
	ewarn "To avoid loosing network to CTs on iface down/up, please, add the"
	ewarn "following code to /etc/conf.d/net:"
	ewarn " postup() {"
	ewarn "     /usr/sbin/vzifup-post \${IFACE}"
	ewarn " }"

	ewarn "Starting with 3.0.25 there is new vzeventd service to reboot CTs."
	ewarn "Please, drop /usr/share/vzctl/scripts/vpsnetclean and"
	ewarn "/usr/share/vzctl/scripts/vpsreboot from crontab and use"
	ewarn "/etc/init.d/vzeventd."
}
