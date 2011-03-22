# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=2

inherit cmake-utils git

DESCRIPTION="Spectrum is an XMPP transport/gateway"
HOMEPAGE="http://spectrum.im"

EGIT_PROJECT="spectrum"
EGIT_REPO_URI="git://github.com/hanzz/${EGIT_PROJECT}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="mysql sqlite symlinks tools staticport"

RDEPEND=">=dev-libs/poco-1.3.3[mysql?,sqlite?]
	media-gfx/imagemagick[cxx]
	>=net-im/pidgin-2.6.0
	>=net-libs/gloox-1.0
	dev-python/xmpppy"
DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/cmake"

PROTOCOL_LIST="aim facebook gg icq irc msn msn_pecan myspace qq simple sipe twitter xmpp yahoo"

pkg_setup() {
	if ! ( use sqlite || use mysql ); then
		ewarn "No database use flag set!"
		ewarn "You need to enable the mysql or sqlite use flag!"
		die
	fi
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
				spectrum.cfg > "${D}/etc/spectrum/${protocol}.cfg" || die
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
