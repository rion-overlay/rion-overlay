# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24"

RUBY_FAKEGEM_EXTRADOC="ChangeLog NEWS.md README.md"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""

inherit ruby-fakegem

DESCRIPTION="A Dead Simple Fileserver is a static file server that can launch in a directory"
HOMEPAGE="https://github.com/ddfreyne/adsf"
LICENSE="MIT"

KEYWORDS="~amd64"
SLOT="0"
IUSE=""

ruby_add_rdepend ">=dev-ruby/rack-1.0.0:*"

#ruby_add_bdepend "test? ( dev-ruby/rack-test )"
