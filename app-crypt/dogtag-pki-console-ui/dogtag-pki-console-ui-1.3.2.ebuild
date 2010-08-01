# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 eutils java-ant-2

DESCRIPTION="Dogtag Certificate System - PKI Console User Interface"
HOMEPAGE="http://pki.fedoraproject.org"
SRC_URI="http://pki.fedoraproject.org/pki/sources/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEP=">=dev-java/jss:4.3-4.2.6
			dev-java/ldapsdk:4.1"

DEPEND="${COMMON_DEPEND}
		>=virtual/jdk-1.5"
RDEPEND="${COMMON_DEPEND}
		>=virtual/jre-1.5"

src_prepare() {
	java-pkg_jar-from ldapsdk-4.1 ldapjdk.jar
	java-pkg_jar-from jss-3.4 xpclass.jar jss4.jar
}

src_compile() {
	eant \
		-Dproduct.ui.flavor.prefix="dogtag" \
		-Dproduct.prefix="pki" \
		-Dproduct="console-ui" \
		-Dversion="${PV}"\
		${antflags} build || die
}

src_install() {
	java-pkg_newjar "${S}"/build/jars/cms-theme-1.3.2_en.jar cms-theme_en.jar
	use source && java-pkg_dosrc src/com
}
