# Copyright 1999-2025 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="8"

inherit qmake-utils

DESCRIPTION="QStarDict is a StarDict clone written with using Qt"
HOMEPAGE="http://qstardict.ylsoftware.com/"
LICENSE="GPL-2"
SLOT="0"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/a-rodin/qstardict.git"
else
	SRC_URI="https://github.com/a-rodin/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

IUSE="+dbus nls +stardict +web"
REQUIRED_USE="
	|| ( stardict web )
"

RDEPEND="
	dev-qt/qtbase:6=[gui]
	dbus? ( dev-qt/qtbase:6=[dbus] )
	dev-libs/glib:2
	sys-libs/zlib:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-qt/qtbase:6
"

PATCHES=(
	"${FILESDIR}/${P}-fix-version.patch"
)

src_prepare() {
	find -name '*pr?' -exec sed "s:/lib\(64\)\?:/$(get_libdir):" -i '{}' \; || die "libdir fix failed"

	# Avoid a warning about a missing file
	touch "plugins/plugins.pri"

	default
}

src_configure() {
	local my_qmake_flags=() enabled_plugins=()

	use dbus || my_qmake_flags+=( "NO_DBUS=1" )
	use nls || my_qmake_flags+=( "NO_TRANSLATIONS=1" )

	use stardict && enabled_plugins+="stardict "
	use web && enabled_plugins+="web "

	my_qmake_flags+=( ENABLED_PLUGINS="${enabled_plugins}" )
	my_qmake_flags+=( INSTALL_PREFIX="${EPREFIX}/usr" )
	my_qmake_flags+=( DOCS_DIR="${EPREFIX}/usr/share/doc/${P}" )

	eqmake6 "${PN}".pro "${my_qmake_flags[@]}"
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	dodoc README.md
}
