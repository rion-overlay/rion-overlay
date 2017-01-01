# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A python wrapper for libmpv"
HOMEPAGE="https://github.com/andre-d/pympv"
PYMPV_REV=47b9a7b187cac3f22a675bb422b5c8cd28aa1f1d
SRC_URI="https://github.com/andre-d/pympv/archive/${PYMPV_REV}.zip -> ${P}.zip"
S="${WORKDIR}/${PN}-${PYMPV_REV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc-macos ~x64-macos ~x86-solaris"
IUSE="test"

RDEPEND="media-video/mpv[libmpv]"
DEPEND="dev-python/cython ${RDEPEND}"

DOCS=( README.md LICENSE )
