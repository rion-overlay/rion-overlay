# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="2:2.6"
inherit  distutils

DESCRIPTION="python-krbV allows python programs to use Kerberos 5 authentication/security"
HOMEPAGE="http://people.redhat.com/mikeb/python-krbV"
SRC_URI="https://fedorahosted.org/python-krbV/attachment/wiki/Releases/${P}.tar.bz2?format=raw -> ${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=app-crypt/mit-krb5-1.1.2
		>=sys-libs/e2fsprogs-libs-1.41.3-r1"
RDEPEND="${DEPEND}"

DOCS="AUTHORS INSTALL README NEWS krbV-code-snippets.py"

pkg_setup() {
	# Don't support python3
	python_set_active_version 2
	python_pkg_setup
}

src_prepare(){
	cp "${FILESDIR}"/setup.py "${S}"  || die "Failed copy setup.py"
	awk -f gendefines.awk /usr/include/krb5.h > krb5defines.h || die "awk failed"
	rm -f configure
}
