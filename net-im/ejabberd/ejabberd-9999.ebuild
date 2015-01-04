# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: pva Exp $

EAPI=5
WANT_AUTOCONF="2.5"

inherit eutils multilib pam ssl-cert systemd git-r3 subversion autotools

DESCRIPTION="The Erlang Jabber Daemon"
HOMEPAGE="http://www.ejabberd.im/ https://github.com/processone/ejabberd/"
EGIT_REPO_URI="https://github.com/processone/ejabberd"
#EGIT_BRANCH="2.1.x"

SRC_URI="mod_statsdx? ( http://dev.gentoo.org/~radhermit/dist/${PN}-mod_statsdx-1118.patch.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
EJABBERD_MODULES_ADDITIONAL="atom_pubsub ircd mod_admin_extra mod_archive mod_cron mod_log_chat mod_logsession mod_logxml mod_muc_admin mod_muc_log_http mod_multicast mod_openid mod_profile mod_register_web mod_rest mod_s2s_log mod_shcommands mod_webpresence"
EJABBERD_MODULES="mod_statsdx"

REQUIRED_USE="postgres? ( odbc )
	mysql? ( odbc )
	mssql? ( odbc )
	riak? ( odbc )"

IUSE="captcha debug +doc json lager ldap md5 mssql mysql odbc pam postgres riak tools zlib ${EJABBERD_MODULES} ${EJABBERD_MODULES_ADDITIONAL}"

DEPEND=">=net-im/jabber-base-0.01
	>=dev-libs/expat-1.95
	dev-libs/libyaml
	dev-lang/erlang[ssl]
	doc? ( dev-tex/hevea )
	odbc? ( dev-db/unixODBC )
	ldap? ( =net-nds/openldap-2* )
	>=dev-libs/openssl-0.9.8e
	captcha? ( media-gfx/imagemagick[truetype,png] )
	zlib? ( sys-libs/zlib )"
#>=sys-apps/shadow-4.1.4.2-r3 - fixes bug in su that made ejabberdctl unworkable.
RDEPEND="${DEPEND}
	>=sys-apps/shadow-4.1.4.2-r3
	pam? ( virtual/pam )"


pkg_setup() {
	# paths in net-im/jabber-base
	JABBER_ETC="${EPREFIX}/etc/jabber"
	JABBER_SPOOL="${EPREFIX}/var/spool/jabber"
	JABBER_LOG="${EPREFIX}/var/log/jabber"

	JABBER_DOC="${EPREFIX}/usr/share/doc/${PF}"
	JABBER_LIB="${EPREFIX}/usr/$(get_libdir)/erlang/lib/"
}

