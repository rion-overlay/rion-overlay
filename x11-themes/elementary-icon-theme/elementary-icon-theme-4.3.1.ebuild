# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2-utils cmake xdg

DESCRIPTION="Elementary gnome icon theme"
HOMEPAGE="https://launchpad.net/elementaryicons"
SRC_URI="http://launchpad.net/elementaryicons/${PV%%.*}.x/${PV}/+download/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="x11-themes/hicolor-icon-theme"
RESTRICT="binchecks strip"
