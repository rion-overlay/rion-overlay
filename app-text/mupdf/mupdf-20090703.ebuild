# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

MY_PN="2009-07-03-source"
DESCRIPTION="Lightweight PDF viewer and toolkit written in portable C."
HOMEPAGE="http://ccxvii.net/mupdf"
SRC_URI="http://ccxvii.net/${PN}/download/${PN}-${MY_PN}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="jpeg2k  jbig debug"

COMMON_DEP="sys-libs/zlib
			media-libs/jpeg
			media-libs/freetype:2
			jpeg2k? ( media-libs/jasper )
			jbig? ( media-libs/jbigkit )"

DEPEND="${COMMON_DEP}
		app-arch/unzip
		dev-util/ftjam"

RDEPEND="${COMMON_DEP}"

S="${WORKDIR}/${PN}-${MY_PN}"

src_compile() {
	local HAVE=""

	if use debug ; then
			HAVE="-sBUILD=debug"
		else
			HAVE="-sBUILD=release"
	fi

	use jbig && HAVE="$HAVE -sHAVE_JBIG2DEC=yes"
	use jpeg2k	&& HAVE="$HAVE -sHAVE_JASPER=yes"

	cd "${S}"

	jam $HAVE $MAKEOPTS || die "jam failed"
}

src_install() {

	for i in cmapdump fontdump mupdf pdfclean pdfdraw pdfextract pdfinfo pdfshow ; do
		dobin "${S}"/build/$i
	done

	dodoc README
}
