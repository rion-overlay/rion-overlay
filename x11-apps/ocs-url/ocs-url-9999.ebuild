# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils xdg

DESCRIPTION="A program enabling web-installation of items via OpenCollaborationServices"
HOMEPAGE="https://opendesktop.org/p/1136805"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	SRC_URI=""
	KEYWORDS=""
	EGIT_REPO_URI="https://git.opendesktop.org/dfn2/${PN}.git"
else
	SRC_URI="https://git.opendesktop.org/akiraohgaki/${PN}/-/archive/release-${PV}/${PN}-release-${PV}.tar.bz2"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	S="${WORKDIR}/${PN}-release-${PV}"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE=""

DEPEND="
	>=dev-qt/qtcore-5.2.0:5
	>=dev-qt/qtdeclarative-5.2.0:5
	>=dev-qt/qtquickcontrols-5.2.0:5
	>=dev-qt/qtsvg-5.2.0:5
"
RDEPEND="${DEPEND}"

src_unpack() {
	git-r3_src_unpack

	unset EGIT_BRANCH EGIT_COMMIT
	EGIT_REPO_URI=https://github.com/akiraohgaki/qtil.git
	EGIT_CHECKOUT_DIR="${S}/lib/qtil"
	git-r3_src_unpack
}

src_prepare(){
	./scripts/prepare || die
	default_src_prepare
}

src_configure(){
	eqmake5 PREFIX="/usr"
}

src_install(){
	INSTALL_ROOT="${D}" default_src_install
}

pkg_postinst(){
	xdg_pkg_postinst
	elog "Thanks for installing ocs-url."
	elog "You can install packages from any page from"
	elog "https://www.opendesktop.org or related ones."
	elog "Just click on \"Install\", and then open the ocs://"
	elog "url provided by every package."
}
