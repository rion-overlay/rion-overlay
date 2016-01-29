# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit qt4-r2

DESCRIPTION="Stupid bidirection cpp to text converter"
HOMEPAGE="https://github.com/Ri0n/cpp2text"
SRC_URI="https://github.com/Ri0n/cpp2text/archive/1.0.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-qt/qtgui:*"
RDEPEND="${DEPEND}"
