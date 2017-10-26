# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
SCONS_MIN_VERSION="1.2"
LANGS=" ca cs de es fr gl he hu nl pl ru se sk sv"

[[ ${PV} = *9999* ]] && VCS_ECLASS="git-r3" || VCS_ECLASS=""

inherit scons-utils toolchain-funcs gnome2-utils ${VCS_ECLASS}

DESCRIPTION="Qt5 jabber (xmpp) client"
HOMEPAGE="http://swift.im/"
if [[ ${PV} == *9999* ]]; then
	branch="${PV/9999/}"
	[ -n "${branch}" ] && EGIT_BRANCH="swift-${branch}x"
	EGIT_REPO_URI="git://swift.im/${PN}"
else
	SRC_URI="http://swift.im/downloads/releases/${P}/${P}.tar.gz"
fi

LICENSE="GPL-3"
SLOT="0"
if [[ ${PV} != *9999* ]]; then
	KEYWORDS="~amd64 ~x86"
else
	KEYWORDS=""
fi
IUSE="avahi debug hunspell icu test"
IUSE+="${LANGS// / linguas_}"

RDEPEND="
	avahi? ( net-dns/avahi )
	>=dev-libs/boost-1.42
	dev-libs/openssl:0
	>=x11-libs/libXScrnSaver-1.2
	dev-qt/qtgui:5
	dev-qt/qtwebkit:5
	dev-qt/qtwidgets:5
	dev-libs/libxml2
	>=dev-libs/expat-2.0.1
	sys-libs/zlib
	icu? ( dev-libs/icu:= )
	!icu? ( net-dns/libidn )
"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i -e 's,if env\["SCONS_STAGE"\] == "build",if False,' Swiften/SConscript
	pushd 3rdParty || die
	# TODO CppUnit, Lua
	rm -rf Boost CAres DocBook Expat LCov Ldns LibMiniUPnPc LibIDN LibNATPMP OpenSSL SCons SQLite Unbound ZLib || die
	popd || die

	for x in ${LANGS}; do
		if use !linguas_${x}; then
			rm -f Swift/Translations/swift_${x}.ts || die
		fi
	done

	eapply_user
}

src_compile() {
	scons_vars=(
		cc="$(tc-getCC)"
		cxx="$(tc-getCXX)"
		ccflags="${CFLAGS}"
		linkflags="${LDFLAGS}"
		allow_warnings=1
		ccache=no
		distcc=1
		hunspell_enable=$(usex hunspell)
		icu=$(usex icu)
		qt5=1
		debug=$(usex debug 1 0)
		openssl="${EPREFIX}/usr"
		Swift
	)
	use avahi && scons_vars+=( Slimber )

	escons "${scons_vars[@]}"
}

src_test() {
	escons "${scons_vars[@]}" test="unit" QA
}

src_install() {
	escons "${scons_vars[@]}" SWIFT_INSTALLDIR="${ED}/usr" "${ED}/usr"

	if use avahi; then
		newbin Slimber/Qt/slimber slimber-qt
		newbin Slimber/CLI/slimber slimber-cli
	fi
}

pkg_postinst()
{
	gnome2_icon_cache_update
	#xdg_desktop_database_update
}

pkg_postrm() {
	#xdg_desktop_database_update
	gnome2_icon_cache_update
}
