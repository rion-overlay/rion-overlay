# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Virtual for qemu and kvm packages"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="kvm spice"
REQUIRED_USE="spice? ( kvm )"

DEPEND="kvm? ( || ( app-emulation/qemu-kvm[spice?]
					app-emulation/qemu-kvm-spice )
			)
		!kvm? ( || ( app-emulation/qemu-kvm
					app-emulation/qemu
					app-emulation/qemu-kvm-spice )
			)
"
RDEPEND="${DEPEND}"
