# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"
PYTHON_MODNAME="rcore"

inherit distutils git-2

DESCRIPTION="Just an core for all rion's projects"
HOMEPAGE="http://dev.brocompany.com/"
EGIT_REPO_URI="git://github.com/Ri0n/rcore.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="sql"

RDEPEND="${DEPEND}
	>=dev-python/twisted-core-8.2.0[crypt]
	>=dev-python/twisted-web-8.2.0
	dev-python/inotifyx
	sql? ( dev-python/sqlalchemy )"
