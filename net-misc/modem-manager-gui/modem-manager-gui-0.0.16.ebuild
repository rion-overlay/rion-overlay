# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="GUI for Modem Manager daemon."
HOMEPAGE="http://linuxonly.ru/"
SRC_URI="http://download.tuxfamily.org/gsf/source/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=x11-libs/gtk+-3.4.0
	x11-libs/libnotify"
RDEPEND="${DEPEND}"
