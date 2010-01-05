# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# rion overlay; 


EAPI=2
inherit distutils

DESCRIPTION="Kerberos 5 Bindings for Python"
HOMEPAGE="http://pypi.python.org/pypi/python-krb5/0.2"
SRC_URI="http://pypi.python.org/packages/source/p/python-krb5/python-krb5-0.2.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=app-crypt/mit-krb5-1.3.0
		>=sys-libs/e2fsprogs-libs-1.41.3"
RDEPEND="${DEPEND}"
RESTRICT="mirror"
