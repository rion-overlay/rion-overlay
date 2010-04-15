# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils qt4-r2 confutils

DESCRIPTION="QStarDict is a StarDict clone written with using Qt"
HOMEPAGE="http://qstardict.ylsoftware.com/"
SRC_URI="http://qstardict.ylsoftware.com/files/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ia64 x86"

PLUGINS="stardict web"
IUSE_PLUGINS=""
for p in $PLUGINS; do IUSE_PLUGINS="${IUSE_PLUGINS} plugin_${p}"; done;
IUSE="dbus nls ${IUSE_PLUGINS}"

RDEPEND="x11-libs/qt-gui
	dbus? ( x11-libs/qt-dbus )
	dev-libs/glib:2"
DEPEND="${RDEPEND}"

pkg_setup() {
	confutils_require_any ${IUSE_PLUGINS}
}

src_prepare() {
	qt4-r2_src_prepare
	find "${S}" -name '*pr?' -exec sed "s:/lib:/$(get_libdir):" -i '{}' \;

	# fix gcc-4.4.1 compatibility
	sed 's/def Q_OS_WIN32/ defined(Q_OS_WIN32)/' \
		-i "${S}/plugins/stardict/dictziplib.cpp" || die "sed failed"
}

src_configure() {
	local eplugins=()
	for f in $PLUGINS; do
		use "plugin_${f}" && eplugins+=("${f}")
	done

	QMAKE_FLAGS=(ENABLED_PLUGINS="${eplugins[@]}")
	if ! use dbus; then
		QMAKE_FLAGS+=(NO_DBUS=1)
	fi
	if ! use nls; then
		QMAKE_FLAGS+=(NO_TRANSLATIONS=1)
	fi

	eqmake4 "${PN}".pro "${QMAKE_FLAGS[@]}"
}
