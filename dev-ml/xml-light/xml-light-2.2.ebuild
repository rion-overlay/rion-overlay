# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils

DESCRIPTION="Minimal Xml parser and printer for OCaml"
HOMEPAGE="http://tech.motion-twin.com/xmllight.html"
SRC_URI="http://tech.motion-twin.com/zip/${P}.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/ocaml"
S=${WORKDIR}/${PN}

src_compile() {
	pwd
	make all || make all || die  # Will fail in 1st run ... FIXME
	make opt || die
}

src_install() {
	dodir /usr/lib/ocaml
	make INSTALLDIR=${D}/usr/lib/ocaml install || die
	dodoc doc/* README
}

