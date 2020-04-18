# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit unpacker

DESCRIPTION="Power-management systemd services for proprietary nvidia-drivers"
HOMEPAGE="https://www.nvidia.com/"
AMD64_NV_PACKAGE="NVIDIA-Linux-x86_64-${PV}"
NV_URI="https://us.download.nvidia.com/XFree86/"
SRC_URI="
	amd64? ( ${NV_URI}Linux-x86_64/${PV}/${AMD64_NV_PACKAGE}.run )
"

LICENSE="GPL-2 NVIDIA-r2"
SLOT="0/${PV%.*}"
KEYWORDS="-* ~amd64"
IUSE=""

DEPEND="x11-drivers/nvidia-drivers:=[-amd64-fbsd]"
RDEPEND="${DEPEND}
	sys-apps/kbd
	sys-apps/systemd"
BDEPEND=""
S=${WORKDIR}/

src_install() {
	insinto /lib/systemd/system
	doins *.service
	exeinto /lib/systemd/system-sleep
	doexe nvidia
	exeinto /usr/bin
	doexe nvidia-sleep.sh
	echo "options nvidia NVreg_PreserveVideoMemoryAllocations=1" > nvidia-pm.conf
	insinto /etc/modprobe.d/
	doins nvidia-pm.conf

	ewarn "To enable nvidia sleep services execute next commands:"
	ewarn "    systemctl enable nvidia-suspend.service"
	ewarn "    systemctl enable nvidia-hibernate.service"
	ewarn "    systemctl enable nvidia-resume.service"
	ewarn "Note nvidia kernel module reload (or reboot) is required"
	ewarn "to accept new driver options."
	ewarn "More details at /usr/share/doc/nvidia-drivers-${PV}/html/powermanagement.html"
}
