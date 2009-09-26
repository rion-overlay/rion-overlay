# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/qca/qca-2.0.2-r2.ebuild,v 1.6 2009/07/21 16:52:41 armin76 Exp $

EAPI="2"

inherit eutils multilib qt4 subversion

DESCRIPTION="Qt Cryptographic Architecture (QCA)"
HOMEPAGE="http://delta.affinix.com/qca/"
ESVN_REPO_URI="svn://websvn.kde.org:443/home/kde/trunk/kdesupport/qca"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS=""
IUSE="debug doc examples"
RESTRICT="test"

DEPEND="sys-devel/qconf
		x11-libs/qt-core:4[debug?]"
RDEPEND="${DEPEND}
	!<app-crypt/qca-1.0-r3:0
"

src_prepare() {
	qconf
	epatch "${FILESDIR}"/${P}-pcfilespath.patch
}

src_configure() {
	_libdir=$(get_libdir)

	./configure \
		--prefix=/usr \
		--qtdir=/usr \
		--includedir="/usr/include/qca2" \
		--libdir="/usr/${_libdir}/qca2" \
		--no-separate-debug-info \
		--disable-tests \
		--$(use debug && echo debug || echo release) \
		|| die "configure failed"

	eqmake4
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake install failed"
	dodoc README TODO || die "dodoc failed"

	cat <<-EOF > "${WORKDIR}"/44qca2
	LDPATH=/usr/${_libdir}/qca2
	EOF
	doenvd "${WORKDIR}"/44qca2 || die

	if use doc; then
		dohtml "${S}"/apidocs/html/* || die "Failed to install documentation"
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/
		doins -r "${S}"/examples || die "Failed to install examples"
	fi
}
