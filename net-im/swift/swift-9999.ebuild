# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit toolchain-funcs git

DESCRIPTION="Qt4 jabber (xmpp) client"
HOMEPAGE="http://swift.im/"
EGIT_REPO_URI="git://gitorious.org/${PN}/${PN}.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="avahi debug doc examples test"

RDEPEND="
	avahi? ( net-dns/avahi )
	>=dev-libs/boost-1.34
	>=dev-libs/openssl-0.9.8g
	>=net-dns/libidn-1.10
	>=x11-libs/libXScrnSaver-1.2
	>=x11-libs/qt-gui-4.5:4
	>=x11-libs/qt-webkit-4.5:4
	dev-libs/libxml2
	>=dev-libs/expat-2.0.1
	sys-libs/zlib
	"
DEPEND="${RDEPEND}
	>=dev-util/scons-1.2
	doc? (
		>=app-text/docbook-xsl-stylesheets-1.75
		>=app-text/docbook-xml-dtd-4.5
		dev-libs/libxslt
	)
	"

src_prepare() {
	mkdir "${WORKDIR}/qt4"
	for d in include lib share; do
		ln -s "/usr/${d}/qt4" "${WORKDIR}/qt4/${d}"
	done

	pushd 3rdParty
	# TODO 'CppUnit'
	rm -rf CAres DocBook Expat LCov LibIDN OpenSSL SCons SQLite ZLib
	# 'Boost' we need >=1.42, but it is not stable now.
	find Boost/src -type f | grep -v uuid | xargs rm -f
	popd
}

src_compile() {
	scons_vars=(
		cc="$(tc-getCC)"
		cxx="$(tc-getCXX)"
		ccflags="${CFLAGS}"
		linkflags="${LDFLAGS}"
		${MAKEOPTS}
		ccache=1
		distcc=1
		debug="$(use debug && echo 1 || echo 0)"
		qt="${WORKDIR}/qt4"
		openssl="/usr"
		SWIFT_INSTALLDIR="${S}/usr"
		docbook_xsl="/usr/share/sgml/docbook/xsl-stylesheets"
		docbook_xml="/usr/share/sgml/docbook/xml-dtd-4.5"
	)
	use test && scons_vars+=( test="unit" )

	scons "${scons_vars[@]}" || die
}

src_install() {
	insinto /usr
	doins -r usr/share

	into /usr
	dobin usr/bin/swift

	if use avahi; then
		newbin Slimber/Qt/slimber slimber-qt
		newbin Slimber/CLI/slimber slimber-cli
	fi

	if use examples; then
		dobin Limber/limber
		dobin Swiften/Examples/ConnectivityTest/ConnectivityTest
		dobin Swiften/Examples/SendMessage/SendMessage
		use avahi && dobin Swiften/Examples/LinkLocalTool/LinkLocalTool
	fi

	use doc && dohtml "Documentation/SwiftenDevelopersGuide/Swiften Developers Guide.html"
}
