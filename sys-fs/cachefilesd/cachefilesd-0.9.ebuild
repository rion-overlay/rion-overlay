# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils
DESCRIPTION="CacheFiles is a caching directory on an already mounted filesystem"

HOMEPAGE="http://people.redhat.com/~dhowells/fscache/"
SRC_URI="http://people.redhat.com/~dhowells/fscache/${P}.tar.bz2
		doc? ( http://people.redhat.com/~dhowells/fscache/FS-Cache.pdf )"

IUSE="doc"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

src_unpack() {
	unpack ${P}.tar.bz2
}
src_install() {
	emake DESTDIR="${D}"  install || die "install failed"
	dodoc README howto.txt move-cache.txt
	newconfd "${FILESDIR}"/cachefilesd.conf cachefilesd
	newinitd "${FILESDIR}"/cachefilesd.init cachefilesd
	keepdir /var/cache/cachefilesd
	if use doc; then
		dodir /usr/share/doc/${P}/pdf
		insinto /usr/share/doc/${P}/pdf
		doins "${DISTDIR}"/FS-Cache.pdf
	fi
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
#1. emerge sys-fs/cachefilesd
#2. mkdir /var/fscache; /etc/init.d/cachefilesd start
#3. mount -t nfs -o fsc server:/export /mnt/path
