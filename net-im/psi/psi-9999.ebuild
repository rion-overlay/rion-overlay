# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils qt4 multilib git subversion

RU_LANGPACK_VER="10_Oct_2009"

DESCRIPTION="Qt4 Jabber Client, with Licq-like interface"
HOMEPAGE="http://psi-im.org/"
SRC_URI="
	linguas_ru? ( http://psi-ru.googlecode.com/files/Psi_ru_${RU_LANGPACK_VER}.zip )
	!linguas_ru? ( mirror://gentoo/psi-0.13-20090817_langpack_for_packagers.zip )
	http://psi-dev.googlecode.com/svn/trunk/iconsets/moods/silk.jisp"
EGIT_REPO_URI="git://git.psi-im.org/psi.git"
EGIT_PROJECT="psi"

PATCHES_URI=http://psi-dev.googlecode.com/svn/trunk/patches
PSIPLUS_ICONS_URI=http://psi-dev.googlecode.com/svn/trunk/iconsets/psiplus/default
CLIENTS_ICONS_URI=http://psi-dev.googlecode.com/svn/trunk/iconsets/clients/default
ESVN_PROJECT=psiplus

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="crypt dbus debug doc +jingle spell ssl xscreensaver powersave plugins
enchant whiteboarding webkit"
RESTRICT="test"

LANGS="cs de eo es_ES fr it mk pl pt_BR ru uk ur_PK vi zh zh_TW"
for LNG in ${LANGS}; do
	IUSE="${IUSE} linguas_${LNG}"
done

RDEPEND=">=x11-libs/qt-gui-4.4:4[qt3support,dbus?]
		>=app-crypt/qca-2.0.2:2
		whiteboarding? ( >=x11-libs/qt-svg-4.4:4 )
		spell? ( enchant? ( app-text/enchant )
			!enchant? ( app-text/aspell )
		)
		xscreensaver? ( x11-libs/libXScrnSaver )
		webkit? ( x11-libs/qt-webkit )"

DEPEND="${RDEPEND}
		sys-devel/qconf
		doc? ( app-doc/doxygen )"

PDEPEND="crypt? ( app-crypt/qca-gnupg:2 )
		jingle? ( net-im/psimedia )
		ssl? ( app-crypt/qca-ossl:2 )"

src_unpack() {
	use linguas_ru && unpack "Psi_ru_${RU_LANGPACK_VER}.zip"
	! use linguas_ru && unpack "psi-0.13-20090817_langpack_for_packagers.zip"

	git_src_unpack

	S="${S}/iris"
	[[ -d "$S" ]] && rm -rf $S
	EGIT_REPO_URI="git://git.psi-im.org/iris.git"
	EGIT_PROJECT="iris"
	git_src_unpack

	S="${WORKDIR}/patches"
	ESVN_REPO_URI="${PATCHES_URI}"
	subversion_src_unpack

	S="${WORKDIR}/${P}/iconsets/psiplus/default"
	ESVN_REPO_URI="${PSIPLUS_ICONS_URI}"
	ESVN_PROJECT=psiplus/psiplus
	subversion_src_unpack

	S="${WORKDIR}/${P}/iconsets/clients/default"
	ESVN_REPO_URI="${CLIENTS_ICONS_URI}"
	ESVN_PROJECT=psiplus/clients
	subversion_src_unpack
}

src_prepare() {
	rm "${WORKDIR}/patches"/*-psi-win32-* #useless windows patches
	rm "${WORKDIR}/patches"/*dirty-check* #useless update check

	S="${WORKDIR}/${P}"
	cd "${S}"

	epatch "${WORKDIR}/patches"/*.diff
	use powersave && epatch "${WORKDIR}/patches/dev"/psi-reduce-power-consumption.patch

	subversion_wc_info
	sed "s/.xxx/.${ESVN_WC_REVISION}/" -i src/applicationinfo.cpp

	# enable plugins if disabled
	sed '/<!--\(.*plugins.*\)-->/a<dep type="plugins"><disabled/></dep>' -i psi.qc

	# enable whiteboarding
	use whiteboarding && {
		sed 's/#CONFIG += whiteboarding/CONFIG += whiteboarding/' \
			-i src/src.pro
		# fix undefined qdebug
#		sed '/qDebug/d' -i src/sxe/sxeedit.cpp
#		sed '/qDebug/d' -i src/sxe/sxerecord.cpp
		epatch "${WORKDIR}/patches/dev/psi-wb.patch"

		ewarn "whiteboarding is very unstable thing.";
		ewarn "don't post bug reports about it";
	}

	rm -rf third-party/qca # We use system libraries.
	qconf
}

src_configure() {
	# unable to use econf because of non-standard configure script
	# disable growl as it is a MacOS X extension only
	local confcmd="./configure
			--prefix=/usr
			--qtdir=/usr
			--disable-bundled-qca
			--disable-growl
			$(use dbus || echo '--disable-qdbus')
			$(use debug && echo '--debug')
			$(use spell && ( use enchant && echo '--disable-aspell' || \
				echo '--disable-enchant' ) || echo '--disable-aspell --disable-enchant')
			$(use xscreensaver || echo '--disable-xss')
			$(use plugins && echo '--enable-plugins')
			$(use webkit && echo '--enable-qtwebkit')"

	echo ${confcmd}
	${confcmd} || die "configure failed"
}

src_compile() {
	eqmake4 ${PN}.pro

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
	newdoc iconsets/roster/README README.roster || die
	newdoc iconsets/system/README README.system || die
	newdoc certs/README README.certs || die
	dodoc README || die

	if use doc; then
		cd doc
		dohtml -r api || die "dohtml failed"
	fi

	# install translations
	insinto /usr/share/${PN}/
	if use linguas_ru; then
		cd "${WORKDIR}"
		doins psi_ru.qm
		doins qt_ru.qm
	else
		for LNG in ${LANGS}; do
			if use linguas_${LNG}; then
				cd "${WORKDIR}/${LNG}"
				doins ${PN}_${LNG/ur_PK/ur_pk}.qm || die
			fi
		done
	fi

	insinto /usr/share/psi/iconsets/moods/
	doins "${PORTAGE_ACTUAL_DISTDIR}"/silk.jisp
	if use plugins; then
		cd "${S}"
		insinto /usr/share/psi/plugins
		doins "${S}/src/plugins/plugins.pri"
		doins "${S}/src/plugins/psiplugin.pri"
		doins -r "${S}/src/plugins/include"
	fi
}
