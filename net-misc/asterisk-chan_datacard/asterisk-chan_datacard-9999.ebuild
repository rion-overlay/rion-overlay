# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Author: mva $
EAPI="2"

inherit eutils subversion

DESCRIPTION="Datacard channel for Asterisk."
ESVN_REPO_URI="https://www.makhutov.org/svn/chan_datacard/trunk"
HOMEPAGE="http://www.makhutov.org/"
KEYWORDS="~amd64"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND=">=net-misc/asterisk-1.6.2.0
	dev-libs/libxml2
	sys-libs/ncurses"
DEPEND="${RDEPEND}"

src_install() {
insinto /usr/lib/asterisk/modules
doins "${PN/*-/}.so"
}