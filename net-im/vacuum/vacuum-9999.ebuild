# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
LANGS="de pl ru uk"

inherit cmake-utils subversion

DESCRIPTION="Qt4 Crossplatform Jabber client."
HOMEPAGE="http://code.google.com/p/vacuum-im"
ESVN_REPO_URI="http://vacuum-im.googlecode.com/svn/trunk"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
PLUGINS=" adiummessagestyle annotations autostatus avatars birthdayreminder bitsofbinary bookmarks captchaforms chatstates clientinfo commands compress console dataforms datastreamsmanager emoticons filestreamsmanager filetransfer gateways inbandstreams iqauth jabbersearch messagearchiver multiuserchat pepmanager privacylists privatestorage registration remotecontrol rostersearch servicediscovery sessionnegotiation socksstreams vcard xmppuriqueries"
IUSE="${PLUGINS// / +} vcs-revision"
for x in ${LANGS}; do
	IUSE+=" linguas_${x}"
done

REQUIRED_USE="
	annotations? ( privatestorage )
	avatars? ( vcard )
	bookmarks? ( privatestorage )
	captchaforms? ( dataforms )
	commands? ( dataforms )
	datastreamsmanager? ( dataforms )
	filestreamsmanager? ( datastreamsmanager )
	filetransfer? ( filestreamsmanager datastreamsmanager )
	pepmanager? ( servicediscovery )
	registration? ( dataforms )
	remotecontrol? ( commands dataforms )
	sessionnegotiation? ( dataforms )
"

RDEPEND="
	>=x11-libs/qt-core-4.5:4[ssl]
	>=x11-libs/qt-gui-4.5:4
	>=dev-libs/openssl-0.9.8k
	adiummessagestyle? ( >=x11-libs/qt-webkit-4.5:4 )
	net-dns/libidn
	x11-libs/libXScrnSaver
"
DEPEND="${RDEPEND}"

DOCS="AUTHORS CHANGELOG README TRANSLATORS"

pkg_setup() {
	if use vcs-revision; then
		ewarn "Anyone will be able to see your VCS revision of ${PN}, it is insecure."
	fi
}

src_configure() {
	# linguas
	local langs="none;"
	for x in ${LANGS}; do
		use linguas_${x} && langs+="${x};"
	done

	local mycmakeargs=(
		-DINSTALL_LIB_DIR="$(get_libdir)"
		-DINSTALL_SDK=ON
		-DLANGS="${langs}"
		-DINSTALL_DOCS=OFF
		-DFORCE_BUNDLED_MINIZIP=ON
	)

	for x in ${PLUGINS}; do
		mycmakeargs+=( "$(cmake-utils_use ${x} PLUGIN_${x})" )
	done

	if use vcs-revision; then
		subversion_wc_info # eclass is broken
		mycmakeargs+=( -DVER_STRING="${ESVN_WC_REVISION}" )
	fi

	cmake-utils_src_configure
}
