# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker xdg

DESCRIPTION="markdown editor"
HOMEPAGE="https://typora.io"
# new versions are at https://typora.io/releases/all
SRC_URI="https://typora.io/linux/typora_${PV}_amd64.deb"

LICENSE="EULA"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="
	x11-libs/libXScrnSaver
	${DEPEND}"
BDEPEND=""

S="${WORKDIR}/usr"

QA_PREBUILT="/usr/share/typora/*"

src_prepare() {
	eapply_user
	mv share/doc/typora share/doc/typora-${PV}
}

src_install() {
	insinto /usr
	doins -r *
	fperms 0755 /usr/bin/typora
}
