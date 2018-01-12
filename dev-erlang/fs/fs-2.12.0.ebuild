# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit rebar

DESCRIPTION="Erlang File System Listener"
HOMEPAGE="https://github.com/synrc/fs"
SRC_URI="https://github.com/synrc/fs/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=">=dev-erlang/fast_xml-1.1.21
	>=dev-lang/erlang-17.1
	sys-fs/inotify-tools"
DEPEND="${RDEPEND}"

DOCS=( README.md LICENSE )

src_prepare() {
	rebar_src_prepare
	rebar_fix_include_path fast_xml
}
