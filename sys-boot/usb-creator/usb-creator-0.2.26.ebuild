# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

SUPPORT_PYTHON_ABIS="1"
PYTHON_DEPEND="2"
RESTRICT_PYTHON_ABIS="3.*"
inherit distutils

DESCRIPTION="create a startup disk using a CD or disc image"
HOMEPAGE="http://launchpad.net/usb-creator"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-devel/gettext
	dev-python/python-distutils-extra"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}.trunk"
