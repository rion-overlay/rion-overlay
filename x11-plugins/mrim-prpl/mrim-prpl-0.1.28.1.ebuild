# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit multilib toolchain-funcs eutils

DESCRIPTION="Mail.Ru agent protocol for pidgin."
HOMEPAGE="https://bitbucket.org/mrim-prpl-team/mrim-prpl"
SRC_URI="https://bitbucket.org/mrim-prpl-team/mrim-prpl/downloads/${P}.tar.xz"

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
	econf --gtk
}

src_compile() {
	emake CC="$(tc-getCC)" compile i18n
}

src_install() {
	emake LIBDIR=$(get_libdir) DESTDIR="${D}" install
}
