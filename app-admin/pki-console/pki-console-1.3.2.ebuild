# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
JAVA_PKG_IUSE=""

inherit java-pkg-2 eutils java-ant-2

DESCRIPTION="PKI console for management of the CA, DRM, OCSP, and TKS subsystems"
HOMEPAGE="http://pki.fedoraproject.org"
SRC_URI="http://pki.fedoraproject.org/pki/sources/${PN}/${P}.tar.gz
	http://www.nongnu.org/smc/docs/smc-presentation2/pix/fedora.png -> pki-fedora.png"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""
SLOT="0"

COMMON_DEP=">=dev-java/jss-4.3
	>=dev-java/ldapsdk-4.0
	>=dev-java/idm-console-framework-1.1
	app-pki/pki-util
	!app-admin/fedora-idm-console"
RDEPEND=">=virtual/jre-1.6
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.6
	${COMMON_DEP}"

src_unpack() {
	unpack ${P}.tar.gz
}

src_prepare() {
	epatch "${FILESDIR}/gentoo.patch"

	java-pkg_jarfrom ldapsdk-4.1 ldapjdk.jar
	java-pkg_jarfrom jss-3.4 xpclass.jar jss4.jar
	java-pkg_jarfrom idm-console-framework-1.1
	java-pkg_jarfrom pki-util nsutil.jar
	java-pkg_jarfrom pki-util  cmsutil.jar
}

src_compile() {
	eant -Dproduct.prefix="" \
		-Dproduct="${PN}" \
		-Dversion="${PV}" \
		-Dproduct.ui.flavor.prefix="" \
		${antflags} \
				build_jars || die
}

src_install() {
	java-pkg_newjar "${S}"/build/jars/"${P}"_en.jar ${PN}_en.jar
	java-pkg_newjar "${S}"/build/jars/"${P}".jar ${PN}.jar
	java-pkg_dolauncher ${PN} --main com.netscape.management.client.console.Console \
		--pwd "/usr/share/pki/html/java/" \
				--pkg_args "-Djava.util.prefs.systemRoot=\"\$HOME/.${PN}\" -Djava.util.prefs.userRoot=\"\$HOME/.${PN}\""

	doicon "${DISTDIR}"/pki-fedora.png
	make_desktop_entry ${PN} "DogTag PKI Management Console" fedora.png Network
}
