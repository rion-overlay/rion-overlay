# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
JAVA_PKG_IUSE=""

inherit java-pkg-2 java-ant-2

DESCRIPTION="Symmetric Key JNI Package"
HOMEPAGE="http://pki.fedoraproject.org"
SRC_URI="http://pki.fedoraproject.org/pki/sources/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEP="dev-java/jss
			>=dev-libs/nspr-4.7
			>=dev-libs/nss-3.12.5
			dev-java/ldapsdk
			"
RDEPEND=">=virtual/jre-1.6
		${COMMON_DEP}"

DEPEND=">=virtual/jdk-1.6
		dev-util/pkgconfig
		${COMMON_DEP}"

EANT_BUILD_TARGET=""
EANT_DOC_TARGET=""

src_prepare() {
	java-pkg_jar-from jss-3.4 xpclass.jar jss4.jar
	java-pkg_jar-from ldapsdk-4.1 ldapjdk.jar

	epatch "${FILESDIR}"/*.patch

	#Not complete 
#	eerror "not use"

}
src_compile() {
	eant \
		-Dproduct.ui.flavor.prefix="" \
		-Dproduct.prefix="" \
		 -Dproduct="${PN}" \
		 -Dversion="${PV}" \
		  ${antflags} build_jars  build_jni_headers  || die "eant failed"
}

src_install() {
	java-pkg_dojar build/jars/symkey.jar

}
