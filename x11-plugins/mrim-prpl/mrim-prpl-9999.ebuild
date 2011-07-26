# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit multilib toolchain-funcs subversion

DESCRIPTION="Mail.Ru agent protocol for pidgin."
HOMEPAGE="http://code.google.com/p/mrim-prpl/"
ESVN_REPO_URI="http://mrim-prpl.googlecode.com/svn/trunk/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=">=net-im/pidgin-2.6"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/gettext
"

# FIXME upstream build system is broken again
src_compile() {
	emake CC="$(tc-getCC)" compile
}

src_install() {
	emake LIBDIR=$(get_libdir) DESTDIR="${D}" install
}
