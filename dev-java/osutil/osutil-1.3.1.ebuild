# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2 rpm

DESCRIPTION="Operating System Utilities JNI Package"
HOMEPAGE="http://pki.fedoraproject.org"
SRC_URI="http://pki.fedoraproject.org/pki/sources/${PN}/${P}.tar.gz"

LICENSE="GPL-2-with-exceptions"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEP=">=dev-libs/nspr-4.7
			>=dev-libs/nss-3.12.4"

RDEPEND="virtual/jre:1.6
		${COMMON_DEP}"
DEPEND="virtual/jdk:1.6
		${COMMON_DEP}"

src_compile() {
	eant \
		-Dproduct.ui.flavor.prefix="" \
		-Dproduct.prefix="" \
		-Dproduct="${PN}" \
		-Dversion=${PV} \
		build ${antflags} || die
}
src_install() {
	java-pkg_dojar  "${S}/build/jars"/osutil.jar

	}
