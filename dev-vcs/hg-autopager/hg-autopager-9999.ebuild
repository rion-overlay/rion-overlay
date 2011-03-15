# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit mercurial python

EAPI=3
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4 3.* *-jython"

DESCRIPTION="Autopager extension for Mercurial SCM"
HOMEPAGE="http://bitheap.org/hg/autopager/"
SRC_URI=""

EHG_REPO_URI="http://bitheap.org/hg/autopager/"

LICENSE="as-is"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-vcs/mercurial"
RDEPEND="${DEPEND}"

src_prepare() {
	rm LICENSE.txt
	python_copy_sources
}

src_install() {
	dumb_install() {
		insinto $(python_get_sitedir)
		doins autopager.py
	}
	python_execute_function dumb_install
}

