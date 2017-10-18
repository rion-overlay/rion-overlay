# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python3_4 python3_5 python3_6 )
PYTHON_REQ_USE="sqlite"

inherit eutils python-single-r1 xdg-utils


DESCRIPTION="A spaced-repetition memory training program (flash cards)"
HOMEPAGE="https://apps.ankiweb.net"
MY_P=${P/_/}
SRC_URI="https://apps.ankiweb.net/downloads/beta/${MY_P}-source.tgz -> ${P}.tgz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="latex +recording +sound"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-python/PyQt5[svg,webengine,widgets,${PYTHON_USEDEP}]
	>=dev-python/httplib2-0.7.4[${PYTHON_USEDEP}]
	dev-python/beautifulsoup:4[${PYTHON_USEDEP}]
	dev-python/decorator[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/markdown[${PYTHON_USEDEP}]
	dev-python/send2trash[${PYTHON_USEDEP}]
	recording? (
		media-sound/lame
		>=dev-python/pyaudio-0.2.4[${PYTHON_USEDEP}]
	)
	sound? ( media-video/mpv )
	latex? (
		app-text/texlive
		app-text/dvipng
	)"
DEPEND=""

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	sed -i -e "s/updates=True/updates=False/" \
		aqt/profiles.py || die
	sed -i -e 's,"web","anki/web",' aqt/mediasrv.py || die
}

# Nothing to configure or compile
src_configure() {
	true
}

src_compile() {
	true
}

src_install() {
	doicon ${PN}.png
	domenu ${PN}.desktop
	doman ${PN}.1

	dodoc README.contributing README.md README.development
	python_domodule aqt anki
	python_doscript runanki

	# Localization files go into the anki directory:
	python_moduleinto anki
	python_domodule locale
	python_domodule web
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
