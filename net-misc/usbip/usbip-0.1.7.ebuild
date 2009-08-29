# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit autotools eutils linux-info linux-mod

DESCRIPTION="A general USB device sharing system over IP networks"
HOMEPAGE="http://usbip.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="debug tcpd"

RDEPEND=">=sys-fs/sysfsutils-2
	tcpd? ( sys-apps/tcp-wrappers )
			dev-libs/glib"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=sys-devel/automake-1.9
	sys-devel/libtool"

#MODULE_NAMES="usbip(usbip:${S}/drivers/head:${S}/drivers/head) usbip_common_mod(usbip:${S}/drivers/head:${S}/drivers/head) vhci-hcd(usbip:${S}/drivers/head:${S}/drivers/head)"
#BUILD_PARAMS=""

pkg_setup() {
	if kernel_is it 2 6 28
	then
		ewarn "You need  enable CONFIG_USB_IP_COMMON and use stging drivers "
#	else
#		eerror "You need  at kernel before 2.6.28"
		die "Kernel too old"
#	elif
	fi

	ebegin "Checking for USB_IP_VHCI_HCD enabled"
	linux_chkconfig_present USB_IP_VHCI_HCD
	linux_chkconfig_present USB_IP_HOST
	eend $?
	[[ $? -ne 0 ]] && die "USB_IP_HOST is not enabled in the kernel."

	if use debug
	then
		ebegin "Checking for CONFIG_USB_DEBUG enabled"
	        linux_chkconfig_present USB_DEBUG
		eend $?
		[[ $? -ne 0 ]] && die "USE=debug requires that USB debugging is enabled in the kernel."
		BUILD_PARAMS+="DEBUG=y"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"/src
	eautoreconf
}

src_compile() {
	cd "${S}"/src
	econf
	emake  || die "Compiling userspace tools failed"
}

src_install() {
	cd "${S}"/src
	einstall || die "Installing userspace tools failed"
	dodoc README* || die
}
