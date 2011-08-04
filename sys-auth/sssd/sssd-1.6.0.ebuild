# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="python? 2:2.6"
RESTRICT="userpriv"

inherit python multilib pam linux-info autotools-utils

DESCRIPTION="System Security Services Daemon - provide access to identity and authentication"
HOMEPAGE="http://fedorahosted.org/sssd/"
SRC_URI="http://fedorahosted.org/released/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls doc test +nscd +locator openssl logrotate python static-libs"

COMMON_DEP="virtual/pam
	dev-libs/popt
	>=dev-libs/ding-libs-0.1.2
	sys-libs/talloc
	>=sys-libs/tdb-1.1.3
	sys-libs/tevent
	>=sys-libs/ldb-0.9.3
	>=net-nds/openldap-2.4.19
	dev-libs/libpcre
	dev-libs/libunistring
	app-crypt/mit-krb5
	net-dns/c-ares
	openssl? ( dev-libs/openssl )
	!openssl? ( dev-libs/nss )
	nscd? ( sys-libs/glibc )
	net-dns/bind-tools
	dev-libs/cyrus-sasl[kerberos]
	sys-apps/dbus
	>=sys-devel/gettext-0.17
	virtual/libintl
	dev-libs/libnl"

RDEPEND="${COMMON_DEP}"
DEPEND="${COMMON_DEP}
	test? ( dev-libs/check )
	dev-libs/libxslt
	app-text/docbook-xml-dtd:4.4
	doc? ( app-doc/doxygen )"

CONFIG_CHECK="~KEYS"
AUTOTOOLS_IN_SOURCE_BUILD=1
DOCS=(README)

pkg_setup(){
	python_set_active_version 2

	linux-info_pkg_setup

#	confutils_use_depend_all semanage selinux
}

src_paarepare() {
	eautoreconf
}

src_configure(){

	local myeconfargs=(
		--localstatedir=/"${EPREFIX}"/var \
		--enable-nsslibdir=/"${EPREFIX}"/$(get_libdir) \
		--enable-pammoddir=/"${EPREFIX}"/$(getpam_mod_dir) \
		--without-selinux \
		--without-semanage \
		--with-libnl \
		$(use_with python python-bindings) \
		$(use_with nscd) \
		$(use_enable locator krb5-locator-plugin) \
		$(use_enable openssl crypto) \
		$(use_enable nls) )

	autotools-utils_src_configure
}

src_install(){

	autotools-utils_src_install

	rm  "${D}/lib64/"libnss_sss.la || die

	insinto /"${EPREFIX}"/etc/sssd
	insopts -m600
	doins "${S}"/src/examples/sssd.conf

	if use logrotate; then
		insinto /"${EPREFIX}"/etc/logrotate.d
		insopts -m644
		newins "${S}"/src/examples/logrotate sssd
	fi

	if use python; then
		python_clean_installation_image

		python_convert_shebangs 2 "${ED}$(python_get_sitedir)/"*.py
	fi

}

src_test() {
	CK_TIMEOUT_MULTIPLIER=10	autotools-utils_src_test
}

pkg_postinst(){
	elog "You must change your /etc/pam.d if you want to use sssd authorization via PAM"
	elog "Changes look like these:"
	elog "auth        sufficient  pam_unix.so try_first_pass likeauth nullok"
	elog "auth        sufficient  pam_sss.so use_first_pass"
	elog "auth        required    pam_deny.so"
	echo
	elog "account     required    pam_unix.so"
	elog "account     [default=bad success=ok user_unknown=ignore] pam_sss.so"
	elog "account     required    pam_permit.so"
	echo
	elog "password    sufficient  pam_unix.so try_first_pass use_authtok nullok sha512 shadow"
	elog "password    sufficient  pam_sss.so use_authtok"
	elog "password    required    pam_deny.so"
	elog
	elog "session     sufficient  pam_sss.so"
	elog "session     required    pam_unix.so"
	echo
	echo
	elog "Also, if you want use sssd with NSS, you must add 'sss' to entries in"
	elog "/etc/nsswitch.conf. For exmaple:"
	elog "passwd:      compat sss"

	use python && python_need_rebuild

	use python && python_mod_optimize SSSDConfig.py ipachangeconf.py
}

pkg_postrm() {
	use python && python_mod_cleanup SSSDConfig.py ipachangeconf.py
}
