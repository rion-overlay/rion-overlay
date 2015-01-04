# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
SCONS_MIN_VERSION="1.2"
LANGS=" ca de es fr hu nl pl ru se sk"

[[ ${PV} = *9999* ]] && VCS_ECLASS="git-2" || VCS_ECLASS=""

inherit scons-utils toolchain-funcs ${VCS_ECLASS}

DESCRIPTION="Qt4 jabber (xmpp) client"
HOMEPAGE="http://swift.im/"
if [[ ${PV} == *9999* ]]; then
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
IUSE="avahi debug doc examples test"
IUSE+="${LANGS// / linguas_}"

RDEPEND="
	avahi? ( net-dns/avahi )
	>=dev-libs/boost-1.42
	>=dev-libs/openssl-0.9.8g
	>=net-dns/libidn-1.10
	>=x11-libs/libXScrnSaver-1.2
	>=dev-qt/qtgui-4.5:4
	>=dev-qt/qtwebkit-4.5:4
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
	mkdir "${WORKDIR}/qt4" || die
	for d in include lib share; do
		ln -s "${EPREFIX}/usr/${d}/qt4" "${WORKDIR}/qt4/${d}" || die
	done

	pushd 3rdParty || die
	# TODO CppUnit, Lua
	rm -rf Boost CAres DocBook Expat LCov LibIDN OpenSSL SCons SQLite ZLib || die
	popd || die

	for x in ${LANGS}; do
		if use !linguas_${x}; then
			rm -f Swift/Translations/swift_${x}.ts || die
		fi
	done
}

src_compile() {
	scons_vars=(
		cc="$(tc-getCC)"
		cxx="$(tc-getCXX)"
		ccflags="${CFLAGS}"
		linkflags="${LDFLAGS}"
		allow_warnings=1
		ccache=1
		distcc=1
		$(use_scons debug)
		qt="${WORKDIR}/qt4"
		openssl="${EPREFIX}/usr"
		docbook_xsl="${EPREFIX}/usr/share/sgml/docbook/xsl-stylesheets"
		docbook_xml="${EPREFIX}/usr/share/sgml/docbook/xml-dtd-4.5"
		Swift
	)
	use avahi && scons_vars+=( Slimber )
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
	escons "${scons_vars[@]}" SWIFT_INSTALLDIR="${ED}/usr" "${ED}/usr"

	if use avahi; then
		newbin Slimber/Qt/slimber slimber-qt
		newbin Slimber/CLI/slimber slimber-cli
	fi

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

	use doc && dohtml "Documentation/SwiftenDevelopersGuide/Swiften Developers Guide.html"
}
