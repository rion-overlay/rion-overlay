# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

NEED_PYTHON="2.4"

SUPPORT_PYTHON_ABIS="1"

inherit autotools python

# Revision of the RPM. Shouldn't affect us, as we're just grabbing the source
# tarball out of it

DESCRIPTION="Tool for setting up authentication from network services"
HOMEPAGE="http://fedoraproject.org/wiki/SystemConfig/"
SRC_URI="https://fedorahosted.org/releases/a/u/authconfig/authconfig-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
RDEPEND="dev-perl/XML-Parser
	!app-admin/authconfig"

DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/intltool"
RESTRICT_PYTHON_ABIS="3.*"

S="${WORKDIR}"/authconfig-"${PV}"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-Makefile.patch
	eautoreconf
}

src_configure() {
	default
}

src_install() {
	dodir /$(python_get_sitedir)/
	insinto /$(python_get_sitedir)
	doins "${S}"/.libs/acutil*
}
pkg_postrm() {
	python_mod_cleanup
}
