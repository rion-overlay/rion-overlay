# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake-utils eutils flag-o-matic multilib-minimal toolchain-funcs

MYVER=4.4

DESCRIPTION="C Unit Test Framework from Belledonne Comminications"
HOMEPAGE="https://gitlab.linphone.org/BC/public/bcunit"
# It's untagged version. So beta?
SRC_URI="https://gitlab.linphone.org/BC/public/bcunit/-/archive/release/${MYVER}/bcunit-release-${MYVER}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ncurses static-libs"

RDEPEND="ncurses? ( >=sys-libs/ncurses-5.9-r3:0=[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS NEWS README.md ChangeLog )

S="${WORKDIR}/${PN}-release-${MYVER}"

multilib_src_configure() {
	local mycmakeargs=( "-DENABLE_CURSES=$(usex ncurses)" )
	cmake-utils_src_configure
}

multilib_src_install() {
	cmake-utils_src_install
}
