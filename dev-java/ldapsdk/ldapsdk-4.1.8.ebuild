# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

EAPI="1"

JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Netscape Directory SDK for Java"
HOMEPAGE="http://www.mozilla.org/directory/javasdk.html"
SRC_URI="http://rion-overlay.googlecode.com/files/"${P}".tar.bz2"

# To prepare this tarball
# cvs -d :pserver:anonymous@cvs-mirror.mozilla.org:/cvsroot export \
#    -rLDAPJavaSDK_418 DirectorySDKSourceJava
# tar cvjf ldapsdk-4.1.8.tar.bz2 mozilla/directory/ldapsdk/*

LICENSE="MPL-1.1"
SLOT="4.1"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=">=virtual/jre-1.5
		dev-java/jss:3.4"

DEPEND=">=virtual/jdk-1.5
		app-arch/zip
	${RDEPEND}"

src_unpack() {
	unpack ${A}

	cd "${S}"
	epatch "${FILESDIR}"/*.patch

	echo "jss.jar=$(java-pkg_getjars jss-3.4)" >> build.properties

	cd "${S}"/ldapjdk/lib
	rm -f *.jar
	java-pkg_jar-from jss-3.4

	cd "${S}"/ldapsp/lib
	rm *.jar

	java-pkg_filter-compiler jikes
}

src_compile() {
	eant dist-jdk dist-filter dist-beans dist-jndi $(use_doc build-docs)
}

src_install() {
	java-pkg_dojar dist/packages/*.jar

	use doc && java-pkg_dojavadoc dist/doc/ldapsp
	use source && \
		java-pkg_dosrc {ldapsp,ldapjdk}/com	{ldapjdk,ldapbeans,ldapfilter}/netscape
}
