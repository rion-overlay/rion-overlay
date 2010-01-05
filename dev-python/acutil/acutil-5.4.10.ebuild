# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# This is part authconfig package
#based on authconfig-5.3.5.ebuild,v1.5 2007/10/15 09:36:28 dberkholz 

EAPI=2

inherit autotools python rpm

# Revision of the RPM. Shouldn't affect us, as we're just grabbing the source
# tarball out of it
RPMREV="1.fc11"

RESTRICT="mirror"
DESCRIPTION="Tool for setting up authentication from network services"
HOMEPAGE="http://fedoraproject.org/wiki/SystemConfig/"
SRC_URI="ftp://sunsite.informatik.rwth-aachen.de/pub/Linux/fedora/linux/releases/11/Fedora/source/SRPMS/authconfig-"${PV}"-${RPMREV}.src.rpm"
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
