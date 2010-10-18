# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
LANGSLONG="de_DE pl_PL ru_RU uk_UA"

inherit cmake-utils subversion

DESCRIPTION="Qt4 Crossplatform Jabber client."
HOMEPAGE="http://code.google.com/p/vacuum-im"
ESVN_REPO_URI="http://vacuum-im.googlecode.com/svn/trunk"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
PLUGINS=" adiummessagestyle annotations autostatus avatars bitsofbinary bookmarks captchaforms chatstates clientinfo commands compress console dataforms datastreamsmanager emoticons filestreamsmanager filetransfer gateways inbandstreams iqauth jabbersearch messagearchiver multiuserchat pepmanager privacylists privatestorage registration remotecontrol rostersearch servicediscovery sessionnegotiation socksstreams vcard xmppuriqueries"
IUSE="${PLUGINS// / +} sdk"
for x in ${LANGSLONG}; do
	IUSE+=" linguas_${x%_*}"
done

RDEPEND="
	>=x11-libs/qt-core-4.5:4[ssl]
	>=x11-libs/qt-gui-4.5:4
	>=dev-libs/openssl-0.9.8k
	adiummessagestyle? ( >=x11-libs/qt-webkit-4.5:4 )
"
DEPEND="${RDEPEND}"

DOCS="AUTHORS CHANGELOG COPYING README"

src_configure() {
	# linguas
	local langs="none;"
	for x in ${LANGSLONG}; do
		use linguas_${x%_*} && langs+="${x};"
	done

	local mycmakeargs=(
		-DINSTALL_LIB_DIR="$(get_libdir)"
		"$(cmake-utils_use sdk INSTALL_SDK)"
		-DLANGS="${langs}"
		-DINSTALL_DOCS="0"
	)

	for x in ${PLUGINS}; do
		mycmakeargs+=( "$(cmake-utils_use ${x} PLUGIN_${x})" )
	done

	cmake-utils_src_configure
}
