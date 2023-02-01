# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="LaunchDarkly Client-side SDK for C/C++"
HOMEPAGE="https://launchdarkly.com/"
SRC_URI="https://github.com/launchdarkly/c-client-sdk/archive/1.7.6.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/c-client-sdk-${PV}"

src_install() {
	insinto /usr/include/ldclient
	doins ldapi.h uthash.h
	use static-libs && dolib.a libldclientapi.a
	dolib.so libldclientapiplus.so
	dolib.so libldclientapi.so
}
