# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

WANT_AUTOMAKE="1.10"
WANT_AUTOCONF="2.5"

inherit eutils autotools qt4-r2

DESCRIPTION="Open SCADA system"
HOMEPAGE="http://oscada.org.ua"
SRC_URI="ftp://oscada.org/OpenSCADA/0.6.4/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

IUSE="dbase mysql +sqlite firebird system +blockcalc javalikecalc diamondboards
	+logiclev snmp simens +modbus +dcon +daqgate portaudio +icp_das +fsarch +dbarch
	+sockets ssl +serial http +selfsystem vcaengine vision qtstarter qtcfg webcfg
	webcfgd webvision +systemtest +flibcomplex1 +flibmath +flibsys demo doc"

COMMON_DEPEND="sys-devel/gettext
	dev-libs/expat
	media-libs/gd[fontconfig,-xpm]
	sqlite? ( >=dev-db/sqlite-3.6.20-r1 )
	mysql? ( dev-db/mysql )
	firebird? ( dev-db/firebird )
	snmp? ( net-analyzer/net-snmp )
	portaudio? ( media-libs/portaudio )
	system? ( sys-apps/lm_sensors app-admin/hddtemp sys-apps/smartmontools )
	vision? ( sci-libs/fftw:3.0 x11-libs/qt-gui:4 )
	webvision? ( sci-libs/fftw:3.0 )
	qtcfg? ( x11-libs/qt-gui:4 )
	qtstarter? ( x11-libs/qt-gui:4 )"

DEPEND="${COMMON_DEPEND}
		sys-devel/libtool
		javalikecalc? ( sys-devel/bison )"

RDEPEND="${COMMON_DEPEND}"

S="${WORKDIR}/openscada-${PV}"

DOCS="ChangeLog README* AUTHORS NEWS TODO*"

pkg_setup() {
	if use webvision || use webcfg || use webcfgd && ! use http ; then
	    ewarn 'USE="http" for defined builtin webserver!'
	    die "Webserver is not defined!"
	fi

	if use vision || use webvision && ! use vcaengine ; then
	    ewarn 'USE="vcaengine" for environment visualization and management!'
	    die "Engine environment visualization and management are not defined!"
	fi

	if ! use qtcfg || ! use vision && use qtstarter ; then
	    ewarn 'USE="vision" and/or USE="qtcfg" for defined Qt-based user interface!'
	    die "QtStarter is useless if Qt-based user interface is not defined!"
	fi

	if ! use webcfg || ! use webvision || ! use webcfgd && use http ; then
	    ewarn 'USE="webvision" and/or USE="webcfg" for defined web-based user interface!'
	    die "HTTP is useless if web-based user interface is not defined!"
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/*.patch || die "epatch failed"
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable mysql MySQL) \
		$(use_enable sqlite SQLite) \
		$(use_enable firebird FireBird) \
		$(use_enable system System) \
		$(use_enable blockcalc BlockCalc) \
		$(use_enable javalikecalc JavaLikeCalc) \
		$(use_enable diamondboards DiamondBoards) \
		$(use_enable logiclev LogicLev) \
		$(use_enable snmp SNMP) \
		$(use_enable simens Siemens) \
		$(use_enable modbus ModBus) \
		$(use_enable dcon DCON) \
		$(use_enable daqgate DAQGate) \
		$(use_enable portaudio SoundCard) \
		$(use_enable icp_das ICP_DAS) \
		$(use_enable fsarch FSArch) \
		$(use_enable dbarch DBArch ) \
		$(use_enable sockets Sockets) \
		$(use_enable ssl SSL) \
		$(use_enable serial Serial) \
		$(use_enable selfsystem SelfSystem) \
		$(use_enable vcaengine VCAEngine) \
		$(use_enable vision Vision) \
		$(use_enable qtstarter QTStarter) \
		$(use_enable qtcfg QTCfg) \
		$(use_enable webcfg WebCfg) \
		$(use_enable webcfgd WebCfgD) \
		$(use_enable webvision WebVision) \
		$(use_enable systemtest SystemTests) \
		$(use_enable flibcomplex1 FLibComplex1) \
		$(use_enable flibmath FLibMath) \
		$(use_enable flibsys FLibSYS) \
		$(use_enable http HTTP) || die "configure failed"
}

src_install() {

	newinitd "${FILESDIR}/oscada.init" oscada

	dodir /var/spool/openscada/icons
	dodir /var/spool/openscada/ARCHIVES/MESS
	dodir /var/spool/openscada/ARCHIVES/VAL

	insinto /etc
	doins data/oscada.xml
	doins data/oscada_start.xml
	dobin data/openscada_start

	if use vision || use webvision || use qtcfg || use webcfg || use webcfgd ; then
		insinto /var/spool/openscada/icons
		doins data/icons/* || die
	fi

	if use demo && use webvision && ! use vision ; then
		insinto /etc
		doins demo/oscada_demo.xml || die
		dobin demo/openscada_demo || die

		insinto /var/spool/openscada/DEMO
		doins demo/*.db || die
	fi

	if use demo && use vision ; then
		insinto /etc
		doins demo/oscada_demo.xml || die
		dobin demo/openscada_demo || die

		insinto /var/spool/openscada/DEMO
		doins demo/*.db || die

		doicon demo/openscada_demo.png
		domenu demo/openscada_demo.desktop
	fi

	if use vision || use qtcfg ; then
		doicon data/openscada.png
		domenu data/openscada.desktop
	fi

	emake DESTDIR="${D}" install || die "emake failed"
}

pkg_postinst() {
	ewarn "THIS PACKAGE IS IN ITS DEVELOPMENT STAGE!"
	ewarn "See ${HOMEPAGE} for more info."
	einfo "Config place on /etc/oscada.xml"
}
