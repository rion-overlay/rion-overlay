# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

EAPI="2"

inherit git

DESCRIPTION="Programmable Completion for zsh (includes emerge and ebuild commands)"
HOMEPAGE="http://git.overlays.gentoo.org/gitweb/?p=proj/zsh-completion.git"
EGIT_REPO_URI="git://git.overlays.gentoo.org/proj/zsh-completion.git"
EGIT_TREE="HEAD" # SHA1 id

LICENSE="ZSH"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="${DEPEND}"
DEPEND="app-shells/zsh"

src_install() {
	insinto /usr/share/zsh/site-functions
	doins _*

	dodoc AUTHORS
}

pkg_postinst() {
	elog
	elog "If you happen to compile your functions, you may need to delete"
	elog "~/.zcompdump{,.zwc} and recompile to make zsh-completion available"
	elog "to your shell."
	elog
}
