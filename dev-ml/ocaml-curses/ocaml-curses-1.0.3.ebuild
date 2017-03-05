# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils autotools findlib

DESCRIPTION="Curses / ncurses  bindings for the Objective Caml  language."
HOMEPAGE="http://www.nongnu.org/ocaml-tmk/"
SRC_URI="http://download.savannah.nongnu.org/releases/ocaml-tmk/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""
DEPEND=">=dev-lang/ocaml-3.12
	dev-ml/findlib"

src_prepare() {
	eautoreconf
}

src_install() {
	findlib_src_install
	#sed -i "s/\/usr\/local/\${D}usr/" makefile.config
#	local myconf="OCAMLFIND_INSTFLAGS=-destdir ${D}usr/lib/ocaml/site-packages -ldconf ${D}usr/lib/ocaml/ld.conf"
#dodir /usr/lib/ocaml/site-packages
#	emake "${myconf}" install || die
}
