# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 mercurial

DESCRIPTION="reStructuredText documents to epub files convertor"
HOMEPAGE="https://bitbucket.org/wierob/rst2epub/"
SRC_URI=""
EHG_REPO_URI="https://bitbucket.org/wierob/rst2epub"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=dev-python/docutils-0.6"
RDEPEND="${DEPEND}"
