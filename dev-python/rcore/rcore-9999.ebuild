# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 git-r3

DESCRIPTION="Just an core for all rion's projects"
HOMEPAGE="http://dev.brocompany.com/"
EGIT_REPO_URI="git://github.com/Ri0n/rcore.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="sql"

RDEPEND="${DEPEND}
	dev-python/twisted-core[crypt]
	dev-python/twisted-web
	dev-python/inotifyx
	sql? ( dev-python/sqlalchemy )"
