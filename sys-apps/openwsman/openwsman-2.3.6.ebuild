# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_DEPEND="python? 2:2.7"
RESTRICT_PYTHON_ABIS="3.* *-jython"

inherit python cmake-utils ssl-cert java-pkg-2 java-utils-2

DESCRIPTION="Opensource Implementation of WS-Management Client"
HOMEPAGE="http://sourceforge.net/projects/openwsman"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}/${PV}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+cim debug examples +eventing ipv6 java mono pam perl python plugins ruby ssl
+server test"

RDEPEND="
	cim? ( dev-libs/sblim-sfcc )
	ssl? ( dev-libs/openssl )
	pam? ( virtual/pam )
	ruby? ( <dev-lang/ruby-2 )
	perl? ( dev-lang/perl )
	java? ( virtual/jdk )
	plugins? ( dev-lang/swig )
	net-misc/curl[idn]
	dev-libs/libxml2[icu]
	"
DEPEND="
	${RDEPEND}
	test? ( dev-util/cunit )
	"

# LIBC != glibc build fail - add block
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

src_install() {
	cmake-utils_src_install

	newinitd "${FILESDIR}"/"${PN}"d.initd "${PN}"d
	newconfd "${FILESDIR}"/"${PN}"d.confd "${PN}"d
}

pkg_postinst() {
	if use ssl && [[ ! -f "${ROOT}"/etc/ssl/openwsman/servercert.pem \
		&& ! -f "${ROOT}"/etc/ssl/postfix/serverkey.pem ]] ; then
		SSL_ORGANIZATION="${SSL_ORGANIZATION:-Local OpenWSman Server}"
		install_cert /etc/openwsman/servercert
	fi
}
