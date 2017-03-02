# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

inherit eutils python-single-r1

DESCRIPTION="A spaced-repetition memory training program (flash cards)"
HOMEPAGE="https://apps.ankiweb.net"
ANKI_MPV_REV=d52ad7ec9aa3c806b13fa6e90fe56fa233d355c6
SRC_URI="https://apps.ankiweb.net/downloads/current/${P}-source.tgz -> ${P}.tgz
	mpv? ( https://github.com/tsudoko/anki-mpv/archive/${ANKI_MPV_REV}.zip )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="latex +mpv +recording +sound"
REQUIRED_USE="mpv? ( sound )"

RDEPEND="${PYTHON_DEPS}
	 dev-python/PyQt4[X,svg,webkit]
	 >=dev-python/httplib2-0.7.4
	 dev-python/beautifulsoup:python-2
	 dev-python/send2trash
	 recording? ( media-sound/lame
				  >=dev-python/pyaudio-0.2.4 )
	 sound? (
	 	mpv? ( media-libs/pympv )
	 	!mpv? ( media-video/mplayer )
	 )
	 latex? ( app-text/texlive
			  app-text/dvipng )"
DEPEND=""

pkg_setup(){
	python-single-r1_pkg_setup
}

src_prepare() {
	rm -r thirdparty || die
	sed -i -e "s/updates=True/updates=False/" \
		aqt/profiles.py || die
}

# Nothing to configure or compile
src_configure() {
	true;
}

src_compile() {
	true;
}

src_install() {
	doicon ${PN}.png
	domenu ${PN}.desktop
	doman ${PN}.1

	dodoc README README.development
	python_domodule aqt anki
	python_doscript anki/anki

	# Localization files go into the anki directory:
	python_moduleinto anki
	python_domodule locale

	einfo "To work with mpv, please install https://github.com/tsudoko/anki-mpv addon"
}
