# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2:2.6"

inherit autotools autotools-utils python mercurial

DESCRIPTION="The libuser library implements a standardized interface for manipulating user and group accounts."
HOMEPAGE="https://fedorahosted.org/libuser"
EHG_REPO_URI="http://hg.fedorahosted.org/hg/libuser/"

LICENSE="GPL-2"
KEYWORDS=""
SLOT="0"
IUSE="ldap +popt sasl selinux nls"

COMMON_DEPEND="dev-libs/glib:2
	>=sys-devel/gettext-0.17
	virtual/pam
	ldap? ( net-nds/openldap )
	popt? ( dev-libs/popt )
	sasl? ( dev-libs/cyrus-sasl
		  ldap? ( net-nds/openldap[sasl] ) )
	selinux? ( sys-libs/libselinux )"

DEPEND="
	sys-devel/bison
	dev-util/gtk-doc
	${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

DOCS=(README NEWS TODO)

AUTOTOOLS_IN_SOURCE_BUILD=1

pkg_setup() {
	python_set_active_version 2
	python_need_rebuild
}

src_unpack() {
	mercurial_src_unpack
}

src_prepare() {
	#mkdir -p ${S}/{m4,admin}
	#gtkdocize --docdir docs/reference
	#_elibtoolize --install --force
	#eautopoint
	#eautoreconf

	eautopoint
	gtkdocize --docdir docs/reference
	eautoreconf

}

src_configure() {

	local myeconfargs=(
		$(use_with ldap)
		$(use_with popt)
		$(use_with sasl)
		$(use_with selinux)
		$(use_enable nls)
		--with-python
		--disable-rpath
		--disable-gtk-doc-html )
	autotools-utils_src_configure
}

src_test() {
	if has_version net-nds/openldap minimal ; then
		ewarn "Test require build net-nds/openldap without minimal use flag"
	fi
	default
}

src_install() {
	strip-linguas -i po

	autotools-utils_src_install "LINGUAS=""${LINGUAS}"""
	remove_libtool_files all
}
