# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/qca/qca-2.0.2-r2.ebuild,v 1.6 2009/07/21 16:52:41 armin76 Exp $

EAPI="5"

inherit eutils multilib cmake-utils

DESCRIPTION="Qt Cryptographic Architecture (QCA)"
HOMEPAGE="http://delta.affinix.com/qca/"
SRC_URI="http://delta.affinix.com/download/qca/2.0/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="aqua botan debug doc examples gpg gcrypt logger nss pkcs11 +qt4 qt5 sasl softstore ssl test"
RESTRICT="test"

RDEPEND="botan? ( dev-libs/botan )
	gpg? ( app-crypt/gnupg )
	gcrypt? ( dev-libs/libgcrypt )
	nss? ( dev-libs/nss )
	sasl? ( dev-libs/cyrus-sasl )
	ssl? ( dev-libs/openssl )
	pkcs11? ( dev-libs/pkcs11-helper )
	qt4? ( dev-qt/qtcore:4[debug?] )
	qt5? ( dev-qt/qtcore:5[debug?]
	       dev-qt/qtnetwork:5[debug?] )"
DEPEND="${RDEPEND} qt4? ( dev-qt/qttest:4[debug?] )
	qt5? ( dev-qt/qttest:5[debug?] )"
REQUIRED_USE="|| ( qt4 qt5 )"

wrap_stage() {
	stage=$1
	for qt in qt4 qt5; do
		use $qt && {
			BUILD_DIR="${WORKDIR}/${PN}-${qt}-build" \
			QT=$qt $stage
		}
	done
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
		)
		[ "$QT" = qt4 ] && mycmakeargs+=("-DQT4_BUILD=1")
		[ "$QT" = qt5 ] && mycmakeargs+=("-DQCA_SUFFIX=qt5")
		use test || mycmakeargs+=("-DBUILD_TESTS=OFF")
		use botan && mycmakeargs+=("-DWITH_botan_PLUGIN=yes")
		use gcrypt && mycmakeargs+=("-DWITH_gcrypt_PLUGIN=yes")
		use gpg && mycmakeargs+=("-DWITH_gnupg_PLUGIN=yes")
		use logger && mycmakeargs+=("-DWITH_logger_PLUGIN=yes")
		use nss && mycmakeargs+=("-DWITH_nss_PLUGIN=yes")
		use pkcs11 && mycmakeargs+=("-DWITH_pkcs11_PLUGIN=yes")
		use sasl && mycmakeargs+=("-DWITH_cyrus-sasl_PLUGIN=yes")
		use softstore && mycmakeargs+=("-DWITH_softstore_PLUGIN=yes")
		use ssl && mycmakeargs+=("-DWITH_ossl_PLUGIN=yes")
		#use wincrypto && mycmakeargs+=("-DWITH_wincrypto_PLUGIN=yes")
		cmake-utils_src_configure
	}
	wrap_stage my_configure
}

src_compile()
{
	wrap_stage cmake-utils_src_compile
}

src_test()
{
	wrap_stage enable_cmake-utils_src_test
}

src_install() {
	my_install() {
		cmake-utils_src_install
		dodoc README TODO || die "dodoc failed"

		if use doc; then
			dohtml "${S}"/apidocs/html/* || die "Failed to install documentation"
		fi

		if use examples; then
			insinto /usr/share/doc/${PF}/
			doins -r "${S}"/examples || die "Failed to install examples"
		fi
	}
	wrap_stage my_install
}
