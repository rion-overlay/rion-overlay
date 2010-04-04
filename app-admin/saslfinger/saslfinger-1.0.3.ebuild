# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="saslfinger is a bash utility script that seeks to help you debugging your SMTP AUTH setup."
HOMEPAGE="http://postfix.state-of-mind.de/patrick.koetter/saslfinger/"
SRC_URI="http://postfix.state-of-mind.de/patrick.koetter/${PN}/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	app-shells/bash"

src_install() {
	dobin saslfinger
	dohtml index.html
	dodoc ChangeLog INSTALL TODO
	doman saslfinger.1
}
