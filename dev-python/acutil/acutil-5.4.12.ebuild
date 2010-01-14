# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# This is part authconfig package

EAPI=2

NEED_PYTHON="2.5"
SUPPORT_PYTHON_ABIS="1"

inherit autotools python

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

S="${WORKDIR}"/authconfig-"${PV}"
RESTRICT_PYTHON_ABIS="3.*"

src_prepare() {
	eautoreconf
}

src_install() {
	insinto /$(python_get_sitedir)
	doins "${S}"/.libs/acutil*
}
pkg_postrm() {
	python_mod_cleanup
}
