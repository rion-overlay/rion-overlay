# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="VirtIO Windows (r) KVM guest drivers from RedHat"
HOMEPAGE="http://alt.fedoraproject.org/pub/alt/virtio-win/latest/images/bin/"
SRC_URI="http://alt.fedoraproject.org/pub/alt/virtio-win/latest/images/bin/virtio-win-0.1-52.iso"

LICENSE="GPL-2"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_unpack() {
	cp "${DISTDIR}"/virtio-win-0.1-52.iso  .
}

src_install() {
	insinto /var/lib/libvirt/images/
	doins virtio-win-0.1-52.iso
}
