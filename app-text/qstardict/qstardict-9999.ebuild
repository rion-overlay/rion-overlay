# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="6"

case $PV in *9999*) VCS_ECLASS="git-r3" ;; *) VCS_ECLASS="" ;; esac

inherit eutils qmake-utils confutils ${VCS_ECLASS}

DESCRIPTION="QStarDict is a StarDict clone written with using Qt"
HOMEPAGE="http://qstardict.ylsoftware.com/"
LICENSE="GPL-2"
if [ -n "${VCS_ECLASS}" ]; then
	KEYWORDS=""
	EGIT_REPO_URI="https://github.com/a-rodin/qstardict"
else
	S="${WORKDIR}/${PN}-${P}"
	KEYWORDS="amd64 ~ia64 x86"
	SRC_URI="https://github.com/a-rodin/qstardict/archive/${P}.zip"
fi
SLOT="0"

PLUGINS="stardict swac web"
IUSE_PLUGINS=""
for p in $PLUGINS; do IUSE_PLUGINS="${IUSE_PLUGINS} plugin_${p}"; done;
IUSE="dbus debug kde nls ${IUSE_PLUGINS} qt4 qt5"
REQUIRED_USE="|| ( ${IUSE_PLUGINS} )
	|| ( qt4 qt5 )
	kde ( qt5 )"

DEPEND="dev-qt/qtgui:=
	dbus? ( dev-qt/qtdbus:= )
	dev-libs/glib:2
	plugin_swac? ( dev-qt/qtsql:= )
	kde? (
		kde-frameworks/kwindowsystem
	)
	"
RDEPEND="${RDEPEND}"

src_configure() {
	eplugin() {
		[ -f plugins/${1}/${1}.pro ] && eplugins+=("${1}")
	}
	
	local eplugins=()
	use kde && eplugin kdeintegration
	for f in $PLUGINS; do
		use "plugin_${f}" && eplugin $f
	done

	QMAKE_FLAGS=(
		ENABLED_PLUGINS="${eplugins[@]}"
		LIB_DIR="${EPREFIX}/usr/$(get_libdir)/${PN}"
	)
	if ! use dbus; then
		QMAKE_FLAGS+=(NO_DBUS=1)
	fi
	if ! use nls; then
		QMAKE_FLAGS+=(NO_TRANSLATIONS=1)
	fi

	use qt4 && eqmake4 "${PN}".pro "${QMAKE_FLAGS[@]}"
	use qt5 && eqmake5 "${PN}".pro "${QMAKE_FLAGS[@]}"
}

src_install() {
	emake install INSTALL_ROOT="${D}"
	einstalldocs
}
