# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

EHG_REPO_URI="https://bitbucket.org/ratnik/dump_viewer"

inherit qt4-r2
[[ ${PV} == *9999* ]] && inherit mercurial

DESCRIPTION="Viewer for DB dumps of torrent trackers"
HOMEPAGE="https://bitbucket.org/ratnik/dump_viewer"
[[ ${PV} == *9999* ]] || \
SRC_URI="https://bitbucket.org/ratnik/dump_viewer/downloads/dump_viewer.tar.gz"

LICENSE="GPL-2"
SLOT="0"
[[ ${PV} == *9999* ]] || \
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND+="
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtwebkit:4
	kde-base/kdelibs:4
"
DEPEND="${RDEPEND}"

DOCS=( README )

src_configure() {
	eqmake4 PREFIX="${EPREFIX}/usr"
}
