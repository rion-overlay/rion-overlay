# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils qt4
DESCRIPTION="QStarDict is a StarDict clone written with using Qt"
HOMEPAGE="http://qstardict.ylsoftware.com/"
SRC_URI="http://qstardict.ylsoftware.com/files/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ia64"

PLUGINS="stardict web"
IUSE="dbus nls"
for p in $PLUGINS; do IUSE="${IUSE} plugin_${p}"; done;

RDEPEND="x11-libs/qt-core
		x11-libs/qt-gui
		dbus? ( x11-libs/qt-dbus )
		dev-libs/glib:2"
DEPEND="${RDEPEND}"

src_prepare() {
	find "${WORKDIR}" -name '*pr?' -exec sed "s:/lib:/$(get_libdir):" -i '{}' \;

	# fix gcc-4.4.1 compatibility
	sed 's/def Q_OS_WIN32/ defined(Q_OS_WIN32)/' -i plugins/stardict/dictziplib.cpp
}

src_compile() {
	QMAKE_FLAGS=""
	if ! use dbus; then
		QMAKE_FLAGS+="NO_DBUS=1 "
	fi
	if ! use nls; then
		QMAKE_FLAGS+="NO_TRANSLATIONS=1 "
	fi
	eplugins=""
	for f in $PLUGINS; do
		use "plugin_${f}" && eplugins="${eplugins} ${f}"
	done
	[ "${eplugins}" == "" ] && die "Enable atleast one plugin"

	eqmake4 "${PN}".pro $QMAKE_FLAGS ENABLED_PLUGINS="${eplugins}" || die "qmake failed"
	emake || die "emake failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake install filed"
}
