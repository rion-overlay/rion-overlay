# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2 rpm

DESCRIPTION="Operating System Utilities JNI Package - Dog Tag pki system"
HOMEPAGE="http://pki.fedoraproject.org"
SRC_URI="http://pki.fedoraproject.org/pki/download/pki/1.2.0/fc11/SRPMS/osutil-1.2.0-2.fc11.src.rpm"

LICENSE="GPL-2-with-exceptions"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

COMMON_DEP=""

RDEPEND="virtual/jre:1.6
	${COMMON_DEP}"
DEPEND="virtual/jdk:1.6
	${COMMON_DEP}"

EANT_BUILD_TARGET=""
EANT_DOC_TARGET=""

src_compile() {
	eant -Dspecfile=osutil.spec \
	 ${antflags} build_jars build_jni_headers || die "eant compile failed"
}
src_install() {
	java-pkg_newjar  "${S}"/build/jars/osutil.jar osutil.jar

	insinto /usr/include/osutil
	doins -r "${S}"/build/include/*.h
}
