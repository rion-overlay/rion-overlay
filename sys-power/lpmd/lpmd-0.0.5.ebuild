# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit toolchain-funcs

DESCRIPTION="Daemon controlling CPU, temperature, power, configurable in Lua"
HOMEPAGE="http://sourceforge.net/projects/lpmd/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="sys-apps/lm_sensors
		sys-fs/sysfsutils
		sys-power/cpufrequtils
		dev-lang/lua"
RDEPEND="${DEPEND}"

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" SYSCONFDIR="/etc" PREFIX="/usr" || die
}

src_install() {
	newinitd contribute/gentoo/files/lpmd.initd lpmd || die
	dosbin lpmd || die
	insinto /etc/
	newins "${S}"/lpmd.lua lpmd.lua
}
