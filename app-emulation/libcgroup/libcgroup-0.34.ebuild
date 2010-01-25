# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

WANT_AUTOCONF="2.5"
WANT_AUTOMAKE="1.10"

inherit autotools eutils

DESCRIPTION="Library,tools and daemons that abstracts the  control group file system in Linux"
HOMEPAGE="http://libcg.sourceforge.net/"
SRC_URI="http://kent.dl.sourceforge.net/project/libcg/${PN}/v${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug pam +tool daemon"

DEPEND="sys-devel/flex
		sys-devel/bison
		pam? ( sys-libs/pam )"

RDEPEND="pam? ( sys-libs/pam )"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable pam) \
		$(use_enable tools) \
		$(use_enable daemon) || die "foo bo-bo"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"

	dodoc README README_daemon

#	doinitd "${FILESDIR}"/cgred

#	insinto /etc
#	doins "${S}/samples"/*.conf
}

pkg_postinst() {

	elog "init script not tested and not intalled"
	elog "If you have install daemon init script"
	elog "uncomment doinitd function,refresh Manifest"
	elog "and reinstall ebuild"
}
