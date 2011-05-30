# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="Separate+ is the plug-in package that provides some useful color-management functions for the GIMP."
HOMEPAGE="http://cue.yellowmagic.info/softwares/separate-plus/index.html"
SRC_URI="mirror://sourceforge.jp/separate-plus/47873/separate+-${PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/${PN}+-${PV}"

DEPEND=">=media-libs/lcms-1.15
	>=media-gfx/gimp-2.4"
RDEPEND="${DEPEND}"

src_install() {
	emake install PREFIX="${D}"/usr
}
