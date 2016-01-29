# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils rpm linux-info linux-mod systemd

DESCRIPTION="Hardware Against Software Piracy for access to parallel and usb keys"
HOMEPAGE="http://www.etersoft.ru"
SRC_URI="http://ftp.etersoft.ru/pub/Etersoft/HASP/3.3/sources/Gentoo/2009/haspd-3.3-eter5gentoo.src.rpm"

LICENSE="Etersoft"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="net_hasp wine usb lpt demo"

MODNAME="aksparlnx"
[[ ${ARCH} == "amd64" ]] && MY_ARCH="x86_64"
[[ ${ARCH} == "x86" ]] && MY_ARCH="i386"

REQUIRED_USE="lpt? ( kernel_linux )"
DEPEND="${RDEPEND}"

QA_PREBUILT="usr/sbin/aksusbd usr/sbin/haspdemo usr/sbin/winehasp
usr/sbin/hasplm usr/sbin/hasplmd usr/sbin/nethaspdemo"

S="${WORKDIR}/haspd-3.3"

pkg_setup() {
	if use lpt ; then
		MODULE_NAMES="${MODNAME}(${MODNAME}:${S}/${MODNAME})"
		CONFIG_CHECK="PARPORT PARPORT_PC"

		linux-mod_pkg_setup
		BUILD_PARAMS="KERNSRC=${KERNEL_DIR}" BUILD_TARGETS="kernel3"
	fi
}

src_unpack() {
	rpm_unpack
	unpack ./haspd-3.3.tar
}

src_prepare() {
	epatch "${FILESDIR}/remove-udev-rule-for-old-kernels.patch"
	epatch "${FILESDIR}/linux-3.15.patch"
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

	use lpt && linux-mod_src_install
	local udevrulesdir="$($(tc-getPKG_CONFIG) --variable=udevdir udev)/rules.d"
	dodir ${udevrulesdir}
	insinto ${udevrulesdir}
	use lpt && doins "${FILESDIR}"/80-lpt-hardlock.rules
	use usb && doins aksusbd/udev/rules.d/80-hasp.rules
}
