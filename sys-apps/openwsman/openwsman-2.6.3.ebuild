# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1 cmake-utils ssl-cert java-pkg-opt-2

DESCRIPTION="Opensource Implementation of WS-Management Client"
HOMEPAGE="https://github.com/Openwsman"
SRC_URI="https://github.com/Openwsman/openwsman/archive/v2.6.3.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BINDINGS_USE="java perl python ruby"
IUSE="+cim debug examples +eventing ipv6 pam +plugins ssl +server test ${BINDINGS_USE}"
REQUIRED_USE="
	java? ( plugins )
	perl? ( plugins )
	python? ( plugins )
	ruby? ( plugins )
"

JAVA_PKG_NV_DEPEND="virtual/jdk:1.8"
RDEPEND="
	cim? ( dev-libs/sblim-sfcc )
	ssl? ( dev-libs/openssl:0 )
	pam? ( virtual/pam )
	ruby? ( dev-lang/ruby )
	perl? ( dev-lang/perl )
	java? ( ${JAVA_PKG_NV_DEPEND} )
	python? ( ${PYTHON_DEPS} )
	net-misc/curl[idn]
	dev-libs/libxml2[icu]
	"
DEPEND="
	${RDEPEND}
	test? ( dev-util/cunit )
	java? ( dev-lang/swig:0 )
	perl? ( dev-lang/swig:0 )
	python? ( dev-lang/swig:0 )
	ruby? ( dev-lang/swig:0 )
	"

# LIBC != glibc build fail - add block
src_prepare(){
	#Ruby gem builder does not like Unicode
	sed -e 's/Kämpf/Kaempf/' -i bindings/ruby/openwsman.gemspec.in
	default
}

src_configure() {
	local bindings=NO
	for f in $BINDINGS_USE; do
		use $f && bindings=YES
	done
	local mycmakeargs=(
		-DPACKAGE_ARCHITECTURE=${ARCH}
		-DBUILD_BINDINGS=${bindings}
		-DBUILD_CUNIT_TESTS=$(usex test)
		-DBUILD_EXAMPLES=$(usex examples)
		-DBUILD_JAVA=$(usex java)
		-DBUILD_LIBCIM=$(usex cim)
		-DBUILD_PERL=$(usex perl)
		-DBUILD_PYTHON=$(usex python)
		-DBUILD_RUBY=$(usex ruby)
		-DBUILD_SWIG_PLUGIN=${bindings}
		-DBUILD_TESTS=$(usex test)
		-DDISABLE_PLUGINS="$(usex plugins)
		-DDISABLE_SERVER="$(usex server)
		-DENABLE_EVENTING_SUPPORT="$(usex eventing)
		-DWSMAN_DEBUG_VERBOSE="$(usex debug)
		-DENABLE_IPV6="$(usex ipv6)
		-DUSE_PAM="$(usex pam)
	)
	use ruby && mycmakeargs+=( -DBUILD_RUBY_GEM=YES )
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
