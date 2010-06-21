# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit cmake-utils git

DESCRIPTION="A new xmpp transport based on libpurple"
HOMEPAGE="http://spectrum.im"

EGIT_PROJECT="spectrum"
EGIT_REPO_URI="git://github.com/hanzz/${EGIT_PROJECT}.git"
EGIT_TREE="master"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-libs/poco[sqlite]
	>=net-im/pidgin-2.6.0
	>=net-libs/gloox-1.0
	|| (
		dev-libs/poco[mysql]
		dev-libs/poco[sqlite]
	)"
DEPEND="${RDEPEND}
	sys-devel/gettext"

src_install () {
	cmake-utils_src_install

	#install init scripts and configs
	insinto /etc/spectrum
	for protocol in msn yahoo facebook icq myspace gg aim simple irc; do
		sed -e 's,SPECTRUMGEN2PROTOCOL,'${protocol}',g' "${FILESDIR}/spectrum.cfg" > "${WORKDIR}/spectrum-${protocol}.cfg" || die
		doins "${WORKDIR}/spectrum-${protocol}.cfg" || die

		sed -e 's,SPECTRUMGEN2PROTOCOL,'${protocol}',g' "${FILESDIR}/spectrum.init" > "${WORKDIR}/spectrum-${protocol}" || die
		doinitd "${WORKDIR}/spectrum-${protocol}" || die
	done
}
