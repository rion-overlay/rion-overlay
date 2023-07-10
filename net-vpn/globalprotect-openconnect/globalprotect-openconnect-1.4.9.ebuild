# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PLOG_VERSION=1.1.9
SA_VERSION=3.4.0

PLOG_SRC_URI="https://github.com/SergiusTheBest/plog/archive/refs/tags/${PLOG_VERSION}.tar.gz -> plog-${PLOG_VERSION}.tar.gz"
SA_SRC_URI="https://github.com/itay-grudev/SingleApplication/archive/refs/tags/v${SA_VERSION}.tar.gz -> SingleApplication-${SA_VERSION}.tar.gz"
if [[ ${PV} == 9999* ]]; then
  inherit cmake git-r3
  SRC_URI="$PLOG_SRC_URI $SA_SRC_URI"
  KEYWORDS=""
  EGIT_REPO_URI="https://github.com/yuezk/GlobalProtect-openconnect.git"
  EGIT_SUBMODULES=( '-*' )
else
  inherit cmake
  SRC_URI="https://github.com/yuezk/GlobalProtect-openconnect/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$PLOG_SRC_URI $SA_SRC_URI"
  KEYWORDS="amd64 x86"
  S="${WORKDIR}/GlobalProtect-openconnect-${PV}"
fi

DESCRIPTION="GlobalProtect VPN GUI based on Openconnect with SAML auth mode support"
HOMEPAGE="https://github.com/yuezk/GlobalProtect-openconnect"

LICENSE="GPL-3"
SLOT="0"

DEPEND="
	dev-libs/plog
	dev-libs/qtkeychain
	dev-qt/qtcore
	dev-qt/qtdbus
	dev-qt/qtnetwork
	dev-qt/qtwebengine
	dev-qt/qtwebsockets
	dev-qt/qtwidgets
	net-vpn/openconnect
"
RDEPEND="${DEPEND}"
BDEPEND=""
CMAKE_MAKEFILE_GENERATOR=emake

src_unpack() {
	default_src_unpack
	if [[ ${PV} == 9999* ]]; then
		git-r3_src_unpack
	fi
	rm -rf $S/3rdparty/plog
	rm -rf $S/3rdparty/SingleApplication
	mv $WORKDIR/plog-${PLOG_VERSION} $S/3rdparty/plog
	mv $WORKDIR/SingleApplication-${SA_VERSION} $S/3rdparty/SingleApplication
}

