# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="The flag icon filenames follow the ISO 3166-1 alpha-2 country codes."
HOMEPAGE="http://www.famfamfam.com/lab/icons/flags/"
SRC_URI="http://www.famfamfam.com/lab/icons/flags/famfamfam_flag_icons.zip"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

src_install() {
	insinto /usr/share/"${P}"
	doins -r gif/
	doins -r png/

	dodoc readme.txt
}
