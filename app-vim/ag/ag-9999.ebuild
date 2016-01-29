# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

#VIM_PLUGIN_VIM_VERSION="7.0"
inherit vim-plugin git-2

DESCRIPTION="vim plugin: the_silver_searcher integration"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=4450"
LICENSE="as-is"
KEYWORDS=""
EGIT_REPO_URI="https://github.com/rking/ag.vim.git git://github.com/rking/ag.vim.git"
IUSE=""

VIM_PLUGIN_HELPFILES="${PN}"

src_prepare() {
	rm Rakefile
}
