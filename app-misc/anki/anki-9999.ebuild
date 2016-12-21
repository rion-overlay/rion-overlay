# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python3_{4,5} )
PYTHON_REQ_USE="sqlite"

inherit eutils python-single-r1 git-r3

DESCRIPTION="A spaced-repetition memory training program (flash cards)"
HOMEPAGE="http://ichi2.net/anki/"
EGIT_REPO_URI="https://github.com/dae/anki.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="latex +sound +recording"

RDEPEND="${PYTHON_DEPS}
	 dev-python/PyQt5[svg,webengine]
	 >=dev-python/httplib2-0.7.4
	 dev-python/beautifulsoup:4
	 dev-python/send2trash
	 >=dev-python/pyaudio-0.2.4
	 recording? ( media-sound/lame )
	 sound? ( media-video/mplayer )
	 latex? ( app-text/texlive
			  app-text/dvipng )"
DEPEND=""

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	sed -i -e "s/updates=True/updates=False/" \
		aqt/profiles.py || die
	default
}

# Nothing to configure
src_configure() {
	true
}

src_compile() {
	./tools/build_ui.sh || die "./tools/build_ui.sh failed"
}

src_install() {
	doicon ${PN}.png
	domenu ${PN}.desktop
	doman ${PN}.1

	dodoc README.md README.development
	python_domodule aqt anki
	newbin runanki anki

	# XXX: install localization files (from bzr repo)
	# XXX: check sound & recording
	# XXX: install mime xml (see Makefile)
}
