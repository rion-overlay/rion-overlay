# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/gajim/gajim-0.12.1.ebuild,v 1.4 2009/05/31 23:59:52 ranger Exp $

EAPI="2"

inherit multilib python eutils mercurial

EHG_REPO_URI="http://hg.gajim.org/gajim"
EHG_REVISION="default"

DESCRIPTION="Jabber client written in PyGTK"
HOMEPAGE="http://www.gajim.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="avahi dbus spell gnome libnotify nls srv trayicon X xhtml"

DEPEND="|| (
		( <dev-lang/python-2.5 dev-python/pysqlite )
		>=dev-lang/python-2.5[sqlite]
	)
	dev-python/pygtk
	sys-devel/gettext
	dev-util/intltool
	dev-util/pkgconfig"

RDEPEND="dev-python/dbus-python
	dev-libs/dbus-glib
	libnotify? ( x11-libs/libnotify )
	xhtml? ( dev-python/docutils )
	srv? ( net-dns/bind-tools )
	spell? ( app-text/gtkspell )
	avahi? ( net-dns/avahi[dbus,gtk,python] )
	dev-python/pyopenssl
	dev-python/sexy-python
	dev-python/pycrypto"

src_configure() {
	cd "${WORKDIR}"/"${PN}"
		./autogen.sh

	local myconf

	if ! use gnome; then
		myconf="${myconf} $(use_enable trayicon)"
	fi

	econf $(use_enable nls) \
		$(use_with X x) \
		--docdir="/usr/share/doc/${PF}" \
		--libdir="$(python_get_sitedir)" \
		${myconf} || die "econf failed"
}

src_install() {
	cd "${WORKDIR}"/"${PN}" # ??? slepnoga
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS NEWS README
}

pkg_postinst() {
	python_mod_optimize $(python_get_sitedir)/gajim/
}

pkg_postrm() {
	python_mod_cleanup $(python_get_sitedir)/gajim/
}
