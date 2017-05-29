# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PLOCALES="be bg ca cs de en eo es et fa fi fr he hu it ja kk mk nl pl pt pt_BR ru sk sl sr@latin sv sw uk ur_PK vi zh_CN zh_TW"
PLOCALE_BACKUP="en"

SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"

inherit eutils l10n multilib qmake-utils

DESCRIPTION="Qt4 Jabber client, with Licq-like interface"
HOMEPAGE="http://psi-im.org/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="aspell crypt dbus debug doc enchant +hunspell jingle +qt4 qt5 spell ssl xscreensaver
+plugins whiteboarding webengine webkit"

REQUIRED_USE="
	spell? ( ^^ ( aspell enchant hunspell ) )
	aspell? ( spell )
	enchant? ( spell )
	hunspell? ( spell )
	webengine? ( webkit )
	^^ ( qt4 qt5 )
"

RDEPEND="
	net-dns/libidn
	sys-libs/zlib[minizip]
	spell? (
		enchant? ( >=app-text/enchant-1.3.0 )
		hunspell? ( app-text/hunspell )
		aspell? ( app-text/aspell )
	)
	xscreensaver? ( x11-libs/libXScrnSaver )
	qt4? (
		dev-qt/qtgui:4
		dbus? ( dev-qt/qtdbus:4 )
		app-crypt/qca:2[qt4]
		whiteboarding? ( dev-qt/qtsvg:4 )
		webkit? ( dev-qt/qtwebkit:4 )
	)
	qt5? (
		dev-qt/qtgui:5
		dev-qt/qtxml:5
		dev-qt/qtconcurrent:5
		dev-qt/qtmultimedia:5
		dev-qt/qtx11extras:5
		dbus? ( dev-qt/qtdbus:5 )
		app-crypt/qca:2[qt5]
		whiteboarding? ( dev-qt/qtsvg:5 )
		webkit? (
			webengine? ( >=dev-qt/qtwebengine-5.7:5 )
			!webengine? ( dev-qt/qtwebkit:5 )
		)
	)
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig
	qt5? ( dev-qt/linguist-tools )
"
PDEPEND="
	crypt? ( app-crypt/qca[gpg] )
	jingle? (
		net-im/psimedia
		app-crypt/qca[ssl]
	)
	ssl? ( app-crypt/qca[ssl] )
"
RESTRICT="test"

pkg_setup() {
	MY_PN=psi
}

src_configure() {
	# unable to use econf because of non-standard configure script
	# disable growl as it is a MacOS X extension only

	CONF=(
		--libdir="${EPREFIX}"/usr/$(get_libdir)
		--prefix="${EPREFIX}"/usr
		--no-separate-debug-info
		--disable-growl
	)

	use qt4 && CONF+=(--qtdir="$(qt4_get_bindir)/..")
	use qt5 && CONF+=(--qtdir="$(qt5_get_bindir)/..")

	use dbus || CONF+=("--disable-qdbus")
	use debug && CONF+=("--debug")

	for s in aspell enchant hunspell; do
		use $s || CONF+=("--disable-$s")
	done

	use whiteboarding && CONF+=("--enable-whiteboarding")
	use xscreensaver || CONF+=("--disable-xss")
	use plugins || CONF+=("--disable-plugins")
	if use webkit; then
		CONF+=("--enable-webkit")
		use webengine && CONF+=("--with-webkit=qtwebengine")
		use webengine || CONF+=("--with-webkit=qwebkit")
	fi

	elog ./configure "${CONF[@]}"
	./configure "${CONF[@]}"

	use qt4 && eqmake4 psi.pro
	use qt5 && eqmake5 psi.pro
}

src_compile() {
	emake

	if use doc; then
		cd doc
		make api_public || die "make api_public failed"
	fi
}

src_install() {
	emake INSTALL_ROOT="${D}" install

	# this way the docs will be installed in the standard gentoo dir
	rm -f "${ED}"/usr/share/${MY_PN}/{COPYING,README}
	newdoc iconsets/roster/README README.roster
	newdoc iconsets/system/README README.system
	newdoc certs/README README.certs
	dodoc README

	use doc && dohtml -r doc/api

	# install translations
	local mylrelease="$(qt$(usex qt5 5 4)_get_bindir)"/lrelease
	cd "${WORKDIR}/psi-l10n"
	insinto /usr/share/${MY_PN}
	install_locale() {
		# PLOCALES are set from Psi+. So we don't want to fail here if no locale
		if [ -f "${x}/${PN}_${1}.ts" ]; then
			"${mylrelease}" "${x}/${PN}_${1}.ts" || die "lrelease ${1} failed"
			doins "${x}/${PN}_${1}.qm"
		else
			ewarn "Unfortunately locale \"${1}\" is supported for Psi+ only"
		fi
	}
	l10n_for_each_locale_do install_locale
}
