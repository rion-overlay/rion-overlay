# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="2:2.4"
#WANT_AUTOMAKE="1.9"

inherit autotools-utils python eutils

DESCRIPTION="A cross-platform Enterprise Messaging system which implements the Advanced Message Queuing Protocol"
HOMEPAGE="http://qpid.apache.org"
SRC_URI="mirror://apache/qpid/${PV}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cpg libcman sasl xml infiniband ssl static-libs test"

COMMON_DEP="libcman? ( sys-cluster/cman-lib )
	cpg? ( sys-cluster/openais )
	>=dev-libs/boost-1.41.0-r3
	sasl? ( dev-libs/cyrus-sasl )
	xml? ( dev-libs/xerces-c
			dev-libs/xqilla[faxpp] )
	ssl? ( dev-libs/nss )
	infiniband? ( sys-infiniband/libibverbs
				sys-infiniband/librdmacm )"

DEPEND="sys-apps/help2man
	test? ( dev-util/valgrind )
	${COMMON_DEP}"

RDEPEND="${COMMON_DEP}"

S="${WORKDIR}/qpidc-${PV}"
DOCS=(DESIGN INSTALL README.txt RELEASE_NOTES SSL)
AUTOTOOLS_IN_SOURCE_BUILD=1

pkg_setup() {
	enewgroup qpidd
	enewuser qpidd -1 -1 -1 qpidd

	python_pkg_setup
	python_set_active_version 2
}

src_prepare() {
	eautoreconf
}

src_configure() {

	local myeconfargs=(
		--without-swig
		--without-doxygen
		--with-help2man
		$(use_with cpg)
		$(use_with libcman)
		$(use_with sasl)
		$(use_with xml)
		$(use_with infiniband rdma)
		$(use_with ssl)
		$(use_enable test valgrind)
		--localstatedir=/var )

	autotools-utils_src_configure
}

src_install() {

	autotools-utils_src_install -j1

	newinitd "${FILESDIR}/${PN}".init  qpidd
	newconfd "${FILESDIR}"/qpidd.etc-conf qpidd

	insinto /etc
	doins "${FILESDIR}"/qpidd.conf

	insinto /etc/qpid
	doins	"${FILESDIR}"/qpidd.policy

	keepdir /var/run/qpidd
	dodir -g qpidd -o qpidd -m 754 /var/lib/qpidd
	keepdir /var/lib/qpidd

}
