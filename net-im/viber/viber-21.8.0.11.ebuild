# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit unpacker xdg

DESCRIPTION="Free calls, text and picture sharing with anyone, anywhere!"
HOMEPAGE="http://www.viber.com"
SRC_URI="
	amd64? ( http://download.cdn.viber.com/cdn/desktop/Linux/viber.deb -> ${P}.deb )
"
LICENSE="Viber-EULA"
SLOT="0"
KEYWORDS="amd64"

QA_PREBUILT="*"

RDEPEND="app-arch/snappy
	dev-libs/icu
	media-libs/gst-plugins-base
	media-libs/gst-plugins-good
	media-libs/gst-plugins-ugly
	media-plugins/gst-plugins-libav
	media-plugins/gst-plugins-pulse
	sys-libs/zlib
	x11-libs/libXScrnSaver"

S="${WORKDIR}"
RESTRICT="mirror bindist strip"

src_unpack() {
	unpack_deb ${A}
}

src_install(){
	doins -r opt usr
	fperms 0755 /opt/viber/Viber
	fperms 0755 /opt/viber/libexec/QtWebEngineProcess
}
