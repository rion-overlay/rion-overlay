# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools

S="${WORKDIR}/GNUnet-${PV}"
DESCRIPTION="GNUnet is an anonymous, distributed, reputation based network."
HOMEPAGE="http://gnunet.org/"
SRC_URI="http://gnunet.org/download/GNUnet-${PV}.tar.bz2"
#tests don't work
RESTRICT="test"

IUSE="ipv6 mysql sqlite qt4 ncurses nls gtk"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
LICENSE="GPL-2"
SLOT="0"

DEPEND=">=dev-libs/libgcrypt-1.2.0
	>=media-libs/libextractor-0.5.20c
	>=net-libs/libmicrohttpd-0.4.0
	>=dev-libs/gmp-4.0.0
	gnome-base/libglade
	sys-libs/zlib
	net-misc/curl
	sys-apps/sed
	>=dev-scheme/guile-1.8.0
	ncurses? ( sys-libs/ncurses )
	mysql? ( >=virtual/mysql-4.0 )
	sqlite? ( >=dev-db/sqlite-3.0.8 )
	nls? ( sys-devel/gettext )"
RDEPEND="${DEPEND}
	gtk? ( =net-p2p/gnunet-gtk-${PV} )
	qt4? ( =net-p2p/gnunet-qt-${PV} )"

pkg_setup() {
	if ! use mysql && ! use sqlite; then
		einfo
		einfo "You need to specify at least one of 'mysql' or 'sqlite'"
		einfo "USE flag in order to have properly installed gnunet"
		einfo
		die "Invalid USE flag set"
	fi
}

pkg_preinst() {
	enewgroup gnunetd || die "Problem adding gnunetd group"
	enewuser gnunetd -1 -1 /dev/null gnunetd || die "Problem adding gnunetd user"
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# make mysql default sqstore if we do not compile sql support
	# (bug #107330)
	! use sqlite && \
		sed -i 's:default "sqstore_sqlite":default "sqstore_mysql":' \
		contrib/config-daemon.scm.in

	# we do not want to built gtk support with USE=-gtk (O_o it is not mine!)
	if ! use gtk ; then
		sed -i "s:AC_DEFINE_UNQUOTED..HAVE_GTK.*:true:" configure.ac
	fi

	AT_M4DIR="${S}/m4" eautoreconf
}

src_compile() {
	# Fixing bug with installpath (already fixed in SVN-version)
	epatch "${FILESDIR}"/installpath.patch || die "epatch failed"
	# Fixed ;-)
	local myconf
	use mysql || myconf="${myconf} --without-mysql"
	if use qt4 ; then
	#Forced "turning on" or "turning off" qt-compatibility with respect to USE-Flags.
	myconf="${myconf} --with-qt"
	else
	myconf="${myconf} --without-qt"
	fi

	use gtk || myconf="${myconf} --without-gtk"
	econf \
		$(use_with sqlite) \
		$(use_enable ipv6) \
		$(use_enable nls) \
		$(use_enable ncurses) \
		${myconf} || die "econf failed"

	emake -j1 || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" -j1 install || die "make install failed"
	dodoc AUTHORS ChangeLog INSTALL NEWS PLATFORMS README README.fr UPDATING
	insinto /etc
	doins contrib/gnunet.conf
	docinto contrib
	dodoc contrib/*
	newinitd "${FILESDIR}"/${PN}.initd gnunet
	dodir /var/lib/gnunet
	chown gnunetd:gnunetd "${D}"/var/lib/gnunet
}

pkg_postinst() {
	# make sure permissions are ok
	chown -R gnunetd:gnunetd "${ROOT}"/var/lib/gnunet

	use ipv6 && ewarn "ipv6 support is -very- experimental and prone to bugs"
	einfo
	einfo "To configure"
	einfo "	 1) Add user(s) to the gnunetd group"
	einfo "	 2) Run 'gnunet-setup' to generate your client config file"
	einfo "	 3) Run gnunet-setup -d as root to generate a server config file"
	einfo
}
