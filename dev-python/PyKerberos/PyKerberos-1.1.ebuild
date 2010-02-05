# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit distutils

DESCRIPTION="A high-level Python wrapper for Kerberos (GSSAPI) operations"
HOMEPAGE="http://trac.calendarserver.org/browser/PyKerberos"
SRC_URI="http://honk.sigxcpu.org/projects/pykerberos/PyKerberos-1.1.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="app-crypt/mit-krb5"
RDEPEND="${DEPEND}"

python_need_rebuild
