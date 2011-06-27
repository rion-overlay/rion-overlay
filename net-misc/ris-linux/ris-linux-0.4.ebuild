# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils python

DESCRIPTION="BINL server to doing Windows(r) RIS"
HOMEPAGE="http://oss.netfarm.it/guides/pxe.php"
SRC_URI="http://oss.netfarm.it/guides/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare(){
	sed "s:VERSION:${PV}:" "${FILESDIR}"/setup.py > "${S}"/setup.py
	distutils_src_prepare
}

src_install() {
	distutils_src_install
	insinto /usr/share/ris-linux-${PV}
	doins winnt.sif
	doins winpe.sif

	newinitd "${FILESDIR}"/binlsrv.initd binlsrv
	newconfd "${FILESDIR}"/binlsrv.confd binlsrv
}

pkg_postinst(){
elog "This packet contain only BINL serwer"
elog ""
elog "please, install net-ftp/atftp[ris] OR net-ftp/tftp-hpa[ris]"
elog "for PXE boot"
elog "net-misc/dhcp for DHCP"
elog "net-fs/samba for Windows share folders's"
elog "additionally, you can install sys-boot/syslinux for boot menu "

elog "Read more info:"
elog "http://wiki.themel.com/XPNetInstall , http://oss.netfarm.it/guides/pxe.php"
elog "http://unattendedxp.com/articles/wxpris  (in russian)"
}
