# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:$

inherit eutils toolchain-funcs versionator

MY_P="${PN}-$(get_version_component_range 1-2)-PR$(get_version_component_range 3)"
DESCRIPTION="identify/delete duplicate files residing within specified directories"
HOMEPAGE="http://netdial.caribe.net/~adrian2/fdupes.html"
SRC_URI="http://netdial.caribe.net/~adrian2/programs/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="md5sum-external"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}"-external-md5sum-quotation.patch
	if use md5sum-external; then
		sed -i -e 's/^#EXTERNAL_MD5[[:blank:]]*= /EXTERNAL_MD5 = /g' \
			Makefile || die "sed failed"
	fi
	sed -e 's/-o fdupes/${CFLAGS} ${LDFLAGS} -o fdupes/' -i Makefile \
		|| die "sed	filed"
}

src_compile() {
	sed -i -e "s:gcc:$(tc-getCC):" Makefile || die "sed filed"
	emake || die
}

src_install() {
	dobin fdupes || die
	doman fdupes.1
	dodoc CHANGES CONTRIBUTORS INSTALL README TODO
}
