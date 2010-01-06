# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# rion overlay

EAPI=2
inherit rpm distutils

DESCRIPTION="python-krbV allows python programs to use Kerberos 5 authentication/security"
HOMEPAGE="http://people.redhat.com/mikeb/python-krbV"
SRC_URI="mirror://fedora-dev/development/source/SRPMS/python-krbV-1.0.13-10.fc12.src.rpm"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

NEED_PYTHON=2.4

DEPEND=">=app-crypt/mit-krb5-1.1.2
		>=sys-libs/e2fsprogs-libs-1.41.3-r1"
RDEPEND="${DEPEND}"

src_unpack(){
rpm_src_unpack
}

src_prepare(){
	cp "${FILESDIR}"/setup.py "${S}"  || die "Failed copy setup.py"

	awk -f gendefines.awk /usr/include/krb5.h > krb5defines.h || die \
														"awk failed"
	distutils_src_prepare
}
src_install(){

	dodoc AUTHORS INSTALL README NEWS || die
	dodoc krbV-code-snippets.py || die
	distutils_src_install
}
pkg_postinst() { distutils_pkg_postinst ; }
pkg_postrm() { distutils_pkg_postrm ; }
