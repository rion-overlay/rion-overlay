# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils git-2 linux-info linux-mod systemd

DESCRIPTION="Hardware Against Software Piracy for access to parallel and usb keys"
HOMEPAGE="http://www.etersoft.ru"
EGIT_REPO_URI="git://git.etersoft.ru/people/piastry/packages/haspd.git"

LICENSE="Etersoft"
SLOT="0"
KEYWORDS=""

IUSE="net_hasp wine usb lpt demo"

MODNAME="aksparlnx"
[[ ${ARCH} == "amd64" ]] && MY_ARCH="x86_64"
[[ ${ARCH} == "x86" ]] && MY_ARCH="i386"

REQUIRED_USE="lpt? ( kernel_linux )"
DEPEND="${RDEPEND}"

QA_PREBUILT="usr/sbin/aksusbd usr/sbin/haspdemo usr/sbin/winehasp
usr/sbin/hasplm usr/sbin/hasplmd usr/sbin/nethaspdemo"

S="${WORKDIR}/haspd-3.2"

pkg_setup() {
	if use lpt ; then
		MODULE_NAMES="${MODNAME}(${MODNAME}:${S}/${MODNAME})"
		CONFIG_CHECK="PARPORT PARPORT_PC"

		linux-mod_pkg_setup
		if kernel_is 3 ; then
			BUILD_PARAMS="KERNSRC=${KERNEL_DIR}" BUILD_TARGETS="kernel26" || die
		elif kernel_is 2 6 ; then
			BUILD_PARAMS="KERNSRC=${KERNEL_DIR}" BUILD_TARGETS="kernel26" || die
		elif kernel_is 2 4 ; then
			BUILD_PARAMS="KERNSRC=${KERNEL_DIR}" BUILD_TARGETS="kernel24" || die
		fi
	fi
	if use usb; then
		CONFIG_CHECK="${CONFIG_CHECK} ~USB_DEVICEFS"
	fi
	linux-info_pkg_setup
}

src_compile() {
	if use lpt ; then
		cd "${S}/${MODNAME}"
		ARCH="${MY_ARCH}" emake "${BUILD_PARAMS}" "${BUILD_TARGETS}" || die
	fi
}

src_install() {
	dodir "/usr/sbin"
	dodir "/etc/init.d"
	dosbin aksusbd/aksusbd
	newinitd "${FILESDIR}"/aksusbd.init aksusbd
	systemd_dounit "${FILESDIR}"/hasp.service

	use demo && dosbin hasptest/haspdemo

	if use wine; then
		dosbin winehasp/winehasp
		newinitd "${FILESDIR}"/winehasp.init winehasp
	fi
	newinitd "${FILESDIR}"/aksusbd.init aksusbd

	if use net_hasp ; then
		insinto /etc/haspd
		doins hasplm/hasplm.conf

		newconfd  "${FILESDIR}"/hasplm.conf hasplm
		dosbin hasplm/hasplm
		dosbin hasplmd/hasplmd
		use demo && dosbin hasptest/nethaspdemo
		newinitd "${FILESDIR}"/hasplmd.init hasplmd
	fi

	if use lpt ; then
		linux-mod_src_install || die
		dodir /lib/udev/rules.d
		insinto /lib/udev/rules.d
		doins "${FILESDIR}"/55-lpt-hardlock.rules
	fi
}
