# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit git autotools

DESCRIPTION="fuse module for access to iphone and ipod touch without jailbreak"
HOMEPAGE="http://matt.colyer.name/projects/iphone-linux/"
EGIT_REPO_URI="http://git.matt.colyer.name/2008/ifuse/"
EGIT_PROJECT="ifuse"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="media-libs/libiphone
	>=sys-fs/fuse-2.7.0
	dev-libs/glib:2"
RDEPEND="${DEPEND}"

src_unpack() {
	git_src_unpack
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
}
