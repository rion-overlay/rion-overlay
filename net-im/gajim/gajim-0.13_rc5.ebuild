# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/gajim/gajim-0.12.1.ebuild,v 1.4 2009/05/31 23:59:52 ranger Exp $

EAPI="2"

inherit multilib python eutils autotools

DESCRIPTION="Jabber client written in PyGTK"
HOMEPAGE="http://www.gajim.org/"
SRC_URI="http://www.gajim.org/downloads/${PV/_*/}/${PN}-${PV/_/-}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="avahi dbus gnome idle libnotify notify-osd nls spell srv trayicon X xhtml"

S="${WORKDIR}/gajim-0.12.5.90-rc5"

DEPEND="|| (
		( <dev-lang/python-2.5 dev-python/pysqlite )
		>=dev-lang/python-2.5[sqlite]
	)
	dev-python/pygtk
	sys-devel/gettext
	dev-util/intltool
	dev-util/pkgconfig"

RDEPEND="|| (
			 ( <dev-lang/python-2.5 dev-python/pysqlite )
			 >=dev-lang/python-2.5[sqlite]
		)
	dev-python/pygtk
	sys-devel/gettext
	libnotify? ( x11-libs/libnotify )
	notify-osd? ( x11-misc/notify-osd )
	xhtml? ( dev-python/docutils )
	srv? ( net-dns/bind-tools )
	idle? ( x11-libs/libXScrnSaver )
	avahi? ( net-dns/avahi[dbus,gtk,python] )
	dev-python/pyopenssl
	dev-python/sexy-python
	dev-python/pycrypto"

PDEPEND="spell? ( app-text/gtkspell )
	dbus? ( dev-python/dbus-python dev-libs/dbus-glib )"

src_prepare() {
	# not upstream:
	epatch "${FILESDIR}/0.12.1_autotools_install_pyfiles_in_pkglibdir.patch"
	# sound paths:
	epatch "${FILESDIR}/0.12.1-sound-path-fix.patch"
	# notify-osd patch:
	use notify-osd && epatch "${FILESDIR}/${PN}-notify-osd.patch"

	# fix datadir path (trunk use an env var for config this)
	sed -i "s|'DATA',.*|'DATA', '/usr/share/gajim/data')|" \
		   "src/common/configpaths.py" || die 'sed failed'

	eautoreconf
}

src_configure() {
	local myconf

	if ! use gnome; then
		myconf="${myconf} $(use_enable trayicon)"
		myconf="${myconf} $(use_enable idle)"
	fi

	econf $(use_enable nls) \
		$(use_with X x) \
		--docdir="/usr/share/doc/${PF}" \
		--libdir="$(python_get_sitedir)" \
		${myconf} || die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	rm "${D}/usr/share/doc/${PF}/README.html"
	dohtml README.html
}

pkg_postinst() {
	python_mod_optimize $(python_get_sitedir)/gajim/
}

pkg_postrm() {
	python_mod_cleanup $(python_get_sitedir)/gajim/
}
