# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/psi/psi-9999.ebuild,v 1.7 2010/11/16 15:34:08 pva Exp $

EAPI="2"

LANGS="ar be bg br ca cs da de ee el eo es et fi fr hr hu it ja mk nl pl pt pt_BR ru se sk sl sr sr@latin sv sw uk ur_PK vi zh_CN zh_TW"

EGIT_REPO_URI="git://git.psi-im.org/psi.git"
EGIT_HAS_SUBMODULES=1
LANGS_URI="git://pv.et-inf.fho-emden.de/git/psi-l10n"

ESVN_DISABLE_DEPENDENCIES="true"
ESVN_REPO_URI="http://psi-dev.googlecode.com/svn/trunk"
ESVN_PROJECT="psiplus"

inherit eutils qt4-r2 multilib git subversion

DESCRIPTION="Qt4 Jabber client, with Licq-like interface"
HOMEPAGE="http://psi-im.org/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="crypt dbus debug doc enchant extras jingle iconsets spell ssl xscreensaver powersave
plugins -whiteboarding webkit"

RDEPEND=">=x11-libs/qt-gui-4.4:4[qt3support,dbus?]
	>=x11-libs/qt-qt3support-4.4:4
	>=app-crypt/qca-2.0.2:2
	whiteboarding? ( x11-libs/qt-svg:4 )
	spell? (
		enchant? ( >=app-text/enchant-1.3.0 )
		!enchant? ( app-text/aspell )
	)
	xscreensaver? ( x11-libs/libXScrnSaver )
	extras? ( webkit? ( x11-libs/qt-webkit ) )
	app-arch/unzip"

DEPEND="${RDEPEND}
	extras? (
		${SUBVERSION_DEPEND}
		sys-devel/qconf
	)
	doc? ( app-doc/doxygen )"

PDEPEND="crypt? ( app-crypt/qca-gnupg:2 )
	jingle? (
		net-im/psimedia
		app-crypt/qca-ossl:2
	)
	ssl? ( app-crypt/qca-ossl:2 )"

RESTRICT="test"

pkg_setup() {
	for x in iconsets plugins powersave webkit whiteboarding;do
	        use ${x} && use !extras && \
			ewarn "USE=${x} is only available in Psi+ and requires USE=extras, ${x} will be disabled."
	done

	if use extras; then
		ewarn
		ewarn "You're about to build heavily patched version of Psi called Psi+."
		ewarn "It has really nice features but still is under heavy development."
		ewarn "Take a look at homepage for more info: http://code.google.com/p/psi-dev"
		ewarn

		if use iconsets; then
			ewarn
			ewarn "Some artwork is from open source projects, but some is provided 'as-is'"
			ewarn "and has not clear licensing."
			ewarn "Possibly this build is not redistributable in some countries."
		fi
	fi
}

src_unpack() {
	git_src_unpack

	# fetch translations
	mkdir "${WORKDIR}/psi-l10n"
	for x in ${LANGS}; do
		if use linguas_${x}; then
			if use extras && [ "${x}" = "ru" ]; then
				EGIT_REPO_URI="git://mva.name/psi-l10n-${x}"
				EGIT_PROJECT="psiplus-l10n/${x}"
			else
				EGIT_REPO_URI="${LANGS_URI}-${x}"
				EGIT_PROJECT="psi-l10n/${x}"
			fi
			S="${WORKDIR}/psi-l10n/${x}" git_fetch
		fi
	done

	if use extras; then
		S="${WORKDIR}/patches" subversion_fetch "${ESVN_REPO_URI}/patches"
		subversion_wc_info "${ESVN_REPO_URI}/patches"
		psi_plus_revision=$ESVN_WC_REVISION
		if use iconsets; then
			subversion_fetch "${ESVN_REPO_URI}/iconsets" "iconsets"
		else
			for x in activities affiliations clients moods roster system; do
				ESVN_PROJECT="psiplus/${x}"
				subversion_fetch "${ESVN_REPO_URI}/iconsets/${x}/default" "iconsets/${x}/default"
			done
		fi
	fi
}

src_prepare() {
	if use extras; then
		EPATCH_SOURCE="${WORKDIR}/patches/" EPATCH_SUFFIX="diff" EPATCH_FORCE="yes" epatch

		use powersave && epatch "${WORKDIR}/patches/dev/psi-reduce-power-consumption.patch"

		if use whiteboarding; then
			sed -e 's/#CONFIG += whiteboarding/CONFIG += whiteboarding/' \
				-i src/src.pro || die "sed failed"
			epatch "${WORKDIR}/patches/dev/psi-wb.patch"

			ewarn "Whiteboarding is very unstable."
		fi

		sed -e "s/.xxx/.${psi_plus_revision}/" \
			-i src/applicationinfo.cpp || die "sed failed"

		qconf || die "Failed to create ./configure."
	fi

	rm -rf third-party/qca # We use system libraries. Remove after patching, some patches may affect qca.
}

src_configure() {
	# unable to use econf because of non-standard configure script
	# disable growl as it is a MacOS X extension only
	local confcmd="./configure
			--prefix=/usr
			--qtdir=/usr
			--disable-bundled-qca
			--disable-growl
			--no-separate-debug-info
			$(use dbus || echo '--disable-qdbus')
			$(use debug && echo '--debug')
			$(use spell && {
				use enchant && echo '--disable-aspell' || echo '--disable-enchant'
				} || echo '--disable-aspell --disable-enchant')
			$(use xscreensaver || echo '--disable-xss')
			$(use extras && {
				use plugins && echo '--enable-plugins'
				use webkit && echo '--enable-webkit'
				} )"

	echo "${confcmd}"
	${confcmd} || die "configure failed"

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
	rm -f "${D}"/usr/share/psi/{COPYING,README}

	# this way the docs will be installed in the standard gentoo dir
	newdoc iconsets/roster/README README.roster || die
	newdoc iconsets/system/README README.system || die
	newdoc certs/README README.certs || die
	dodoc README || die

	if use extras && use plugins; then
		insinto /usr/share/psi/plugins
		doins src/plugins/plugins.pri || die
		doins src/plugins/psiplugin.pri || die
		doins -r src/plugins/include || die
		dosed "s:target.path.*:target.path = /usr/$(get_libdir)/psi/plugins:" \
			/usr/share/psi/plugins/psiplugin.pri \
			|| die "sed failed"
	fi

	if use doc; then
		cd doc
		dohtml -r api || die "dohtml failed"
	fi

	# install translations
	cd "${WORKDIR}/psi-l10n"
	insinto /usr/share/${PN}
	for x in ${LANGS}; do
		if use linguas_${x}; then
			lrelease "${x}/${PN}_${x}.ts" || die "lrelease ${x} failed"
			doins "${x}/${PN}_${x}.qm" || die
			newins "${x}/INFO" "INFO.${x}"
		fi
	done
}
