# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils qt4 multilib confutils

DESCRIPTION="QStarDict is a StarDict clone written with using Qt"
HOMEPAGE="http://qstardict.ylsoftware.com/"
SRC_URI="http://qstardict.ylsoftware.com/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ia64"

PLUGINS="stardict web"
IUSE="dbus nls"
for p in $PLUGINS; do IUSE="${IUSE} plugin_${p}"; done;

RDEPEND="x11-libs/qt-core:4
	x11-libs/qt-gui:4
	dbus? ( x11-libs/qt-dbus:4 )
	dev-libs/glib:2"
DEPEND="${RDEPEND}
	sys-apps/findutils"

pkg_setup() {
	confutils_require_one plugin_web plugin_stardict
}

src_prepare() {
	find "${WORKDIR}" -name '*pr?' -exec sed "s:/lib:/$(get_libdir):" -i '{}' \;

	# fix gcc-4.4.1 compatibility
	sed 's/def Q_OS_WIN32/ defined(Q_OS_WIN32)/' \
		-iplugins/stardict/dictziplib.cpp || die "sed failed"
}

src_configure() {
	
	local QMAKE_FLAGS=""

	if ! use dbus; then
		QMAKE_FLAGS+="NO_DBUS=1 "
	fi

	if ! use nls; then
		QMAKE_FLAGS+="NO_TRANSLATIONS=1 "
	fi

	local eplugins=""
	for f in $PLUGINS; do
		use "plugin_${f}" && eplugins="${eplugins} ${f}"
	done

#	[ "${eplugins}" == "" ] && die "Enable atleast one plugin"

	eqmake4 "${PN}".pro $QMAKE_FLAGS ENABLED_PLUGINS="${eplugins}" || die "qmake failed"
	emake || die "emake failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake install filed"
}
