# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/qca/qca-2.0.2-r2.ebuild,v 1.6 2009/07/21 16:52:41 armin76 Exp $

EAPI="5"

inherit eutils multilib multibuild cmake-utils git-2

DESCRIPTION="Qt Cryptographic Architecture (QCA)"
HOMEPAGE="http://delta.affinix.com/qca/"
EGIT_REPO_URI="git://anongit.kde.org/qca"

LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS=""
IUSE="botan debug doc examples gpg gcrypt logger nss pkcs11 +qt4 qt5 sasl softstore ssl test"
RESTRICT="test"

RDEPEND="
	!<app-crypt/qca-cyrus-sasl-2.1.0
	!<app-crypt/qca-gnupg-2.1.0
	!<app-crypt/qca-logger-2.1.0
	!<app-crypt/qca-ossl-2.1.0
	!<app-crypt/qca-pkcs11-2.1.0
	botan? ( dev-libs/botan )
	gcrypt? ( dev-libs/libgcrypt )
	gpg? ( app-crypt/gnupg )
	nss? ( dev-libs/nss )
	pkcs11? ( dev-libs/pkcs11-helper )
	qt4? ( dev-qt/qtcore:4[debug?] )
	qt5? ( dev-qt/qtcore:5[debug?]
	       dev-qt/qtnetwork:5[debug?] )
	sasl? ( dev-libs/cyrus-sasl )
	ssl? ( dev-libs/openssl )"

DEPEND="${RDEPEND} qt4? ( dev-qt/qttest:4[debug?] )
	qt5? ( dev-qt/qttest:5[debug?] )"

REQUIRED_USE="|| ( qt4 qt5 )"

DOCS=( README TODO )

qca_plugin_use() {
	echo "-DWITH_${2:-$1}_PLUGIN=$(use $1 && echo yes || echo no)"
}

pkg_setup() {
	MULTIBUILD_VARIANTS=()
	if use qt4; then
		MULTIBUILD_VARIANTS+=( qt4 )
	fi
	if use qt5; then
		MULTIBUILD_VARIANTS+=( qt5 )
	fi
}

src_configure()
{
	my_configure() {
		local mycmakeargs=(
			-DCMAKE_INSTALL_PREFIX=""
			-DPKGCONFIG_INSTALL_PREFIX="${EPREFIX}"/usr/$(get_libdir)/pkgconfig
			-DQCA_LIBRARY_INSTALL_DIR="${EPREFIX}"/usr/$(get_libdir)
			-DQC_CERTSTORE_PATH="${EPREFIX}"/etc/ssl/certs/ca-certificates.crt
			-DQCA_MAN_INSTALL_DIR="${EPREFIX}/usr/share/man"
			-DQCA_INCLUDE_INSTALL_DIR="${EPREFIX}"/usr/include
			-DBUILD_PLUGINS=none
			$(qca_plugin_use botan)
			$(qca_plugin_use gcrypt)
			$(qca_plugin_use gpg gnupg)
			$(qca_plugin_use logger)
			$(qca_plugin_use nss)
			$(qca_plugin_use pkcs11)
			$(qca_plugin_use sasl cyrus-sasl)
			$(qca_plugin_use softstore)
			$(qca_plugin_use ssl ossl)
			$(cmake-utils_use_build test TESTS)
		)
		[ "$MULTIBUILD_VARIANT" = qt4 ] && mycmakeargs+=("-DQT4_BUILD=1")
		[ "$MULTIBUILD_VARIANT" = qt5 ] && mycmakeargs+=("-DQCA_SUFFIX=qt5")

		cmake-utils_src_configure
	}
	multibuild_foreach_variant my_configure
}

src_compile()
{
	multibuild_foreach_variant cmake-utils_src_compile
}

src_test()
{
	multibuild_foreach_variant enable_cmake-utils_src_test
}

src_install() {
	multibuild_foreach_variant cmake-utils_src_install

	if use doc; then
		dohtml "${S}"/apidocs/html/*
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/
		doins -r "${S}"/examples
	fi
}
