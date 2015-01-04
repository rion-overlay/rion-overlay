# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit mercurial

DESCRIPTION="Simple script that controls whether (and with what vigor) ksm should search for duplicated pages"
HOMEPAGE="https://gitorious.org/ksm-control-scripts"
EHG_REPO_URI="https://andreis.vinogradovs@code.google.com/p/slepnoga.ksmtuned"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	dosbin ksmtuned

	newinitd ksm.initd ksm
	newinitd ksmtuned.initd ksmtuned

	newconfd ksm.sysconfig ksm

	insinto /etc
	doins ksmtuned.conf

	dodoc TODO
}
