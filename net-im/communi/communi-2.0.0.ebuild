# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit qt4-r2

DESCRIPTION="A cross-platform IRC framework written with Qt 4"
HOMEPAGE="https://github.com/communi/communi"
SRC_URI="https://github.com/communi/communi/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="icu test"

COMMON_DEPEND="dev-qt/qtcore
	icu? ( dev-libs/icu )"
DEPEND="${COMMON_DEPEND}
	test? ( dev-qt/qttest )"
RDEPEND="${COMMON_DEPEND}"

src_configure() {
	eqmake4 communi.pro -config no_examples \
		$(use icu || echo "-config no_icu") \
		$(use test || echo "-config no_tests")
}
