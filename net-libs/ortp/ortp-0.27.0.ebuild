# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils

DESCRIPTION="Open Real-time Transport Protocol (RTP, RFC3550) stack"
HOMEPAGE="http://www.linphone.org/"
SRC_URI="mirror://nongnu/linphone/${PN}/sources/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/9"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc examples minimal ntp-timestamp"

RDEPEND="
	net-libs/bctoolbox
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig
"

src_prepare() {
	default
	# ${P} is added after ${docdir}
	if use doc; then
		sed -i -e 's/$(docdir)\/$(PACKAGE)-$(VERSION)/$(docdir)/' Makefile.in \
			|| die "patching Makefile.in failed"
	fi
}

src_configure() {
	local myeconfargs=(
		# memcheck is for HP-UX only
		--disable-memcheck
		# mode64bit adds +DA2.0W +DS2.0 CFLAGS wich are needed for HP-UX
		--disable-mode64bit
		# strict adds -Werror, do not want it
		--disable-strict
		--enable-fast-install
		--enable-libtool-lock

		$(use_enable debug)
		$(use_enable minimal perf)
		$(use_enable ntp-timestamp)

		$(use doc || echo ac_cv_path_DOXYGEN=false)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" pkgdocdir="${EPREFIX}"/usr/share/doc/${PF} \
		install

	einstalldocs

	prune_libtool_files

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins src/tests/*.c
	fi
}
