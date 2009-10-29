# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit rpm
DESCRIPTION="Perl scripts intended for management of warios subsystem Dog-Tag CA"
HOMEPAGE="http://pki.fedoraproject.org"
SRC_URI="http://pki.fedoraproject.org/pki/download/pki/1.2.0/fc11/SRPMS/pki-setup-1.2.0-1.fc11.src.rpm"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
DEPEND="dev-lang/perl
		pki-dev/pki-setup"

RDEPEND="${DEPEND}"

src_install() {
	dobin "${S}"/pki{common,create,host,remove}
}
