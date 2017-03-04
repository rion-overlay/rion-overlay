# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit findlib eutils

DESCRIPTION="Ocaml libvirt binding's"
HOMEPAGE="http://www.libvirt.org/"
SRC_URI="http://libvirt.org/sources/ocaml/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

DEPEND="app-emulation/libvirt
	dev-ml/ocaml-gettext"

RDEPEND="${DEPEND}"
DOCS=( ChangeLog README )

src_compile() {
	default

	if use doc; then
		emake doc
	fi
}

isrc_install() {
	findlib_src_install
	emake DESTDIR="${ED}"  install-opt install-byte
}

src_install() {
	#install lib

	local destdir=`ocamlfind printconf destdir`
	insinto "${destdir}"/libvirt
	doins libvirt/*.{cmo,cmi,ml,mli,a,cma}
	doins META
	insinto "${destdir}"/stublibs
	insopts -m755
	doins libvirt/*.so

	#strip-linguas -u po
	#install po files
	#cd po
	#emake DESTDIR="${ED}" install install-po
	cd "${S}"

#	dobin mlvirsh/mlvirsh

	einstalldocs

	insinto /usr/share/"${PN}"
	doins -r examples

	if use doc; then
		dohtml -r html/*
	fi
}
