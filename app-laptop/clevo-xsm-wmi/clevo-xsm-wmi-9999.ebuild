# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit linux-mod git-r3

DESCRIPTION="A driver for the Clevo P15xSM(1)(-A)/P17xSM(-A)/P370SM-A Laptop models"
HOMEPAGE="https://bitbucket.org/tuxedocomputers/clevo-xsm-wmi"
EGIT_REPO_URI="https://bitbucket.org/tuxedocomputers/${PN}.git"

SLOT="0"
LICENSE="GPL-2+"
KEYWORDS=""
IUSE="systemd"

DEPEND="
    sys-kernel/linux-headers
    virtual/linux-sources
"
RDEPEND=""

KERN_MAX_VER=13
MODULE_NAMES="${PN}(wmi:${S}/module)"
MODULESD_CLEVO_XSM_WMI_DOCS="README.md"

pkg_setup() {
	CONFIG_CHECK="ACPI_WMI"
	linux-mod_pkg_setup
	BUILD_TARGETS="all"
}

src_prepare() {
	kernel_is gt 4 ${KERN_MAX_VER} 99 && eapply "${FILESDIR}"/wmi-id.patch
	eapply_user
}

src_compile() {
    BUILD_PARAMS="KDIR=${KV_OUT_DIR}"
    linux-mod_src_compile
}

src_install() {
    linux-mod_src_install
    if use systemd; then
        mkdir ${D}/etc/modules-load.d || die
        echo "${PN}" > ${D}/etc/modules-load.d/${PN}.conf
    fi
}
