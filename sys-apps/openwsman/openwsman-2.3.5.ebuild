# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_DEPEND="python? 2:2.7"

inherit python cmake-utils

DESCRIPTION="Opensource Implementation of WS-Management Client"
HOMEPAGE="http://sourceforge.net/projects/openwsman"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}/${PV}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+cim debug examples +eventing ipv6 java pam perl python plugins ruby ssl server"

DEPEND="
	cim? ( dev-libs/sblim-sfcc )
	ssl? ( dev-libs/openssl )
	pam? ( virtual/pam )
	ruby? ( <dev-lang/ruby-2 )
	perl? ( dev-lang/perl )
	java? ( virtual/jdk )
	net-misc/curl
	dev-libs/libxml2
	"
RDEPEND="${DEPEND}"

pkg_setup() {
	if use python; then
		python_set_active_version 2
		python_pkg_setup
	fi
}

src_prepare(){
	#Ruby gem builder does not like Unicode
	sed -e 's/Kämpf/Kaempf/' -i bindings/ruby/openwsman.gemspec.in
}

src_configure() {
	local mycmakeargs=(
		-DPACKAGE_ARCHITECTURE=${ARCH}
		$(cmake-utils_use_build cim LIBCIM)
		$(cmake-utils_use_build examples)
		$(cmake-utils_use_build python)
		$(cmake-utils_use_build ruby)
		$(cmake-utils_use_build perl)
		$(cmake-utils_use_build java)
		$(cmake-utils_use_build mono CSHARP)
		$(cmake-utils_use_disable plugins)
		$(cmake-utils_use_disable server)
		$(cmake-utils_use_enable eventing)
		$(cmake-utils_use_enable ipv6)
		$(cmake-utils_use_use pam)
	)
	cmake-utils_src_configure
}

src_compile(){
	cmake-utils_src_compile -j1 #Upstream doesn't know about target	dependencies, sigh
}
