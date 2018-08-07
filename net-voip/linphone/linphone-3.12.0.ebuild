# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PLOCALES="ar cs de es fi fr he hu it ja lt nb-NO nl pl pt-BR ru sr sv tr zh-CN zh-TW"

inherit l10n multilib pax-utils cmake-utils

DESCRIPTION="Video softphone based on the SIP protocol"
HOMEPAGE="http://www.linphone.org/"
SRC_URI="http://www.linphone.org/releases/sources/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# TODO: run-time test for ipv6: does it need mediastreamer[ipv6]?
IUSE="assistant -doc gsm-nonstandard gtk ipv6 ldap libnotify -ncurses nls +sqlite tools upnp vcard video zlib"
# w/o sqlite it most likely will crash
REQUIRED_USE="assistant? ( gtk )
	libnotify? ( gtk )"

RDEPEND="
	>=media-libs/mediastreamer-2.16.0[upnp?,video?]
	>=net-libs/ortp-0.24.0
	net-libs/bctoolbox
	>=net-voip/belle-sip-1.6.3
	virtual/udev
	media-libs/bzrtp
	gtk? (
		dev-libs/glib:2
		>=gnome-base/libglade-2.4.0:2.0
		>=x11-libs/gtk+-2.4.0:2
		assistant? ( >=net-libs/libsoup-2.26 )
		libnotify? ( x11-libs/libnotify )
	)
	gsm-nonstandard? ( >=media-libs/mediastreamer-2.15.0[gsm] )
	ldap? (
		dev-libs/cyrus-sasl
		net-nds/openldap
	)
	ncurses? (
		sys-libs/readline:0
		sys-libs/ncurses:0
	)
	sqlite? ( dev-db/sqlite:3 )
	tools? ( dev-libs/libxml2 )
	upnp? ( net-libs/libupnp:0 )
	vcard? ( >=net-voip/belcard-1.0.2 )
	video? ( >=media-libs/mediastreamer-2.15.0[v4l] )
	zlib? ( sys-libs/zlib )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-text/sgmltools-lite )
	nls? ( dev-util/intltool )
"

pkg_setup() {
	if ! use gtk && ! use ncurses ; then
		ewarn "gtk and ncurses are disabled."
		ewarn "At least one of these use flags are needed to get a front-end."
		ewarn "Only liblinphone is going to be installed."
	fi
}

src_prepare() {
	default
	eapply "${FILESDIR}"/${PN}-nls.patch \
		"${FILESDIR}"/${PN}-no-cam-crash-fix.patch

	# another workaround for upstream bug
	printf "#define LIBLINPHONE_GIT_VERSION \"${PV}\"\n" > "${S}"/coreapi/gitversion.h
	printf "#define LIBLINPHONE_GIT_VERSION \"${PV}\"\n" > "${S}"/coreapi/liblinphone_gitversion.h

	l10n_find_plocales_changes po "" .po
	rm_locale() { rm -f ${1/-/_}; }
	l10n_for_each_disabled_locale_do rm_locale

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_SHARED=ON
		-DENABLE_STATIC=OFF
		-DENABLE_CONSOLE_UI=$(usex ncurses)
		-DENABLE_DOC=$(usex doc)
		-DENABLE_JAVADOC=$(usex doc)
		-DENABLE_GTK_UI=$(usex gtk)
		-DENABLE_LDAP=$(usex ldap)
		-DENABLE_SQLITE_STORAGE=$(usex sqlite)
		-DENABLE_STRICT=OFF
		-DENABLE_TOOLS=$(usex tools)
		-DENABLE_TUTORIALS=$(usex doc)
		-DENABLE_UNIT_TESTS=OFF
		-DENABLE_UPDATE_CHECK=OFF
		-DENABLE_VIDEO=$(usex video)
		-DENABLE_DEBUG_LOGS=ON
		-DENABLE_NLS=$(usex nls)
		-DENABLE_VCARD=$(usex vcard)
		-DENABLE_ROOTCA_DOWNLOAD=ON
		-DENABLE_CXX_WRAPPER=OFF
		-DENABLE_CSHARP_WRAPPER=OFF
	)

	# cxx wrapper is broken in 3.12.0
	# who needs csharp wrapper?

	# more options
	#	-DENABLE_DATE=$(usex date)
	#	-DENABLE_DAEMON=$(usex daemon)
	#	-DENABLE_RELATIVE_PREFIX=$(usex prefix)
	#	-DENABLE_TUNNEL=$(usex tunnel)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dodoc AUTHORS BUGS ChangeLog NEWS README.md README.arm TODO
	pax-mark m "${ED%/}/usr/bin/linphone"
}
