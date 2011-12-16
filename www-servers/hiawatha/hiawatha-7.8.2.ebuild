# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools-utils

DESCRIPTION="Advanced and secure webserver"
HOMEPAGE="http://www.hiawatha-webserver.org"
SRC_URI="http://www.hiawatha-webserver.org/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+cache chroot +command ipv6 monitor ssl toolkit xslt"

DEPEND="ssl?  ( dev-libs/openssl )
	 	xslt? ( dev-libs/libxslt
	 		dev-libs/libxml2 )"
RDEPEND="${DEPEND}"

REQUIRED_USE="monitor? ( xslt )"
# monitor and xslt depend own
src_configure() {
	local myeconfargs=(
		$(use_enable cache)
		$(use_enable chroot)
		$(use_enable command)
		$(use_enable ipv6)
		$(use_enable monitor)
		$(use_enable ssl)
		$(use_enable toolkit)
		$(use_enable xslt)
		--localstatedir=/var )
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	newinitd "${FILESDIR}"/hiawatha.init  hiawatha
	newinitd "${FILESDIR}"/php-fcgi_hiawatha.init  hiawatha_php-fcgi

	# logrotate script
	diropts -m0755
	insinto /etc/logrotate.d
	insopts -m0644
	newins "${S}"/etc/logrotate.d/hiawatha hiawatha.logrotate

	keepdir /var/l{ib,og}/hiawatha /var/www/localhost/htdocs
}
