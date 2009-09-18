# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git toolchain-funcs

EGIT_REPO_URI="git://github.com/Dieterbe/uzbl.git"

DESCRIPTION="Uzbl: A UZaBLe Keyboard-controlled Lightweight Webkit-based Web Browser"
HOMEPAGE="http://www.uzbl.org"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="dmenu zenity"

RDEPEND=">=net-libs/webkit-gtk-1.1.7
		>=x11-libs/gtk+-2.14
		dmenu? ( x11-misc/dmenu	)
		zenity? ( gnome-extra/zenity )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_compile() {
	$(tc-getCC) $CFLAGS $LDFLAGS \
		$(pkg-config --libs gtk+-2.0 webkit-1.0) \
		$(pkg-config --cflags gtk+-2.0 webkit-1.0) \
		-DARCH="\"$(uname -m)\"" \
		-DCOMMIT="\"${P}\"" \
		uzbl.c \
		-o uzbl || die "compile failed"
}

src_install() {
	dobin uzbl || die "install failed"
	dodoc docs/* config.h AUTHORS README
	insinto /usr/share/${PN}
	doins -r examples
#	emake DESTDIR="${D}" install || die "install failed"
}

