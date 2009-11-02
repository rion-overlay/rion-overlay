# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

RPM_REV="-1"
inherit pki-dogtag

DESCRIPTION="Perl scripts intended for management of warios subsystem Dog-Tag CA"

KEYWORDS="~amd64"
IUSE=""
DEPEND="dev-lang/perl
		pki-dev/pki-setup"

RDEPEND="${DEPEND}"

src_install() {
	dobin "${S}"/pki{common,create,host,remove}
}