src_unpack() {
	default
	git-r3_src_unpack
	cd "${S}"
	mkdir additional_docs
	for MODULE in ${EJABBERD_MODULES_ADDITIONAL}; do
	# FIXME they are no in https://github.com/processone/ejabberd-contrib
	if use ${MODULE}; then
		ESVN_REPO_URI="http://svn.process-one.net/ejabberd-modules/${MODULE}/trunk"
		ESVN_PROJECT="ejabberd/${MODULE}"
		subversion_fetch "${ESVN_REPO_URI}" additional/"${MODULE}"
		cp additional/"${MODULE}"/src/*.?rl src
		find additional/"${MODULE}" -type d ! -empty -name 'conf' -exec cp -r {} additional_docs/conf_"${MODULE}" \;
		find additional/"${MODULE}" -type d ! -empty -name 'doc' -exec cp -r {} additional_docs/doc_"${MODULE}" \;
		find additional/"${MODULE}" -type f -name 'README*' -exec cp {} additional_docs/README_"${MODULE}" \;
	fi
	done
}

src_prepare() {
	use md5 && epatch "${FILESDIR}/auth_md5.patch"
	if use mod_statsdx; then
		ewarn "mod_statsdx is not a part of upstream tarball but is a third-party module"
		ewarn "taken from here: http://www.ejabberd.im/mod_stats2file"
		EPATCH_OPTS="-p2" epatch "${WORKDIR}"/${PN}-mod_statsdx-1118.patch
	fi

	# don't install release notes (we'll do this manually)
	sed '/install .* [.][.]\/doc\/[*][.]txt $(DOCDIR)/d' -i Makefile.in || die
	# Set correct paths
	sed -e "/^EJABBERDDIR[[:space:]]*=/{s:ejabberd:${PF}:}" \
		-e "/^ETCDIR[[:space:]]*=/{s:@sysconfdir@/ejabberd:${JABBER_ETC}:}" \
		-e "/^LOGDIR[[:space:]]*=/{s:@localstatedir@/log/ejabberd:${JABBER_LOG}:}" \
		-e "/^SPOOLDIR[[:space:]]*=/{s:@localstatedir@/lib/ejabberd:${JABBER_SPOOL}:}" \
			-i Makefile.in || die
	sed -e "/EJABBERDDIR=/{s:ejabberd:${PF}:}" \
		-e "s|\(ETC_DIR=\){{sysconfdir}}.*|\1${JABBER_ETC}|" \
		-e "s|\(LOGS_DIR=\){{localstatedir}}.*|\1${JABBER_LOG}|" \
		-e "s|\(SPOOL_DIR=\){{localstatedir}}.*|\1${JABBER_SPOOL}|" \
		-e 's|su $INSTALLUSER -c|su $INSTALLUSER -p -s /bin/sh -c|' \
		-e "/^INSTALLUSER=/aexport HOME=${JABBER_SPOOL}" \
		-e "s|INSTALLUSER_HOME=.*|INSTALLUSER_HOME=${JABBER_SPOOL}|" \
			-i ejabberdctl.template || die

	#sed -e "s:/share/doc/ejabberd/:${JABBER_DOC}:" -i web/ejabberd_web_admin.erl

	# fix up the ssl cert paths in ejabberd.cfg to use our cert
	sed -e "s|## certfile: \"/path/to/ssl.pem\"|certfile: \"/etc/ssl/ejabberd/server.pem\"|g" \
		-e "s|## s2s_certfile: \"/path/to/ssl.pem\"|s2s_certfile: \"/etc/ssl/ejabberd/server.pem\"|g" \
		-i ejabberd.yml.example || die "Failed sed ejabberd.cfg.example"

	# correct path to captcha script in default ejabberd.cfg
	sed -e 's|captcha_cmd:.*|captcha_cmd: "${JABBER_LIB}/'${PF}'/priv/bin/captcha.sh"|' \
			-i ejabberd.yml.example || die "Failed sed ejabberd.cfg.example"

	# eautoreconf # eautoreconf doesn't work a expected. temporary use autogen
	./autogen.sh
}

src_configure() {
	econf \
		--docdir="${JABBER_DOC}/html" \
		--libdir="${JABBER_LIB}" \
		$(use_enable debug) \
		$(use_enable json) \
		$(use_enable lager) \
		$(use_enable mssql) \
		$(use_enable mysql) \
		$(use_enable odbc) \
		$(use_enable pam) \
		$(use_enable postgres pgsql) \
		$(use_enable riak) \
		$(use_enable tools) \
		$(use_enable zlib) \
		--enable-user=jabber \
		--enable-erlang-version-check=nocheck
}

src_compile() {
	emake
	emake doc
}

src_install() {
	default

	# Pam helper module permissions
	# http://www.process-one.net/docs/ejabberd/guide_en.html
	if use pam; then
		pamd_mimic_system xmpp auth account || die "Cannot create pam.d file"
		fowners root:jabber "/usr/$(get_libdir)/erlang/lib/${PF}/priv/bin/epam"
		fperms 4750 "/usr/$(get_libdir)/erlang/lib/${PF}/priv/bin/epam"
	fi

	dodoc doc/release_notes_*.txt
	dodoc sql/*.sql
	dodoc -r additional_docs
	#dodir /var/lib/ejabberd
	newinitd "${FILESDIR}"/${PN}-3.initd ${PN}
	newconfd "${FILESDIR}"/${PN}-3.confd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service
	systemd_dotmpfilesd "${FILESDIR}"/${PN}.tmpfiles.conf

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotate ${PN}
}

pkg_preinst() {
	true
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		elog "For configuration instructions, please see"
		elog "/usr/share/doc/${PF}/html/guide.html, or the online version at"
		elog "http://www.process-one.net/en/ejabberd/docs/guide_en/"

		elog
		elog '===================================================================='
		elog 'Quick Start Guide:'
		elog '1) Add output of `hostname -f` to /etc/jabber/ejabberd.yml line 88'
		elog '   hosts:'
		elog '2) Add an admin user to host_config'
		elog '   Example in ejabberd.yml:438'
		elog '3) Start the server'
		elog '   # /etc/init.d/ejabberd start (for openRC)'
		elog '	 # systemctl start ejabberd (for Systemd)'
		elog '4) Register the admin user'
		elog '   # /usr/sbin/ejabberdctl register theadmin thehost thepassword'
		elog '5) Log in with your favourite jabber client or using the web admin'
	fi

	# Upgrading from ejabberd-2.0.x:
	if grep -E '^[^#]*EJABBERD_NODE=' "${EROOT}/etc/conf.d/ejabberd" >/dev/null 2>&1; then
		source "${EROOT}/etc/conf.d/ejabberd"
		ewarn
		ewarn "!!! WARNING !!!  WARNING !!!  WARNING !!!  WARNING !!!"
		ewarn "Starting with 2.1.x some paths and configuration files were"
		ewarn "changed to reflect upstream intentions better. Notable changes are:"
		ewarn
		ewarn "1. Everything (even init scripts) is now handled with ejabberdctl script."
		ewarn "Thus main configuration file became /etc/jabberd/ejabberdctl.cfg"
		ewarn "You must update ERLANG_NODE there with the value of EJABBERD_NODE"
		ewarn "from /etc/conf.d/ejebberd or ejabberd will refuse to start."
		ewarn
		ewarn "2. SSL certificate is now generated with ssl-cert eclass and resides"
		ewarn "at standard location: /etc/ssl/ejabberd/server.pem."
		ewarn
		ewarn "3. Cookie now resides at /var/spool/jabber/.erlang.cookie"
		ewarn
		ewarn "4. /var/log/jabber/sasl.log is now /var/log/jabber/erlang.log"
		ewarn
		ewarn "5. Crash dumps (if any) will be located at /var/log/jabber"

		local i ctlcfg new_ctlcfg
		i=0
		ctlcfg=${EROOT}/etc/jabber/ejabberdctl.cfg
		while :; do
			new_ctlcfg=$(printf "${EROOT}/etc/jabber/._cfg%04d_ejabberdctl.cfg" ${i})
			[[ ! -e ${new_ctlcfg} ]] && break
			ctlcfg=${new_ctlcfg}
			((i++))
		done

		ewarn
		ewarn "Updating ${ctlcfg} (debug: ${new_ctlcfg})"
		sed -e "/#ERLANG_NODE=/aERLANG_NODE=$EJABBERD_NODE" "${ctlcfg}" > "${new_ctlcfg}" || die

		if [[ -e ${EROOT}/var/run/jabber/.erlang.cookie ]]; then
			ewarn "Moving .erlang.cookie..."
			if [[ -e ${EROOT}/var/spool/jabber/.erlang.cookie ]]; then
				mv -v "${EROOT}"/var/spool/jabber/.erlang.cookie{,bak}
			fi
			mv -v "${EROOT}"/var/{run/jabber,spool/jabber}/.erlang.cookie
		fi
		ewarn
		ewarn "We'll try to handle upgrade automagically but, please, do your"
		ewarn "own checks and do not forget to run 'etc-update'!"
		ewarn "PLEASE! Run 'etc-update' now!"
	fi

	SSL_ORGANIZATION="${SSL_ORGANIZATION:-Ejabberd XMPP Server}"
	install_cert /etc/ssl/ejabberd/server
	# Fix ssl cert permissions bug #369809
	chown root:jabber "${EROOT}/etc/ssl/ejabberd/server.pem"
	chmod 0440 "${EROOT}/etc/ssl/ejabberd/server.pem"
	if [[ -e ${EROOT}/etc/jabber/ssl.pem ]]; then
		ewarn
		ewarn "The location of SSL certificates has changed. If you are"
		ewarn "upgrading from ${CATEGORY}/${PN}-2.0.5* or earlier  you might"
		ewarn "want to move your old certificates from /etc/jabber into"
		ewarn "/etc/ssl/ejabberd/, update config files and"
		ewarn "rm /etc/jabber/ssl.pem to avoid this message."
		ewarn
	fi
}
