# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="Graphical effect and filter library by KDE"
HOMEPAGE="https://websvn.kde.org/trunk/kdesupport/qimageblitz/"
EGIT_REPO_URI="https://github.com/mylxiaoyi/qimageblitz.git"

LICENSE="GPL-2 LGPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="cpu_flags_x86_3dnow altivec debug cpu_flags_x86_mmx cpu_flags_x86_sse cpu_flags_x86_sse2"

DEPEND="
	dev-qt/qtgui:5
	dev-qt/qtgui:5
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-exec-stack.patch"
	"${FILESDIR}/${P}-gcc.patch"
)

src_configure() {
	local mycmakeargs=(
		-DHAVE_ALTIVEC=$(usex altivec)
		-DHAVE_3DNOW=$(usex cpu_flags_x86_3dnow)
		-DHAVE_MMX=$(usex cpu_flags_x86_mmx)
		-DHAVE_SSE=$(usex cpu_flags_x86_sse)
		-DHAVE_SSE2=$(usex cpu_flags_x86_sse2)
	)

	cmake-utils_src_configure
}
