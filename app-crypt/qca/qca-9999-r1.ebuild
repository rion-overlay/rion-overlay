# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/qca/qca-2.0.2-r2.ebuild,v 1.6 2009/07/21 16:52:41 armin76 Exp $

EAPI="5"

inherit eutils multilib cmake-utils git-2

DESCRIPTION="Qt Cryptographic Architecture (QCA)"
HOMEPAGE="http://delta.affinix.com/qca/"
EGIT_REPO_URI="git://anongit.kde.org/qca"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS=""
IUSE="aqua debug doc examples +qt4 qt5 test"
RESTRICT="test"

RDEPEND="qt4? ( dev-qt/qtcore:4[debug?] )
	qt5? ( dev-qt/qtcore:5[debug?] )"
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
			-DCMAKE_INSTALL_PREFIX="${MYPREFIX}"
			"-DPKGCONFIG_INSTALL_PREFIX=${EPREFIX}/usr/$(get_libdir)/pkgconfig"
			-DQC_CERTSTORE_PATH="${EPREFIX}"/etc/ssl/certs/ca-certificates.crt
			-DQCA_MAN_INSTALL_DIR="${EPREFIX}/usr/share/man"
		)
		[ "$QT" = qt4 ] && mycmakeargs+=("-DQT4_BUILD=1")
		[ "$QT" = qt5 ] && mycmakeargs+=("-DQCA_SUFFIX=qt5")
		use test || mycmakeargs+=("-DBUILD_TESTS=OFF")
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
