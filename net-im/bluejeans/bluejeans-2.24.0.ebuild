# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rpm xdg

DESCRIPTION="Online meetings, video conferencing, and screen sharing for teams of any size"
HOMEPAGE="https://www.bluejeans.com"
EXTRA_VERSION=89
RPMV="${PV}.${EXTRA_VERSION}"
SRC_URI="https://swdl.bluejeans.com/desktop-app/linux/${PV}/BlueJeans_${RPMV}.rpm"

LICENSE="BlueJeans"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}"

src_install() {
	cp -R "${S}/"* "${D}/" || die "Install failed!"
	fperms +x /opt/BlueJeans/${PN}-v2
}
