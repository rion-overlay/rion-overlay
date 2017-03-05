# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="HTML And Shell Embedded Report Language"
HOMEPAGE="http://haserl.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="lua"

RDEPEND="lua? ( dev-lang/lua:0 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog README THANKS TODO )

src_configure() {
	econf $(use_with lua)
}
