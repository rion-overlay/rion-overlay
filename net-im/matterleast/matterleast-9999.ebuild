# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3 xdg

DESCRIPTION="Native Qt client for Mattermost"
HOMEPAGE="https://github.com/Ri0n/matterleast"
EGIT_REPO_URI="https://github.com/Ri0n/matterleast.git"
# Calls is currently developed on this branch.
EGIT_BRANCH="feature/calls-gstreamer-ubuntu2404"
QITE_COMMIT="a63234b6d3cd67235920554ad173fbc1a4f53956"
SRC_URI="multimedia? (
	https://codeload.github.com/Ri0n/qite/tar.gz/${QITE_COMMIT} -> qite-${QITE_COMMIT}.tar.gz
)"

LICENSE="LGPL-3+ multimedia? ( Apache-2.0 )"
SLOT="0"
IUSE="+calls +multimedia"

BDEPEND="virtual/pkgconfig"
DEPEND="
	>=app-crypt/qca-3.0.10:3[ssl]
	>=dev-libs/qtkeychain-0.17.0
	dev-qt/qtbase:6[dbus,gui,network,sqlite,widgets]
	dev-qt/qtsvg:6
	dev-qt/qtwebsockets:6
	app-text/hunspell:=
	multimedia? ( dev-qt/qtmultimedia:6 )
	calls? (
		dev-libs/glib:2
		>=media-libs/gstreamer-1.24:1.0
		>=media-libs/gst-plugins-base-1.24:1.0
		>=media-libs/gst-plugins-bad-1.24:1.0
	)
"
RDEPEND="${DEPEND}
	calls? (
		media-libs/gst-plugins-good:1.0
		media-plugins/gst-plugins-dtls:1.0
		media-plugins/gst-plugins-opus:1.0
		media-plugins/gst-plugins-pulse:1.0
		media-plugins/gst-plugins-sctp:1.0
		media-plugins/gst-plugins-srtp:1.0
		media-plugins/gst-plugins-webrtc:1.0
		net-libs/libnice
	)
"

src_unpack() {
	default
	git-r3_src_unpack
}

src_configure() {
	local mycmakeargs=(
		-DMATTERLEAST_VERSION=2.7
		-DQT_6=ON
		-DBUILD_TESTING=OFF
		-DMATTERLEAST_REQUIRE_SYSTEM_KEYCHAIN=ON
		-DMATTERLEAST_BUNDLED_QCA=OFF
		-DFETCHCONTENT_FULLY_DISCONNECTED=ON
		-DMATTERLEAST_BUILD_CALLS_GSTREAMER=$(usex calls)
		-DBUILD_MULTIMEDIA=$(usex multimedia)
	)
	use multimedia && mycmakeargs+=(
		-DFETCHCONTENT_SOURCE_DIR_MATTERLEAST_QITE="${WORKDIR}/qite-${QITE_COMMIT}"
	)
	cmake_src_configure
}
