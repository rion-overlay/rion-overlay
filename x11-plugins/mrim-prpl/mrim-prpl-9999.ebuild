# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit multilib toolchain-funcs git-2

DESCRIPTION="Mail.Ru agent protocol for pidgin."
HOMEPAGE="http://code.google.com/p/mrim-prpl/"
EGIT_REPO_URI="https://code.google.com/p/mrim-prpl/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=">=net-im/pidgin-2.6"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/gettext
"

# FIXME upstream build system is broken again: does not respect CC

src_install() {
	emake LIBDIR=$(get_libdir) DESTDIR="${D}" install
}
