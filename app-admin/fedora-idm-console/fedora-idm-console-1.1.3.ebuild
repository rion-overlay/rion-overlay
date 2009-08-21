# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg-2 eutils java-ant-2

MY_V=1.1.3

DESCRIPTION="A Java based remote management console used for Managing Fedora Administration / Directory Server."
HOMEPAGE="http://directory.fedoraproject.org/"
SRC_URI="http://directory.fedoraproject.org/sources/${P}.tar.bz2"
LICENSE="LGPL-2.1"
SLOT="1.1"
KEYWORDS="~x86"
IUSE=""

COMMON_DEP="=dev-java/jss-4*
	>=dev-java/ldapsdk-4.0
	>=dev-java/idm-console-framework-1.1"
RDEPEND="=virtual/jre-1.5*
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	${COMMON_DEP}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	java-pkg_jarfrom ldapsdk-4.1 ldapjdk.jar
	java-pkg_jarfrom jss-3.4 xpclass.jar jss4.jar
	java-pkg_jarfrom idm-console-framework-1.1
}

src_compile() {
	eant -Dbuilt.dir="${S}"/build \
	    -Dldapjdk.local.location="${S}" \
	    -Djss.local.location="${S}" \
	    -Dconsole.local.location="${S}" ${antflags}

}

src_install() {
	java-pkg_newjar "${S}"/build/fedora-idm-console-${MY_V}_en.jar fedora-idm-console_en.jar
	java-pkg_dolauncher ${PN} --main com.netscape.management.client.console.Console \
				--pwd "/usr/share/dirsrv/java/" \
				--pkg_args "-Djava.util.prefs.systemRoot=\"\$HOME/.${PN}\" -Djava.util.prefs.userRoot=\"\$HOME/.${PN}\""

	newicon "${S}"/com/netscape/management/client/theme/images/logo32.gif fedora.gif
	make_desktop_entry ${PN} "Fedora Management Console" fedora.gif Network
}
