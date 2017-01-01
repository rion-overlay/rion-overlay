# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit qt4-r2 subversion

DESCRIPTION="Vector metro (subway) map for calculating route and getting information about transport nodes."
HOMEPAGE="http://sourceforge.net/projects/qmetro/"
ESVN_REPO_URI="https://qmetro.svn.sourceforge.net/svnroot/qmetro"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug"

RDEPEND="
	dev-qt/qtgui:4
"
DEPEND="${RDEPEND}"

DOCS="AUTHORS README"
