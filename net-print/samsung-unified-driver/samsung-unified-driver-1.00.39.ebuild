# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info udev vcs-snapshot

EXTRA_PV=01.17
MY_P=uld_V${PV}_${EXTRA_PV}

DESCRIPTION="Samsung Unified Linux Driver for printers and MFDs"
HOMEPAGE="http://www.samsung.com"
SRC_URI="https://ftp.hp.com/pub/softlib/software13/printers/SS/SL-M4580FX/${MY_P}.tar.gz"

LICENSE="Samsung-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="cups network scanner"
S="${WORKDIR}/${MY_P}"

RDEPEND="
	cups? (
		net-print/cups
		!net-print/splix
	)
	scanner? (
		media-gfx/sane-backends
		dev-libs/libxml2:2
		virtual/libusb:0
	)
	network? ( virtual/libusb )
"

REQUIRED_USE="
	network? ( cups )
	|| ( cups scanner )
"

RESTRICT="mirror strip"

pkg_pretend() {
	if use scanner && ! has_version ${CATEGORY}/${PN}[scanner]; then
		if ! linux_config_exists || linux_chkconfig_present USB_PRINTER; then
			ewarn "Samsung USB MFDs are normally managed via libusb."
			ewarn "In this case, you need to either disable the USB_PRINTER"
			ewarn "support in your kernel, or blacklist the 'usblp' module."
		fi
	fi
}

pkg_setup() {
	if use cups; then
		QA_SONAME="usr/$(get_libdir)/libscmssc.so"
		QA_FLAGS_IGNORED+=" usr/$(get_libdir)/libscmssc.so"
		QA_FLAGS_IGNORED+=" usr/libexec/cups/filter/pstosecps"
		QA_FLAGS_IGNORED+=" usr/libexec/cups/filter/rastertospl"
	fi
	if use scanner; then
		QA_FLAGS_IGNORED+=" usr/$(get_libdir)/sane/libsane-smfp.so.1.0.1"
	fi
	if use network; then
		QA_FLAGS_IGNORED+=" usr/libexec/cups/backend/smfpnetdiscovery"
	fi
}

src_install() {
	local MY_ARCH="x86_64"
	use x86 && MY_ARCH="i386"

	# Printer support.
	if use cups; then
		# libscmssc.so is required by rastertospl.
		dolib.so ${MY_ARCH}/libscmssc.so

		exeinto /usr/libexec/cups/filter
		doexe ${MY_ARCH}/{pstosecps,rastertospl}

		dodir /usr/share/cups/model/samsung
		insinto /usr/share/cups/model/samsung
		doins noarch/share/ppd/*.ppd
		gzip -9 "${ED}"/usr/share/cups/model/samsung/*.ppd || die

		dodir /usr/share/cups/profiles/samsung
		insinto /usr/share/cups/profiles/samsung
		doins noarch/share/ppd/cms/*.cts
	fi

	# Scanner support.
	if use scanner; then
		insinto /etc/sane.d
		doins noarch/etc/smfp.conf

		dodir /opt/samsung/scanner/share
		insinto /opt/samsung/scanner/share
		doins noarch/oem.conf

		exeinto /usr/$(get_libdir)/sane
		doexe ${MY_ARCH}/libsane-smfp.so.1.0.1

		dosym libsane-smfp.so.1.0.1 /usr/$(get_libdir)/sane/libsane-smfp.so
		dosym libsane-smfp.so.1.0.1 /usr/$(get_libdir)/sane/libsane-smfp.so.1

		udev_newrules "${FILESDIR}/${PV}-libsane-smfp.rules" 40-libsane-smfp.rules
		insinto /etc/sane.d/dll.d
		echo smfp > "${ED}"/etc/sane.d/dll.d/samsung.conf
	fi

	# Network support.
	if use network; then
		exeinto /usr/libexec/cups/backend
		doexe ${MY_ARCH}/smfpnetdiscovery
	fi
}
