# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils base cmake-utils multilib flag-o-matic

DESCRIPTION="A lightweigt RPC library based on XML and HTTP"
SRC_URI="http://rion-overlay.googlecode.com/files/${P}.tar.xz
		http://rion-overlay.googlecode.com/files/${P}.patch.tar.xz"
HOMEPAGE="http://xmlrpc-c.sourceforge.net/"

KEYWORDS="~amd64"
IUSE="curl cxx tools cgi +abyss"
LICENSE="BSD"
SLOT="0"

DEPEND="dev-libs/libxml2
	curl? ( net-misc/curl[kerberos] )"
RDEPEND="${DEPEND}"

pkg_pretend() {
	if ! use curl ; then
		ewarn "Curl support disabled: No client library will be be built"
	fi
}

src_prepare() {
#	EPATCH_EXCLUDE="xmlrpc-c-cmake.patch" 
	EPATCH_OPTS="-g0 -E --no-backup-if-mismatch -p1" EPATCH_FORCE="yes" EPATCH_SUFFIX="patch" epatch || die
#	EPATCH_OPTS="-g0 -E --no-backup-if-mismatch -p1" epatch "${WORKDIR}/patch"/xmlrpc-c-cmake.patch || die
}

src_configure() {
	append-flags "-Wno-uninitialized -Wno-unknown-pragmas -Wno-unused-result"

	local mycmakeargs=(
		-D_lib=$(get_libdir)
		-DENABLE_LIBXML2_BACKEND=ON
		-DBUILD_SHARED_LIBS=ON
		$(cmake-utils_use_enable tools)
		$(cmake-utils_use_enable cgi CGI_SERVER)
		$(cmake-utils_use_enable cxx CPLUSPLUS)
		$(cmake-utils_use_enable abyss ABYSS_SERVER)
		$(cmake-utils_use_enable abyss ABYSS_THREADS)
		)
	# $(cmake-utils_use_enable LIBXML2_BACKEND)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	cd "${WORKDIR}"
}

src_install() {

	cmake-utils_src_install
	nonfatal dodoc README
	nonfatal dodoc doc/*
}

src_test() {

	cd "${CMAKE_BUILD_DIR}"/test
	ln -s src-cgitest1 cgitest1
	cd "${S}"
	cmake-utils_src_test
}
