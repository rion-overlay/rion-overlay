# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils

DESCRIPTION="A cross-platform IRC framework written with Qt"
HOMEPAGE="http://communi.github.io/"
SRC_URI="https://github.com/communi/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples icu qt4 qt5 qml test +uchardet"
REQUIRED_USE="^^ ( qt4 qt5 )"

RDEPEND="
	qt4? (
		dev-qt/qtcore:4
		qml? ( dev-qt/qtdeclarative:4 )
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtnetwork:5
		qml? ( dev-qt/qtdeclarative:5 )
	)
	icu? ( dev-libs/icu )
	uchardet? ( app-i18n/uchardet )"

DEPEND="${RDEPEND}
	test? (
		qt4? ( dev-qt/qttest:4 )
		qt5? ( dev-qt/qttest:5 )

	)"

src_prepare() {
	UCHD="${S}"/src/3rdparty/uchardet-0.0.1/uchardet.pri
	echo "CONFIG *= link_pkgconfig" > "$UCHD"
	echo "PKGCONFIG += uchardet" >> "$UCHD"
	
	use qml || sed -i -e '/SUBDIRS/s| imports||' ./src/src.pro
	
	eapply_user
}

src_configure() {
	myargs=(
		libcommuni.pro
		-config no_rpath
		-config $(use examples || echo "no_")examples
		-config $(use icu || echo "no_")icu
		-config $(use test || echo "no_")tests
		-config $(use uchardet || echo "no_")uchardet
	)

	use qt4 && eqmake4 "${myargs[@]}"
	use qt5 && eqmake5 "${myargs[@]}"
}

src_install() {
	emake install INSTALL_ROOT="${D}"
}
