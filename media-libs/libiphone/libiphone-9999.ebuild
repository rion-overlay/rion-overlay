# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git autotools

DESCRIPTION="Library for access to a iphone and ipod touch without a jailbreak"
HOMEPAGE="http://matt.colyer.name/projects/iphone-linux/"
EGIT_REPO_URI="http://git.matt.colyer.name/2008/libiphone/"
EGIT_PROJECT="libiphone"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="net-libs/gnutls
	sys-fs/fuse"
RDEPEND="${DEPEND}"

src_unpack() {
	git_src_unpack
	cd "${S}"
	epatch "${FILESDIR}/${PN}-gnutls.patch"
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
}
