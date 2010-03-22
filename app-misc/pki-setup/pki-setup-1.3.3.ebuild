# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="Dogtag Certificate system - PKI Instance Creation and Removal Scripts"
HOMEPAGE="http://pki.fedoraproject.org"
SRC_URI="http://pki.fedoraproject.org/pki/sources/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-perl/XML-LibXML
		dev-perl/libwww-perl
		dev-perl/Crypt-SSLeay
		dev-perl/XML-SAX
		app-misc/pki-native-tools"

RDEPEND="${DEPEND}"

src_install() {
	dobin "${S}"/pki{common,create,host,remove}
}
