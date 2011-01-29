# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="python? 2:2.6"
RESTRICT="userpriv"
inherit python confutils multilib pam linux-info

DESCRIPTION="System Security Services Daemon - provide access to identity and authentication"
HOMEPAGE="http://fedorahosted.org/sssd/"
SRC_URI="http://fedorahosted.org/released/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls doc test +nscd +locator openssl logrotate python"

COMMON_DEP="virtual/pam
	dev-libs/popt
	>=dev-libs/ding-libs-0.1.2
	sys-libs/talloc
	sys-libs/tdb
	sys-libs/tevent
	sys-libs/ldb
	net-nds/openldap
	dev-libs/libpcre
	app-crypt/mit-krb5
	net-dns/c-ares
	openssl? ( dev-libs/openssl )
	!openssl? ( dev-libs/nss )
	nscd? ( sys-libs/glibc )
	net-dns/bind-tools
	dev-libs/cyrus-sasl
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

pkg_setup(){
	python_set_active_version 2

		if kernel_is 2 4; then
			echo
			eerror "This package reqires"
			eerror "Linux kernel >=2.6.0"
			ewarn "You enabled keyutils use-flag"
			ewarn "If You want to build this package on 2.4 series kernel,"
			ewarn "disable keytils use-flag"
		fi

		linux-info_pkg_setup

#	confutils_use_depend_all semanage selinux
}

src_configure(){
	econf \
		--localstatedir=/"${EPREFIX}"/var \
		--enable-nsslibdir=/"${EPREFIX}"/$(get_libdir) \
		--enable-pammoddir=/"${EPREFIX}"/$(getpam_mod_dir) \
		--without-selinux \
		--without-semanage \
		--disable-static --enable-shared \
		$(use_with python python-bindings) \
		$(use_with nscd) \
		$(use_enable locator krb5-locator-plugin) \
		$(use_enable openssl crypto) \
		$(use_enable nls) \
		-C  || die "econf failed"
}

src_install(){
	emake DESTDIR="${ED}" install || die

	#delete la files
	find "${ED}"/$(get_libdir) -name \*.la -delete
	find "${ED}"/$(getpam_mod_dir) -name \*.la -delete

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
	dodoc README

}

src_test() {
	emake check ||die
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
