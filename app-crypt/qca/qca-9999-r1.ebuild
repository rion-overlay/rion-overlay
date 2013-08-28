# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/qca/qca-2.0.2-r2.ebuild,v 1.6 2009/07/21 16:52:41 armin76 Exp $

EAPI="2"

inherit eutils multilib cmake-utils git-2

DESCRIPTION="Qt Cryptographic Architecture (QCA)"
HOMEPAGE="http://delta.affinix.com/qca/"
EGIT_REPO_URI="git://anongit.kde.org/qca"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS=""
IUSE="aqua debug doc examples qt4 qt5"
RESTRICT="test"

DEPEND="dev-qt/qtcore:4[debug?]"
RDEPEND="dev-qt/qtcore:4[debug?]"

src_prepare() {
	use aqua && sed -i \
		-e "s|QMAKE_LFLAGS_SONAME =.*|QMAKE_LFLAGS_SONAME = -Wl,-install_name,|g" \
		src/src.pro

	use qt4 && MYCMAKEARGS+="-DQT4_BUILD=1"

	cmake-utils_src_prepare
}

#src_configure() {
#	use prefix || EPREFIX=
#
#	_libdir=$(get_libdir)
#
#	# Ensure proper rpath
#	export EXTRA_QMAKE_RPATH="${EPREFIX}/usr/${_libdir}/qca2"
#	qconf
#	./configure \
#		--prefix="${EPREFIX}"/usr \
#		--qtdir="${EPREFIX}"/usr \
#		--includedir="${EPREFIX}"/usr/include/qca2 \
#		--libdir="${EPREFIX}"/usr/${_libdir}/qca2 \
#		--certstore-path="${EPREFIX}"/etc/ssl/certs/ca-certificates.crt \
#		--no-separate-debug-info \
#		--disable-tests \
#		--$(use debug && echo debug || echo release) \
#		--no-framework \
#		|| die "configure failed"
#
#	eqmake4
#}

src_install() {
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
