# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
USE_RUBY="ruby18 ruby19 ree18 jruby"

#RUBY_FAKEGEM_TASK_TEST=""
#RUBY_FAKEGEM_EXTRADOC="CONTRIBUTORS Histroy.txt README.txt ReleaseNotes"

inherit ruby-fakegem

DESCRIPTION="INI-file parser for ruby"
HOMEPAGE="http://rubyforge.org/frs/?group_id=1024"
SRC_URI="mirror://rubyforge/codeforpeople/${P}.gem"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
