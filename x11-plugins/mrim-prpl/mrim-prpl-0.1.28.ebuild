# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit multilib toolchain-funcs

DESCRIPTION="Mail.Ru agent protocol for pidgin."
HOMEPAGE="http://code.google.com/p/mrim-prpl/"
SRC_URI="http://mrim-prpl.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=net-im/pidgin-2.6[gtk]"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/gettext
"

src_configure() {
	./configure --gtk || die
}

src_compile() {
	emake CC="$(tc-getCC)" compile i18n
}

src_install() {
	emake LIBDIR=$(get_libdir) DESTDIR="${D}" install
}
