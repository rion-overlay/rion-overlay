# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
inherit base

DESCRIPTION="Dropbox Daemon (precompiled, without gnome deps)."
HOMEPAGE="http://dropbox.com/"
SRC_URI="x86? ( http://dl-web.dropbox.com/u/17/dropbox-lnx.x86-${PV}.tar.gz )
	amd64? ( http://dl-web.dropbox.com/u/17/dropbox-lnx.x86_64-${PV}.tar.gz )"

LICENSE="EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror strip"

QA_EXECSTACK_x86="opt/dropbox-daemon/_ctypes.so"
QA_EXECSTACK_amd64="opt/dropbox-daemon/_ctypes.so"

DEPEND="x11-libs/libnotify
	x11-libs/libXinerama"

RDEPEND="${DEPEND}
	net-misc/wget"

S="${WORKDIR}/.dropbox-dist"

src_install() {
	local dir="${EPREFIX}/opt/dropbox-daemon"
	insinto "${dir}"
	doins -r *
	rm -rf  "${D}/${dir}"/icons
	fperms a+x "${dir}"/dropboxd
	fperms a+x "${dir}"/dropbox
	dosym "${dir}"/dropboxd /opt/bin/dropbox

	insinto "${EPREFIX}"/usr/share
	doins -r icons
	dosym "${EPREFIX}"/usr/share/icons "${EPREFIX}/opt/dropbox-daemon/icons"
	make_desktop_entry dropbox "Dropbox Daemon" dropboxstatus-logo
	insinto "${EPREFIX}"/etc/xdg/autostart
	doins "${ED}"/usr/share/applications/dropbox-dropbox.desktop
}
