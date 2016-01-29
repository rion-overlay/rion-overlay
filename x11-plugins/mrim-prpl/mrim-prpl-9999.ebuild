# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils git-r3

DESCRIPTION="Mail.Ru agent protocol for pidgin."
HOMEPAGE="https://bitbucket.org/mrim-prpl-team/mrim-prpl"
EGIT_REPO_URI="https://bitbucket.org/mrim-prpl-team/mrim-prpl.git"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE="test"

RDEPEND=">=net-im/pidgin-2.7[gtk]"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/gettext
	test? ( dev-libs/check )
"

src_test() {
	emake -C "${BUILD_DIR}" check
}
