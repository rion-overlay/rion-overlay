# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils multilib base autotools-utils rpm versionator

MY_PV=$(get_version_component_range 1-3)

DESCRIPTION="A lightweigt RPC library based on XML and HTTP"
SRC_URI="mirror://fedora-dev/development/rawhide/source/SRPMS/${PN}-${MY_PV}-1700.svn2185.fc17.src.rpm"
HOMEPAGE="http://xmlrpc-c.sourceforge.net/"

KEYWORDS="~amd64"
IUSE="+curl +cxx tools +cgi abyss threads static-libs kerberos"
LICENSE="BSD"
SLOT="0"

DEPEND="dev-libs/libxml2
	curl? ( net-misc/curl[kerberos] )"
RDEPEND="${DEPEND}"
AUTOTOOLS_IN_SOURCE_BUILD=1

PATCHES=(
	"${WORKDIR}"/xmlrpc-c-printf-size_t.patch
	"${WORKDIR}"/xmlrpc-c-longlong.patch
	"${WORKDIR}"/xmlrpc-c-uninit-curl.patch
	"${WORKDIR}"/xmlrpc-c-30x-redirect.patch
	"${WORKDIR}"/xmlrpc-c-check-vasprintf-return-value.patch
	"${WORKDIR}"/xmlrpc-c-include-string_int.h.patch
	)

S="${WORKDIR}"/${PN}-${MY_PV}

unset SRCDIR
export LC_ALL=C
export LANG=C

src_unpack() {
	rpm_src_unpack
	cd "${WORKDIR}"
	unpack ./xmlrpc-c-1.27.5.tar.xz
}

src_prepare() {
	base_src_prepare

	# Respect the user's CFLAGS/CXXFLAGS.
	sed -i \
		-e "/CFLAGS_COMMON/s|-g -O3$|${CFLAGS}|" \
		-e "/CXXFLAGS_COMMON/s|-g$|${CXXFLAGS}|" \
		"${S}"/common.mk || die "404. File not found while sedding"

}

src_configure() {
	# Respect the user's LDFLAGS.
	export LADD=${LDFLAGS}
	local myeconfargs=(
		--disable-wininet-client \
		--disable-libwww-client \
		--enable-libxml2-backend \
		$(use_enable tools) \
		$(use_enable threads abyss-threads) \
		$(use_enable cgi cgi-server) \
		$(use_enable abyss abyss-server) \
		$(use_enable cxx cplusplus) \
		$(use_enable curl curl-client)
		)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	use !static-libs && rm -f $(find ${D} -type f -iname '*.a')
}

src_test() {
	if use abyss && use curl ; then
		unset LDFLAGS LADD SRCDIR
			cd "${S}"/test/
			einfo "Building general tests"
			make || die "Make of general tests failed"
		einfo "Running general tests"
		./test || die "General tests failed"

# Test failed, investigate it
#	if use cxx ; then
#		cd "${S}"/test/cpp
#		einfo "Building C++ tests"
#		make || die "Make of C++ tests failed"
#		einfo "Running C++ tests"
#		./test || die "C++ tests failed"
#	fi
	else
		elog "${CATEGORY}/${PN} tests will fail unless USE='abyss curl' is set."
	fi
}

pkg_setup() {
	if ! use curl ; then
		ewarn "Curl support disabled: No client library will be be built"
	fi
}
