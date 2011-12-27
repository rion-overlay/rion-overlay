# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools-utils confutils

AUTOTOOLS_IN_SOURCE_BUILD=1

DESCRIPTION="C++ class framework for manipulating audio data"
HOMEPAGE="http://www.gnu.org/software/ccaudio"
SRC_URI="mirror://gnu/ccaudio/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug static-libs speex gsm"

DEPEND="dev-libs/ucommon
	gsm? ( media-sound/gsm )
	speex? ( media-libs/speex )"
RDEPEND="${DEPEND}"

PATCHES=("${FILESDIR}"/disable_gsm_automagic.patch)
DOCS=(AUTHORS ChangeLog INSTALL NEWS README SUPPORT THANKS TODO)

pkg_pretend() {
	 confutils_require_one gsm speex
}

src_prepare() {
	autotools-utils_src_prepare
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable speex)
		$(use_enable gsm)
	)
	autotools-utils_src_configure
}

src_test() {
	emake check
}
