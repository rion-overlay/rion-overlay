# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils multilib pax-utils versionator

DESCRIPTION="Video softphone based on the SIP protocol"
HOMEPAGE="http://www.linphone.org/"
SRC_URI="http://www.linphone.org/releases/sources/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# TODO: run-time test for ipv6: does it need mediastreamer[ipv6]?
IUSE="assistant doc gsm-nonstandard gtk ipv6 ldap libnotify ncurses nls sqlite tools upnp vcard video zlib"
REQUIRED_USE="assistant? ( gtk )
	libnotify? ( gtk )"

RDEPEND="
	>=media-libs/mediastreamer-2.15.0[upnp?,video?]
	>=net-libs/ortp-0.24.0
	net-libs/bctoolbox
	>=net-voip/belle-sip-1.6
	virtual/udev
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
	vcard? ( net-voip/belcard )
	video? ( >=media-libs/mediastreamer-2.15.0[v4l] )
	zlib? ( sys-libs/zlib )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-text/sgmltools-lite )
	nls? ( dev-util/intltool )
"

IUSE_LINGUAS=" fr it de he ja es pl cs nl sr sv pt_BR hu ru zh_CN"
IUSE="${IUSE}${IUSE_LINGUAS// / linguas_}"

pkg_setup() {
	if ! use gtk && ! use ncurses ; then
		ewarn "gtk and ncurses are disabled."
		ewarn "At least one of these use flags are needed to get a front-end."
		ewarn "Only liblinphone is going to be installed."
	fi

	strip-linguas ${IUSE_LINGUAS}
}

src_prepare() {
	default
	epatch "${FILESDIR}"/${PN}-nls.patch \
		"${FILESDIR}"/${PN}-no-cam-crash-fix.patch

	# variable causes "command not found" warning and is not
	# needed anyway
	sed -i \
		-e 's/$(ACLOCAL_MACOS_FLAGS)//' Makefile.am || die

	# fix path to use lib64
	# and lime actually does not depend on polarssl (upstream bug)
	sed -i \
		-e "s:lib\(/liblinphone\):$(get_libdir)\1:" \
		-e "s:found_polarssl=no:found_polarssl=yes:" \
		configure.ac || die "patching configure.ac failed"

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable doc manual)
		$(use_enable doc doxygen)
		$(use_enable nls)
		--disable-static
		$(use_enable ldap)
		$(use_enable ncurses console_ui)
		$(use_enable tools)
		$(use_enable upnp)
		$(use_enable gtk gtk_ui)
		$(use_enable libnotify notify)
		--enable-lime
		$(use_enable ipv6)
		--disable-truespeech
		$(use_enable gsm-nonstandard nonstandard-gsm)
		--disable-speex
		# seems not used, TODO: ask in ml
		$(use_enable video)
		--disable-zrtp
		$(use_enable assistant)
		# we don't want -Werror
		--disable-strict
		# don't bundle libs
		--enable-external-mediastreamer
		$(use_enable sqlite sqlite-storage)
		--enable-external-ortp
		$(use_enable vcard)
		$(use_enable zlib)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" pkgdocdir="/usr/share/doc/${PF}" install # 415161
	dodoc AUTHORS BUGS ChangeLog NEWS README.md README.arm TODO
	pax-mark m "${ED%/}/usr/bin/linphone"
}
