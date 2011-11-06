# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/psi/psi-9999.ebuild,v 1.12 2011/06/30 09:23:16 pva Exp $

EAPI="4"

LANGS="ar be bg br ca cs da de ee el eo es et fi fr hr hu it ja mk nl pl pt pt_BR ru se sk sl sr sr@latin sv sw uk ur_PK vi zh_CN zh_TW"

inherit eutils qt4-r2 multilib

MY_PV="5136"
DESCRIPTION="Qt4 Jabber client, with Licq-like interface"
HOMEPAGE="http://psi-im.org/"
MY_URI="http://rion-overlay.googlecode.com/files/"
SRC_URI="${MY_URI}${P}.tar.xz
	${MY_URI}${PN}-l10n-${PV}.tar.xz
	extras? ( ${MY_URI}${PN}-plus_r${MY_PV}.tar.xz
		iconsets? ( ${MY_URI}${PN}-plus-resources_r${MY_PV}.tar.xz )
	)
"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="crypt dbus debug doc enchant extras jingle iconsets spell ssl xscreensaver powersave
plugins whiteboarding webkit"

REQUIRED_USE="
	iconsets? ( extras )
	plugins? ( extras )
	powersave? ( extras )
	webkit? ( extras )
"

RDEPEND="
	>=x11-libs/qt-gui-4.4:4[dbus?]
	>=app-crypt/qca-2.0.2:2
	|| ( >=sys-libs/zlib-1.2.5.1-r2[minizip] <sys-libs/zlib-1.2.5.1-r1 )
	whiteboarding? ( x11-libs/qt-svg:4 )
	spell? (
		enchant? ( >=app-text/enchant-1.3.0 )
		!enchant? ( app-text/aspell )
	)
	xscreensaver? ( x11-libs/libXScrnSaver )
	extras? ( webkit? ( x11-libs/qt-webkit:4 ) )
"
DEPEND="${RDEPEND}
	extras? (
		sys-devel/qconf
	)
	doc? ( app-doc/doxygen )
	dev-util/pkgconfig
	app-arch/xz-utils
"
PDEPEND="
	crypt? ( app-crypt/qca-gnupg:2 )
	jingle? (
		net-im/psimedia
		app-crypt/qca-ossl:2
	)
	ssl? ( app-crypt/qca-ossl:2 )
"
RESTRICT="test"

pkg_setup() {
	MY_PN=psi
	if use extras; then
		MY_PN=psi-plus
		echo
		ewarn "You're about to build heavily patched version of Psi called Psi+."
		ewarn "It has really nice features but still is under heavy development."
		ewarn "Take a look at homepage for more info: http://code.google.com/p/psi-dev"
		ewarn "If you wish to disable some patches just put"
		ewarn "MY_EPATCH_EXCLUDE=\"list of patches\""
		ewarn "into /etc/portage/env/${CATEGORY}/${PN} file."
		echo
		ewarn "Note: some patches depend on other. So if you disabled some patch"
		ewarn "and other started to fail to apply, you'll have to disable patches"
		ewarn "that fail too."

		if use iconsets; then
			echo
			ewarn "Some artwork is from open source projects, but some is provided 'as-is'"
			ewarn "and has not clear licensing."
			ewarn "Possibly this build is not redistributable in some countries."
		fi
	fi
}

src_prepare() {
	if use extras; then
		cp -a "${WORKDIR}/${PN}-plus_r${MY_PV}/iconsets" "${S}" || die
		if use iconsets; then
			cp -a "${WORKDIR}/${PN}-plus-resources_r${MY_PV}/iconsets" "${S}" || die
		fi

		EPATCH_EXCLUDE="${MY_EPATCH_EXCLUDE}
		" \
		EPATCH_SOURCE="${WORKDIR}/${PN}-plus_r${MY_PV}/patches/" EPATCH_SUFFIX="diff" EPATCH_FORCE="yes" epatch

		use powersave && epatch "${WORKDIR}/${PN}-plus_r${MY_PV}/patches/dev/psi-reduce-power-consumption.patch"

		if use linguas_ru; then
			pushd "${WORKDIR}/${PN}-l10n-${PV}"
			rm -rf ru
			mv ru_psi-plus ru
			popd
		fi

		sed -e "s/.xxx/.${MY_PV}/" \
			-i src/applicationinfo.cpp || die "sed failed"

		qconf || die "Failed to create ./configure."
	fi

	rm -rf third-party/qca # We use system libraries. Remove after patching, some patches may affect qca.
}

src_configure() {
	# unable to use econf because of non-standard configure script
	# disable growl as it is a MacOS X extension only
	local myconf="
		--disable-bundled-qca
		--disable-growl
		--no-separate-debug-info
	"
	use dbus || myconf+=" --disable-qdbus"
	use debug && myconf+=" --debug"
	if use spell; then
		if use enchant; then
			myconf+=" --disable-aspell"
		else
			myconf+=" --disable-enchant"
		fi
	else
		myconf+=" --disable-aspell --disable-enchant"
	fi
	use whiteboarding && myconf+=" --enable-whiteboarding"
	use xscreensaver || myconf+=" --disable-xss"
	if use extras; then
		use plugins && myconf+=" --enable-plugins"
		use webkit && myconf+=" --enable-webkit"
	fi

	./configure \
		--prefix="${EPREFIX}"/usr \
		--qtdir="${EPREFIX}"/usr \
		${myconf} || die

	eqmake4
}

src_compile() {
	emake

	if use doc; then
		cd doc
		mkdir -p api # 259632
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

	if use extras && use plugins; then
		insinto /usr/share/${MY_PN}/plugins
		doins src/plugins/plugins.pri
		doins src/plugins/psiplugin.pri
		doins -r src/plugins/include
		sed -i -e "s:target.path.*:target.path = /usr/$(get_libdir)/${MY_PN}/plugins:" \
			"${ED}"/usr/share/${MY_PN}/plugins/psiplugin.pri \
			|| die "sed failed"
	fi

	use doc && dohtml -r doc/api

	# install translations
	cd "${WORKDIR}/${PN}-l10n-${PV}"
	insinto /usr/share/${MY_PN}
	for x in ${LANGS}; do
		if use linguas_${x}; then
			lrelease "${x}/${PN}_${x}.ts" || die "lrelease ${x} failed"
			doins "${x}/${PN}_${x}.qm"
			[ -f "${x}/INFO" ] && newins "${x}/INFO" "${PN}_${x}.INFO"
		fi
	done
}
