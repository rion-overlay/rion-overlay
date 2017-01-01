# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit qmake-utils git-r3

DESCRIPTION="Set of tools from Aseman-Land"
HOMEPAGE="https://github.com/Aseman-Land/aseman-qt-tools"
EGIT_REPO_URI="https://github.com/Aseman-Land/aseman-qt-tools.git"
RESTRICT="mirror"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtsql:5
	dev-qt/qtdbus:5
	dev-qt/qtmultimedia:5[qml]
	dev-qt/qtgraphicaleffects:5
	dev-qt/qtgui:5
	dev-qt/qtquickcontrols:5
	dev-qt/qtpositioning:5
	dev-qt/qtsensors:5
	dev-libs/qtkeychain[qt5]
"
RDEPEND="${DEPEND}"

S="${S}"/build

src_unpack(){
	git-r3_src_unpack
	mkdir "${S}"
}

src_configure(){
	eqmake5 QT+=widgets QT+=multimedia QT+=dbus QT+=sensors QT+=positioning ../asemantools.pro
}

src_install(){
	emake INSTALL_ROOT="${D}" install
}
