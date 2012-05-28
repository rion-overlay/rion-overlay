# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Pidgin GPG/OpenPGP (XEP-0027) plugin"
HOMEPAGE="https://github.com/segler-alex/Pidgin-GPG"
SRC_URI="https://github.com/downloads/segler-alex/Pidgin-GPG/pidgin-gpg-0.9.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-crypt/gpgme
	net-im/pidgin"
DEPEND="${RDEPEND}"

src_install() {
	emake DESTDIR="${D}" install
}
