# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker xdg

DESCRIPTION="markdown editor/reader"
HOMEPAGE="https://typora.io"
# new versions are at https://typora.io/releases/all
SRC_URI="https://typora.io/linux/typora_${PV}_amd64.deb"

LICENSE="EULA"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="bindist mirror"

DEPEND=""
RDEPEND="
	dev-libs/expat
	dev-libs/nspr
	media-libs/alsa-lib
	net-print/cups
	sys-apps/dbus
	x11-libs/cairo[X,glib]
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
