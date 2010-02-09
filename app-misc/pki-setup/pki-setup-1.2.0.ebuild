# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

RPM_REV="-1"
inherit pki-dogtag

DESCRIPTION="Perl scripts intended for management of warios subsystem Dog-Tag CA"

KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND=">=app-misc/pki-native-tools-1.2.0
		dev-perl/XML-LibXML
		dev-perl/libwww-perl
		dev-perl/Crypt-SSLeay
		dev-perl/XML-SAX"
RDEPEND="${DEPEND}"

src_install() {
	dobin "${S}"/pki{common,create,host,remove}
}
