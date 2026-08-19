# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3 multilib

DESCRIPTION="XMPP network library used by Psi and AnyKeep"
HOMEPAGE="https://github.com/psi-im/iris"
EGIT_REPO_URI="https://github.com/psi-im/iris.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="+omemo +sctp"

RDEPEND="
	app-crypt/qca:3[ssl]
	dev-qt/qtbase:6[gui,network,xml]
	sys-libs/zlib
	omemo? ( >=net-libs/libomemo-c-0.5.1 )
	sctp? ( net-libs/usrsctp )
"
DEPEND="${RDEPEND}"
BDEPEND="
	omemo? ( virtual/pkgconfig )
"

PATCHES=( "${FILESDIR}/${PN}-system-qca3.patch" )

src_configure() {
	local mycmakeargs=(
		-DUSE_QT6=ON
		-DQT_DEFAULT_MAJOR_VERSION=6
		-DIRIS_ENABLE_INSTALL=ON
		-DIRIS_BUILD_TOOLS=OFF
		-DIRIS_BUNDLED_QCA=OFF
		-DQca_INCLUDE_DIR="${EPREFIX}/usr/include/Qca3-qt6/QtCrypto"
		-DQca_LIBRARY="${EPREFIX}/usr/$(get_libdir)/libqca3-qt6.so"
		-DIRIS_ENABLE_OMEMO=$(usex omemo)
		-DIRIS_BUNDLED_OMEMO_C=OFF
		-DIRIS_ENABLE_JINGLE_SCTP=$(usex sctp)
		-DIRIS_BUNDLED_USRSCTP=OFF
	)
	cmake_src_configure
}
