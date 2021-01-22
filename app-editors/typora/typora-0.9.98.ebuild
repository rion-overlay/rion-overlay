# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit unpacker xdg

DESCRIPTION="markdown editor"
HOMEPAGE="https://typora.io"
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

src_install() {
	insinto /usr
	doins -r *
	fperms 0755 /usr/bin/typora
}
