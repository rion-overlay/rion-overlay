# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

SCONS_MIN_VERSION="1.2"

[[ ${PV} = *9999* ]] && VCS_ECLASS="git-r3" || VCS_ECLASS=""

inherit scons-utils toolchain-funcs ${VCS_ECLASS}

DESCRIPTION="Just a perfect C++ XMPP library"
HOMEPAGE="http://swift.im/"
MY_P="swift-${PV}"
#S="${WORKDIR}/${MY_P}"
if [[ ${PV} == *9999* ]]; then
	BVER=${PV/9999/}
	EGIT_REPO_URI="git://swift.im/swift"
	if [ -n "$BVER" ]; then
		EGIT_BRANCH="swift-${BVER}x"
	fi
else
	SRC_URI="http://swift.im/downloads/releases/${MY_P}/${MY_P}.tar.gz"
fi

LICENSE="GPL-3"
SLOT="0"
if [[ ${PV} != *9999* ]]; then
	KEYWORDS="~amd64 ~x86"
else
	KEYWORDS=""
fi
IUSE="avahi debug doc examples test"

RDEPEND="
	avahi? ( net-dns/avahi )
	>=dev-libs/boost-1.42
	dev-libs/openssl:0
	net-dns/libidn:0
	dev-libs/libxml2
	>=dev-libs/expat-2.0.1
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	doc? (
		>=app-text/docbook-xsl-stylesheets-1.75
		>=app-text/docbook-xml-dtd-4.5
		dev-libs/libxslt
	)
"

src_prepare() {
	pushd 3rdParty || die
	# TODO CppUnit, Lua
	rm -rf Boost CAres DocBook Expat LCov LibIDN OpenSSL SCons SQLite ZLib || die
	popd || die
	default
}

src_compile() {
	scons_vars=(
		cc="$(tc-getCC)"
		cxx="$(tc-getCXX)"
		ccflags="${CFLAGS} -std=c++11"
		cxxflags="${CXXFLAGS} -std=c++11"
		linkflags="${LDFLAGS}"
		allow_warnings=1
		ccache=0
		distcc=1
		debug=$(usex debug 1 0)
		openssl="${EPREFIX}/usr"
		docbook_xsl="${EPREFIX}/usr/share/sgml/docbook/xsl-stylesheets"
		docbook_xml="${EPREFIX}/usr/share/sgml/docbook/xml-dtd-4.5"
		swiften_dll=1
		Swiften
	)

	use examples && scons_vars+=(
		Documentation/SwiftenDevelopersGuide/Examples
		Limber
		Sluift
		Swiften/Config
		Swiften/Examples
		Swiften/QA
		SwifTools
	)

	escons "${scons_vars[@]}"
}

src_test() {
	escons "${scons_vars[@]}" test="unit" QA
}

src_install() {
	escons "${scons_vars[@]}" SWIFTEN_INSTALLDIR="${ED}/usr" \
		SWIFTEN_LIBDIR="$(get_libdir)" "${ED}/usr"

	use doc && dohtml "Documentation/SwiftenDevelopersGuide/Swiften Developers Guide.html"

	if use examples; then
		for i in EchoBot{1,2,3,4,5,6} EchoComponent; do
			newbin "Documentation/SwiftenDevelopersGuide/Examples/EchoBot/${i}" "${PN}-${i}"
		done

		dobin Limber/limber
		dobin Sluift/sluift
		dobin Swiften/Config/swiften-config

		for i in BenchTool ConnectivityTest LinkLocalTool ParserTester SendFile SendMessage; do
			newbin "Swiften/Examples/${i}/${i}" "${PN}-${i}"
		done
		newbin Swiften/Examples/SendFile/ReceiveFile "${PN}-ReceiveFile"
		use avahi && dobin Swiften/Examples/LinkLocalTool/LinkLocalTool

		for i in ClientTest NetworkTest StorageTest TLSTest; do
			newbin "Swiften/QA/${i}/${i}" "${PN}-${i}"
		done

		newbin SwifTools/Idle/IdleQuerierTest/IdleQuerierTest ${PN}-IdleQuerierTest
	fi
}
