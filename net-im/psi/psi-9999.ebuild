# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/psi/psi-9999.ebuild,v 1.10 2010/11/30 19:24:56 pva Exp $

EAPI="4"

LANGS="ar be bg br ca cs da de ee el eo es et fi fr hr hu it ja mk nl pl pt pt_BR ru se sk sl sr sr@latin sv sw uk ur_PK vi zh_CN zh_TW"

EGIT_REPO_URI="git://git.psi-im.org/psi.git"
EGIT_HAS_SUBMODULES=1
LANGS_URI="git://pv.et-inf.fho-emden.de/git/psi-l10n"

PSI_PLUS_URI="git://github.com/psi-plus/main.git"
PSI_PLUS_ICONSETS_URI="git://github.com/psi-plus/iconsets.git"

inherit eutils qt4-r2 multilib git-2 subversion

DESCRIPTION="Qt4 Jabber client, with Licq-like interface"
HOMEPAGE="http://psi-im.org/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
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
	whiteboarding? ( x11-libs/qt-svg:4 )
	spell? (
		enchant? ( >=app-text/enchant-1.3.0 )
		!enchant? ( app-text/aspell )
	)
	xscreensaver? ( x11-libs/libXScrnSaver )
	extras? ( webkit? ( x11-libs/qt-webkit:4 ) )
	app-arch/unzip
"
DEPEND="${RDEPEND}
	extras? (
		${SUBVERSION_DEPEND}
		sys-devel/qconf
	)
	doc? ( app-doc/doxygen )
	dev-util/pkgconfig
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
		echo

		if use iconsets; then
			echo
			ewarn "Some artwork is from open source projects, but some is provided 'as-is'"
			ewarn "and has not clear licensing."
			ewarn "Possibly this build is not redistributable in some countries."
		fi
	fi
}

src_unpack() {
	git-2_src_unpack
	unset EGIT_HAS_SUBMODULES EGIT_NONBARE

	# fetch translations
	mkdir "${WORKDIR}/psi-l10n"
	for x in ${LANGS}; do
		if use linguas_${x}; then
			if use extras && [ "${x}" = "ru" ]; then
				ESVN_PROJECT="psiplus/psi-l10n/${x}" \
				S="${WORKDIR}" \
				subversion_fetch \
					"http://psi-ru.googlecode.com/svn/branches/psi-plus/" \
					"psi-l10n/${x}"
			else
				unset EGIT_MASTER EGIT_BRANCH EGIT_COMMIT
				EGIT_REPO_URI="${LANGS_URI}-${x}" \
				EGIT_DIR="${EGIT_STORE_DIR}/psi-l10n/${x}" \
				EGIT_SOURCEDIR="${WORKDIR}/psi-l10n/${x}" git-2_src_unpack
			fi
		fi
	done

	if use extras; then
		EGIT_DIR="${EGIT_STORE_DIR}/psi-plus/main" \
		EGIT_SOURCEDIR="${WORKDIR}/psi-plus" \
		EGIT_REPO_URI="${PSI_PLUS_URI}" git-2_src_unpack
		if use iconsets; then
			EGIT_DIR="${EGIT_STORE_DIR}/psi-plus/iconsets" \
			EGIT_SOURCEDIR="${WORKDIR}/iconsets" \
			EGIT_REPO_URI="${PSI_PLUS_ICONSETS_URI}" git-2_src_unpack
		fi
	fi
}

src_prepare() {
	if use extras; then
		cp -a "${WORKDIR}/psi-plus/iconsets" "${S}" || die "failed to copy iconsets"
		use iconsets && { cp -a "${WORKDIR}/iconsets" "${S}" || \
			die	"failed to copy additional iconsets"; }
		EPATCH_SOURCE="${WORKDIR}/psi-plus/patches/" EPATCH_SUFFIX="diff" EPATCH_FORCE="yes" epatch

		use powersave && epatch "${WORKDIR}/patches/dev/psi-reduce-power-consumption.patch"

		sed -e "s/.xxx/.$(cd "${WORKDIR}/psi-plus"; git describe --tags | cut -d - -f 2)/" \
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
		--prefix="$EPREFIX"/usr \
		--qtdir="$EPREFIX"/usr \
		${myconf} || die

	eqmake4
}

src_compile() {
	emake || die "emake failed"

	if use doc; then
		cd doc
		mkdir -p api # 259632
		make api_public || die "make api_public failed"
	fi
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake install failed"

	# this way the docs will be installed in the standard gentoo dir
	rm -f "${ED}"/usr/share/${MY_PN}/{COPYING,README}
	newdoc iconsets/roster/README README.roster || die
	newdoc iconsets/system/README README.system || die
	newdoc certs/README README.certs || die
	dodoc README || die

	if use extras && use plugins; then
		insinto /usr/share/${MY_PN}/plugins
		doins src/plugins/plugins.pri || die
		doins src/plugins/psiplugin.pri || die
		doins -r src/plugins/include || die
		sed -i -e "s:target.path.*:target.path = /usr/$(get_libdir)/${MY_PN}/plugins:" \
			"${ED}"/usr/share/${MY_PN}/plugins/psiplugin.pri \
			|| die "sed failed"
	fi

	if use doc; then
		dohtml -r doc/api || die "dohtml failed"
	fi

	# install translations
	cd "${WORKDIR}/psi-l10n"
	insinto /usr/share/${MY_PN}
	for x in ${LANGS}; do
		if use linguas_${x}; then
			lrelease "${x}/${PN}_${x}.ts" || die "lrelease ${x} failed"
			doins "${x}/${PN}_${x}.qm" || die
			[ -f "${x}/qt_${x}.qm" ] && doins "${x}/qt_${x}.qm"
			[ -f "${x}/qt/qt_${x}.qm" ] && doins "${x}/qt/qt_${x}.qm"
			[ -f "${x}/INFO" ] && newins "${x}/INFO" "${PN}_${x}.INFO"
		fi
	done
}

pkg_preinst() {
	true # suppress subversion warnings
}
