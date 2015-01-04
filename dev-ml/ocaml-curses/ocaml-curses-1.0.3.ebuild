# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /cvs/zport/dev-ml/ocamlp3l/ocamlp3l-2.03.ebuild,v 1.1 2007/03/06 13:13:02 zechs Exp $

EAPI=5

inherit eutils autotools findlib

DESCRIPTION="OCaml Curses is a project to provide curses / ncurses  bindings for the Objective Caml  language."
HOMEPAGE="http://www.nongnu.org/ocaml-tmk/"
SRC_URI="http://download.savannah.nongnu.org/releases/ocaml-tmk/${P}.tar.gz"

LICENSE="LGPL"
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
