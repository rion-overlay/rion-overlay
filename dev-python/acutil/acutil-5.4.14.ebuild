# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
WANT_AUTOMAKE="1.11"
NEED_PYTHON="2.5"

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
python_need_rebuild

src_prepare() {
	python_set_active_version 2
	eautoreconf
}

src_install() {
	insinto /$(python_get_sitedir)
	doins "${S}"/.libs/acutil*
}
pkg_postrm() {
	python_mod_cleanup
}
