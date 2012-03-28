# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

[[ ${PV} = *9999* ]] && VCS_ECLASS="git-2" || VCS_ECLASS=""

inherit cmake-utils ${VCS_ECLASS}

DESCRIPTION="Spectrum is an XMPP transport/gateway"
HOMEPAGE="http://spectrum.im"

if [[ ${PV} == *9999* ]]; then
  EGIT_REPO_URI="git://github.com/hanzz/libtransport.git"
else
  MY_PV="${PV/_/-}"
  SRC_URI="http://spectrum.im/attachments/download/57/${PN}-${MY_PV}.tar.gz"
  S="${WORKDIR}/${PN}-${MY_PV}"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

IUSE_PLUGINS="frotz irc purple skype smstools"
IUSE="debug doc libev log mysql postgres sqlite staticport symlinks test tools ${IUSE_PLUGINS}"

RDEPEND="net-im/swiften
	dev-libs/popt
	dev-libs/openssl
	log? ( dev-libs/log4cxx )
	mysql? ( virtual/mysql )
	postgres? ( dev-libs/libpqxx )
	sqlite? ( dev-db/sqlite:3 )
	frotz? ( dev-libs/protobuf )
	irc? ( net-im/communi dev-libs/protobuf )
	purple? ( >=net-im/pidgin-2.6.0 dev-libs/protobuf )
	skype? ( dev-libs/dbus-glib x11-base/xorg-server[xvfb] dev-libs/protobuf )
	libev? ( dev-libs/libev dev-libs/protobuf )"

DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/cmake
	doc? ( app-doc/doxygen )
	test? ( dev-util/cppunit )
	"

REQUIRED_USE="|| ( sqlite mysql postgres )"

PROTOCOL_LIST="aim facebook gg icq irc msn msn_pecan myspace qq simple sipe twitter xmpp yahoo"

pkg_setup() {
	CMAKE_IN_SOURCE_BUILD=1
	use debug && CMAKE_BUILD_TYPE=Debug
	MYCMAKEARGS="-DLIB_INSTALL_DIR=$(get_libdir)"
}

src_prepare() {
	use sqlite || { sed -i -e 's/find_package(sqlite3)/set(SQLITE3_FOUND FALSE)/' CMakeLists.txt || die; }
	use mysql || { sed -i -e 's/find_package(mysql)/set(MYSQL_FOUND FALSE)/' CMakeLists.txt || die; }
	use postgres || { sed -i -e 's/find_package(pqxx)/set(PQXX_FOUND FALSE)/' CMakeLists.txt || die; }
	use test || { sed -i -e 's/find_package(cppunit)/set(CPPUNIT_FOUND FALSE)/' CMakeLists.txt || die; }
	use doc || { sed -i -e 's/find_package(Doxygen)/set(DOXYGEN_FOUND FALSE)/' CMakeLists.txt || die; }
	use purple || { sed -i -e '/find_package(purple)/d' CMakeLists.txt || die; }
	use libev || { sed -i -e 's/find_package(event)/set(HAVE_EVENT FALSE)/' CMakeLists.txt || die; }
	use irc || { sed -i -e 's/find_package(Communi)/set(IRC_FOUND, FALSE)/' CMakeLists.txt || die; }
	use log || { sed -i -e 's/find_package(log4cxx)/set(LOG4CXX_FOUND, FALSE)/' CMakeLists.txt || die; }

	base_src_prepare
}

src_install () {
	cmake-utils_src_install

	# Install transports with seperate config files (default).
	# If USE="symlinks" is set, install one config file with symlinks to all transports.

	port=5347

	# prepare config for mysql or just copy
	cp "${FILESDIR}/spectrum.cfg" spectrum.cfg

	if use mysql ; then
	sed -e 's,^\(type\)=sqlite$,\1=mysql,' \
		-e 's,^#\(host=localhost\)$,\1,' \
		-e 's,^#\(user=user\)$,\1,' \
		-e 's,^#\(password=password\)$,\1,' \
		-e 's,^\(database=.*\),#\1,' \
		-e 's,^#\(prefix=.*\),\1,' \
		-i spectrum.cfg || die
	fi

	# install shared-config when using symlinks
	if use symlinks; then
		insinto /etc/spectrum
		newins spectrum.cfg spectrum-shared-conf || die
	fi

	# install protocol-specific configs or symlinks
	dodir /etc/spectrum
	for protocol in ${PROTOCOL_LIST}; do
		if use symlinks; then
			dosym spectrum-shared-conf "/etc/spectrum/${protocol}:${port}.cfg" || die
			sed -e 's,PROTOCOL,'${protocol}:${port}',g' \
				"${FILESDIR}"/spectrum.confd > spectrum.confd
		else
			sed -e 's,\$filename:protocol,'${protocol}',g' \
				-e 's,\$filename:port,'${port}',g' \
				spectrum.cfg > "${ED}/etc/spectrum/${protocol}.cfg" || die
			sed -e 's,PROTOCOL,'${protocol}',g' \
				"${FILESDIR}"/spectrum.confd > spectrum.confd
		fi

		# install prepared confd
		newconfd spectrum.confd spectrum.${protocol} || die

		if ! use staticport; then
			port=$[${port}+1]
		fi
	done

	# Install init files
	newinitd "${FILESDIR}"/spectrum.initd spectrum || die
	for protocol in ${PROTOCOL_LIST}; do
		dosym spectrum /etc/init.d/spectrum."${protocol}"
	done

	# Directories
	dodir "/var/lib/spectrum" || die
	dodir "/var/log/spectrum" || die
	dodir "/var/run/spectrum" || die

	# Directories for each transport
	for protocol in ${PROTOCOL_LIST}; do
		dodir "/var/lib/spectrum/$protocol/database" || die
		dodir "/var/lib/spectrum/$protocol/userdir" || die
		dodir "/var/lib/spectrum/$protocol/filetransfer_cache" || die
	done

	# Install mysql schema
	if use mysql; then
		insinto "/usr/share/spectrum/schemas"
		doins schemas/* || die
	fi

	# Install misc tools
	if use tools; then
		insinto "/usr/share/spectrum/tools"
		doins tools/* || die
	fi

	# Set correct rights
	fowners jabber:jabber -R "/etc/spectrum" || die
	fowners jabber:jabber -R "/var/lib/spectrum" || die
	fowners jabber:jabber -R "/var/log/spectrum" || die
	fowners jabber:jabber -R "/var/run/spectrum" || die
	fperms 750 "/etc/spectrum" || die
	fperms 750 "/var/lib/spectrum" || die
	fperms 750 "/var/log/spectrum" || die
	fperms 750 "/var/run/spectrum" || die
}
