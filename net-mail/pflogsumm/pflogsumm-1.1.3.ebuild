# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Pflogsumm is a log analyzer for Postfix logs"
HOMEPAGE="http://jimsun.linxnet.com/postfix_contrib.html"
SRC_URI="http://jimsun.linxnet.com/downloads/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"

IUSE=""
KEYWORDS="~amd64 ~x86"
DEPEND="dev-lang/perl
		dev-perl/Date-Calc
		virtual/perl-Getopt-Long"

src_install() {
	dodoc README ToDo ChangeLog pflogsumm-faq.txt
	doman pflogsumm.1
	dobin pflogsumm.pl
}
