# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI=3

PYTHON_DEPEND="python? 2:2.6"

inherit base python multilib pam linux-info autotools-utils git-2

DESCRIPTION="System Security Services Daemon provides access to identity and authentication"
HOMEPAGE="http://fedorahosted.org/sssd/"
EGIT_REPO_URI="git://git.fedorahosted.org/sssd.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="doc +locator logrotate nls python selinux static-libs test"

COMMON_DEP="virtual/pam
	dev-libs/popt
	>=dev-libs/libunistring-0.9.3
	>=dev-libs/ding-libs-0.1.2
	>=sys-libs/talloc-2.0
	sys-libs/tdb
	sys-libs/tevent
	sys-libs/ldb
	>=net-nds/openldap-2.4.19
	dev-libs/libpcre
	>=app-crypt/mit-krb5-1.9.1
	>=net-dns/c-ares-1.7.4
	>=dev-libs/nss-3.12.9
	selinux? ( >=sys-libs/libselinux-2.0.94 >=sys-libs/libsemanage-2.0.45 )
	net-dns/bind-tools
	dev-libs/cyrus-sasl
	sys-apps/dbus
	>=sys-devel/gettext-0.17
	virtual/libintl
	dev-libs/libnl"

RDEPEND="${COMMON_DEP}"
DEPEND="${COMMON_DEP}
	test? ( dev-libs/check )
	>=dev-libs/libxslt-1.1.26
	app-text/docbook-xml-dtd:4.4
	doc? ( app-doc/doxygen )"

CONFIG_CHECK="~KEYS"
#AUTOTOOLS_IN_SOURCE_BUILD=1
PATCHES=("${FILESDIR}"/allow_xdm.patch)

pkg_setup(){
	python_set_active_version 2
	python_need_rebuild
	linux-info_pkg_setup
}

src_prepare() {
	base_src_prepare
	eautopoint
	eautoreconf
}

src_configure(){
	local myeconfargs=(
		--localstatedir="${EPREFIX}"/var
		--enable-nsslibdir="${EPREFIX}"/$(get_libdir)
		--with-plugin-path="${EPREFIX}"/usr/$(get_libdir)/sssd
		--enable-pammoddir="${EPREFIX}"/$(getpam_mod_dir)
		--with-ldb-lib-dir="${EPREFIX}"/usr/$(get_libdir)/ldb/modules/ldb
		--with-libnl
		--without-nscd
		$(use_with selinux)
		$(use_with selinux semanage)
		$(use_with python python-bindings)
		$(use_enable locator krb5-locator-plugin)
		$(use_enable nls ) )

	autotools-utils_src_configure
}

src_install(){
	autotools-utils_src_install

	rm "${ED}/$(get_libdir)/"libnss_sss.la || die
	rm "${ED}/usr/$(get_libdir)/"ldb/modules/ldb/*.la || die

	insinto /etc/sssd
	insopts -m600
	doins "${S}"/src/examples/sssd-example.conf

	if use logrotate; then
		insinto /etc/logrotate.d
		insopts -m644
		newins "${S}"/src/examples/logrotate sssd
	fi

	if use python; then
		python_clean_installation_image
		python_convert_shebangs 2 "${ED}$(python_get_sitedir)/"*.py
	fi
}

src_test() {
	autotools-utils_src_test
}

pkg_postinst(){
	elog "You must set up sssd.conf (default installed into /etc/sssd)"
	elog "and (optionally) configuration in /etc/pam.d in order to use SSSD"
	elog "features. Please see howto in	http://fedorahosted.org/sssd/wiki/HOWTO_Configure_1_0_2"

	use python && python_need_rebuild
	use python && python_mod_optimize SSSDConfig.py ipachangeconf.py
}

pkg_postrm() {
	use python && python_mod_cleanup SSSDConfig.py ipachangeconf.py
}
