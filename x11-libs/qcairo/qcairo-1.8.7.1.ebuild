# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

WANT_AUTOMAKE="1.9"

MY_GIT="git74d6b5"

inherit eutils flag-o-matic autotools

DESCRIPTION="A vector graphics library with cross-device output support"
HOMEPAGE="http://cairographics.org/"
SRC_URI="http://www.spice-space.org/download/${P}-${MY_GIT}.tar.bz2
	mirror://gentoo/cairo-1.8-lcd_filter.patch.bz2"

LICENSE="|| ( LGPL-2.1 MPL-1.1 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="aqua cleartype debug directfb doc +glitz +lcdfilter +opengl svg +X xcb"

RESTRICT="test"

RDEPEND="media-libs/fontconfig
	>=media-libs/freetype-2.1.9
	sys-libs/zlib
	media-libs/libpng"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P}-${MY_GIT}"

src_prepare() {
	if use lcdfilter; then
		epatch "${WORKDIR}"/cairo-1.8-lcd_filter.patch || die ""
	elif use cleartype; then
		epatch "${FILESDIR}"/cairo-1.2.4-lcd-cleartype-like.diff || die
	fi
	eautoreconf
}

src_configure() {
	append-flags -finline-limit=1200

	if use glitz && use opengl; then
		export glitz_LIBS=$(pkg-config --libs glitz-glx)
	fi

	econf $(use_enable X xlib) $(use_enable doc gtk-doc) \
		$(use_enable directfb) $(use_enable xcb) \
		$(use_enable svg) $(use_enable glitz) $(use_enable X xlib-xrender) \
		$(use_enable debug test-surfaces) --enable-pdf  --enable-png \
		--enable-ft --enable-ps \
		$(use_enable aqua quartz) $(use_enable aqua quartz-image) \
		|| die "configure failed"
}

src_install() {
	make DESTDIR="${D}" install || die "Installation failed"
	dodoc AUTHORS ChangeLog NEWS README
}

pkg_postinst() {
	if use xcb; then
		ewarn "You have enabled the Cairo XCB backend which is used only by"
		ewarn "a select few apps. The Cairo XCB backend is presently"
		ewarn "un-maintained and needs a lot of work to get it caught up"
		ewarn "to the Xrender and Xlib backends	which are the backends used"
		ewarn "by most applications. See:"
		ewarn "http://lists.freedesktop.org/archives/xcb/2008-December/004139.html"
	fi
}
