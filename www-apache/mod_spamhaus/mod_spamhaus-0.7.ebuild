# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit apache-module

DESCRIPTION="mod_spamhaus is module that use DNSBL in order to block spam relay via web forms"
HOMEPAGE="http://sourceforge.net/projects/mod-spamhaus"
LICENSE="GPL-3"
SRC_URI="mirror://sourceforge/project/mod-spamhaus/mod-spamhaus/0.7/mod-spamhaus-0.7.tar.gz"
KEYWORDS="~amd64 ~x86"
IUSE=""
SLOT="0"

APACHE2_MOD_CONF="99_${PN}"
APACHE2_MOD_DEFINE="SPAMHAUS"
DOCFILES="ReadMe.txt"

S="${WORKDIR}"/mod-spamhaus

need_apache2
