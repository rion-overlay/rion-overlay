# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 eutils java-ant-2

MY_V=1.1.3

DESCRIPTION="A Java based console for remote management 389 server.Core files"
HOMEPAGE="http://directory.fedoraproject.org/"
SRC_URI="http://port389.org/sources/fedora-idm-console-${PV}.tar.bz2
	http://www.nongnu.org/smc/docs/smc-presentation2/pix/fedora.png"

LICENSE="LGPL-2.1"
SLOT="1.1"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/fedora-idm-console-${PV}

COMMON_DEP="dev-java/jss:3.4
			dev-java/ldapsdk:4.1
			>=dev-java/idm-console-framework-1.1
			app-admin/389-admin-console
			!app-admin/fedora-idm-console"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"

DEPEND=">=virtual/jdk-1.5
	${COMMON_DEP}"

src_unpack() {
	unpack fedora-idm-console-${PV}.tar.bz2
}
src_prepare() {

	java-pkg_jar-from ldapsdk-4.1 ldapjdk.jar
	java-pkg_jar-from jss-3.4 xpclass.jar jss4.jar
	java-pkg_jar-from idm-console-framework-1.1
}

src_compile() {
	eant -Dbuilt.dir="${S}"/build \
	    -Dldapjdk.local.location="${S}" \
	    -Djss.local.location="${S}" \
	    -Dconsole.local.location="${S}" ${antflags}

}

src_install() {
	java-pkg_newjar "${S}"/build/fedora-idm-console-${MY_V}_en.jar 389-idm-console_en.jar
	java-pkg_dolauncher ${PN} --main com.netscape.management.client.console.Console \
				--pwd "/usr/share/dirsrv/html/java/" \
				--pkg_args "-Djava.util.prefs.systemRoot=\"\$HOME/.${PN}\" -Djava.util.prefs.userRoot=\"\$HOME/.${PN}\""

	doicon "${DISTDIR}"/fedora.png
	make_desktop_entry ${PN} "Port389 Management Console" fedora.png Network
}
