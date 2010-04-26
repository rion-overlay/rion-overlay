# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

DESCRIPTION="CacheFiles is a caching directory on an already mounted filesystem"
HOMEPAGE="http://people.redhat.com/~dhowells/fscache/"
SRC_URI="http://people.redhat.com/~dhowells/fscache/${P}.tar.bz2"

IUSE="doc"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	# fix Makefile
	sed -e '/CFLAGS/s/-O2/${CFLAGS}/' -i Makefile || die
}
src_install() {
	emake DESTDIR="${D}"  install || die "install failed"

	dodoc README howto.txt

	newconfd "${FILESDIR}"/cachefilesd.conf cachefilesd
	newinitd "${FILESDIR}"/cachefilesd.init-r1 cachefilesd

	keepdir /var/cache/cachefilesd
}

pkg_postinst() {
	[[ -d /var/fscache ]] && return
	elog "Before CacheFiles can be used, a directory for local storage"
	elog "must be created.  The default configuration of /etc/cachefilesd.conf"
	elog "uses /var/fscache.  The filesystem mounted there must support"
	elog "extended attributes (mount -o user_xattr)."
	elog ""
	elog "Once that is taken care of, start the daemon, add -o ...,fsc"
	elog "to the mount options of your network mounts, and let it fly!"
}
