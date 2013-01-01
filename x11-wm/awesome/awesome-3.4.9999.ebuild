# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
CMAKE_MIN_VERSION="2.8"

EGIT_REPO_URI="git://git.naquadah.org/awesome.git"
EGIT_BRANCH="3.4"

inherit git-2 cmake-utils eutils

DESCRIPTION="A dynamic floating and tiling window manager"
HOMEPAGE="http://awesome.naquadah.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="dbus doc elibc_FreeBSD gnome"

COMMON_DEPEND=">=dev-lang/lua-5.1
	dev-libs/libev
	>=dev-libs/libxdg-basedir-1
	media-libs/imlib2[png]
	x11-libs/cairo[xcb]
	|| ( <x11-libs/libX11-1.3.99.901[xcb] >=x11-libs/libX11-1.3.99.901 )
	>=x11-libs/libxcb-1.6
	>=x11-libs/pango-1.19.3
	>=x11-libs/startup-notification-0.10_p20110426
	>=x11-libs/xcb-util-0.3.8
	dbus? ( >=sys-apps/dbus-1 )
	elibc_FreeBSD? ( dev-libs/libexecinfo )"

# graphicsmagick's 'convert -channel' has no Alpha support, bug #352282
DEPEND="${COMMON_DEPEND}
	>=app-text/asciidoc-8.4.5
	app-text/xmlto
	dev-util/gperf
	virtual/pkgconfig
	media-gfx/imagemagick[png]
	>=x11-proto/xcb-proto-1.5
	>=x11-proto/xproto-7.0.15
	doc? (
		app-doc/doxygen
		dev-lua/luadoc
		media-gfx/graphviz
	)"

RDEPEND="${COMMON_DEPEND}
	|| (
		x11-misc/gxmessage
		x11-apps/xmessage
	)"

# bug #321433: Need one of these to for awsetbg.
# imagemagick provides 'display' and is further down the default list, but
# listed here for completeness.  'display' however is only usable with
# x11-apps/xwininfo also present.
RDEPEND="${RDEPEND}
	|| (
	( x11-apps/xwininfo
	  || ( media-gfx/imagemagick[X] media-gfx/graphicsmagick[imagemagick,X] )
	)
	x11-misc/habak
	media-gfx/feh
	x11-misc/hsetroot
	media-gfx/qiv
	media-gfx/xv
	x11-misc/xsri
	media-gfx/xli
	x11-apps/xsetroot
	)"

DOCS="AUTHORS BUGS PATCHES README STYLE"

src_unpack() {
	git-2_src_unpack
}

src_prepare() {
	epatch \
		"${FILESDIR}/${PN}-backtrace.patch"

	# bug  #408025
	epatch "${FILESDIR}/${PN}-convert-path.patch"

	epatch_user
}

src_configure() {
	mycmakeargs=(
		-DPREFIX="${EPREFIX}"/usr
		-DSYSCONFDIR="${EPREFIX}"/etc
		$(cmake-utils_use_with dbus DBUS)
		$(cmake-utils_use doc GENERATE_LUADOC)
		)

	cmake-utils_src_configure
}

src_compile() {
	local myargs="all"

	if use doc ; then
		myargs="${myargs} doc"
	fi
	cmake-utils_src_make ${myargs}
}

src_install() {
	cmake-utils_src_install

	if use doc ; then
		(
			cd "${CMAKE_BUILD_DIR}"/doc
			mv html doxygen
			dohtml -r doxygen || die
		)
		mv "${ED}"/usr/share/doc/${PN}/luadoc "${ED}"/usr/share/doc/${PF}/html/luadoc || die
	fi
	rm -rf "${ED}"/usr/share/doc/${PN} || die

	exeinto /etc/X11/Sessions
	newexe "${FILESDIR}"/${PN}-session ${PN} || die

	# GNOME-based awesome
	if use gnome ; then
		# GNOME session
		insinto /usr/share/gnome-session/sessions
		doins "${FILESDIR}/${PN}-gnome.session" || die
		# Application launcher
		insinto /usr/share/applications
		doins "${FILESDIR}/${PN}-gnome.desktop" || die
		# X Session
		insinto /usr/share/xsessions/
		doins "${FILESDIR}/${PN}-gnome-xsession.desktop" || die
	fi
}
