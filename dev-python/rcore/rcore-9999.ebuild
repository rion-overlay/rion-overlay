# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_5 python3_6 )

inherit distutils-r1 git-r3

DESCRIPTION="Just an core for all rion's projects"
HOMEPAGE="http://dev.brocompany.com/"
EGIT_REPO_URI="https://github.com/Ri0n/rcore.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="sql"

RDEPEND="${DEPEND}
	dev-python/twisted[crypt]
	dev-python/inotifyx
	sql? ( dev-python/sqlalchemy )"
