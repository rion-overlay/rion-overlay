# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit fdo-mime eutils

DESCRIPTION="Dropbox Daemon (precompiled, without gnome deps)."
HOMEPAGE="http://dropbox.com/"
SRC_URI="x86? ( http://www.getdropbox.com/download?plat=lnx.x86 -> dropbox-lnx.x86-${PV}.tar.gz )
	amd64? ( http://www.getdropbox.com/download?plat=lnx.x86_64 -> dropbox-lnx.x86_64-${PV}.tar.gz )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="mirror strip"

QA_EXECSTACK_x86="opt/dropbox-daemon/_ctypes.so"
QA_EXECSTACK_amd64="opt/dropbox-daemon/_ctypes.so"

RDEPEND="net-misc/wget
	x11-libs/libnotify
	x11-libs/libXinerama"

DEPEND="${RDEPEND}"

src_install() {
	mv "${WORKDIR}"/.dropbox-dist "${S}"
	local dir="/opt/dropbox-daemon"
	cd "${S}"
	dodir "${dir}"
	insinto "${dir}"
	doins -r * || die "doins failed"
	fperms a+x "${dir}"/dropboxd || die "fperms failed"
	fperms a+x "${dir}"/dropbox || die "fperms failed"
	dosym "${dir}"/dropboxd /opt/bin/dropbox
	make_desktop_entry dropbox "Dropbox Daemon" package.png
	domenu /usr/share/applications/dropboxd-dropbox.desktop
}
