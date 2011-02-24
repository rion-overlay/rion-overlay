# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

WANT_CMAKE="always"

inherit cmake-utils multilib

DESCRIPTION="spmfilter - mail filtering framework"
HOMEPAGE="http://www.spmfilter.org"
SRC_URI="http://www.spmfilter.org/attachments/download/60/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="berkdb debug ssl ldap zdb"

RDEPEND="net-libs/libesmtp[ssl?]
	dev-libs/glib:2
	>=dev-libs/gmime-2.2
	app-arch/gzip
	ldap? ( net-nds/openldap )
	berkdb? ( =sys-libs/db-4* )
	zdb? ( dev-libs/libzdb )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

DOCS="AUTHORS INSTALL README"

src_configure() {
	local mycmakeargs="$(cmake_use_enable debug) \
						$(my-cmake_use_without zdb ZDB) \
						$(my-cmake_use_without ldap LDAP) \
						$(my-cmake_use_without berkdb DB4)"
	use amd64	&& mycmakeargs+=" -DLIBDIR:STRING=lib64 "
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	dodir /etc/env.d
	echo LDPATH=/usr/$(get_libdir)/${PN} > "${D}/etc/env.d/99${PN}" || die "env.d files install failed"

	insinto /etc
	newins spmfilter.conf.sample spmfilter.conf

	 doinitd "${FILESDIR}"/spmfilter
	 newconfd "${FILESDIR}"/spmfilter.conf spmfilter
}

# Internal functions used by cmake-utils_use_*
#pasted in cmake-utils eclass
my-cmake_use_without() { _use_me_now_inverted WITHOUT_ "$@" ; }
