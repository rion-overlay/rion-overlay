# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

AT_NOEAUTOMAKE=yes

inherit multilib toolchain-funcs git-r3 autotools

DESCRIPTION="Mail.Ru agent protocol for pidgin."
HOMEPAGE="http://code.google.com/p/mrim-prpl/"
EGIT_REPO_URI="https://bitbucket.org/mrim-prpl-team/mrim-prpl.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=">=net-im/pidgin-2.6"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/gettext
	dev-libs/check
"

# FIXME upstream build system is broken again: does not respect CC

src_prepare() {
	eautoreconf
}

src_install() {
	emake LIBDIR=$(get_libdir) DESTDIR="${D}" install
}
