# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Find and configure your devolo (Ethernet via existing home wires) dLAN devices"
HOMEPAGE="http://www.devolo.co.uk/consumer/downloads-17-dlan-highspeed-ethernet-ii.html"
SRC_URI="http://www.devolo.co.uk/downloads/software/software-dlan-linux-v6-1.tar.gz"

LICENSE="EULA"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
S="${WORKDIR}/dlan-linux-software"

PATCHES=(${FILESDIR}/respect_ldflags.patch)

src_compile() {
	emake LDFLAGS="${LDFLAGS}"
}

src_install(){
	dobin  dlanlist
	dobin dlanpasswd
}
