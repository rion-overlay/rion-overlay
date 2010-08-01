# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2  java-ant-2

DESCRIPTION="Dogtag Certificate System - Certificate Authority"
HOMEPAGE="http://pki.fedoraproject.org"
SRC_URI="http://pki.fedoraproject.org/pki/sources/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

COMMON_DEP=">=dev-java/jss-4.3
			dev-java/osutil
			app-crypt/pki-symkey
			dev-java/ldapsdk
			dev-java/tomcat-servlet-api:2.4
			dev-java/velocity"
# certsrv.jar cms.jar cmscore.jar cmsutil.jar nsutil.jar

DEPEND="${COMMON_DEP}
		>=virtual/jdk-1.6"
RDEPEND="${COMMON_DEP}
		>=virtual/jre-1.6"

src_prepare () {
	java-pkg_jar-from jss-3.4 xpclass.jar jss4.jar
}
src_compile() {
	eant \
		-Dinit.d="etc/init.d" \
		-Dproduct.ui.flavor.prefix="" \
		-Dproduct.prefix="pki" \
		-Dproduct="ca" \
		-Dversion="${PV}" \
		${antflags} build || die
}
