# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/cdemud/cdemud-1.1.0-r1.ebuild,v 1.2 2009/03/14 23:27:13 mr_bones_ Exp $

EAPI="2"

inherit eutils

DESCRIPTION="Daemon of the cdemu cd image mounting suite"
HOMEPAGE="http://www.cdemu.org"
SRC_URI="mirror://sourceforge/cdemu/cdemu-daemon-${PV}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa pulseaudio"

S="${WORKDIR}/cdemu-daemon-${PV}"

RDEPEND=">dev-libs/dbus-glib-0.6
	>=dev-libs/libdaemon-0.10
	>=dev-libs/libmirage-1.2.0
	media-libs/libao[alsa?,pulseaudio?]
	>=sys-fs/vhba-1.2.1
	>=sys-fs/sysfsutils-2.1.0"
DEPEND="${RDEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog README

	newconfd "${FILESDIR}/${PN}.conf.d-${PV}" ${PN}
	newinitd "${FILESDIR}/${PN}.init.d-${PV}" ${PN}
}

pkg_postinst() {
	elog "Either cdemu group users can start"
	elog "their own daemons or you can start"
	elog "a systembus style daemon, adding"
	elog "${PN} to the default runlevel by"
	elog "	# rc-update add ${PN} default"
	elog "as root. Systembus style daemons can be configured"
	elog "in /etc/conf.d/{PN}"
}
