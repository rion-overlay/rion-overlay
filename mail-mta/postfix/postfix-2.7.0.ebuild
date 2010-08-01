# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils multilib ssl-cert toolchain-funcs flag-o-matic pam

KEYWORDS="~amd64 ~x86"

IUSE="cdb dovecot-sasl hardened ipv6 ldap mbox mysql nis pam postgres sasl selinux ssl vda"

MY_PV="${PV/_rc/-RC}"
MY_SRC="${PN}-${MY_PV}"
MY_URI="ftp://ftp.porcupine.org/mirrors/postfix-release/official"
VDA_PV="${PV}"
VDA_P="${PN}-vda-${VDA_PV}"
RC_VER="2.5"

DESCRIPTION="A fast and secure drop-in replacement for sendmail."
HOMEPAGE="http://www.postfix.org/"
SRC_URI="${MY_URI}/${MY_SRC}.tar.gz
	vda? ( http://vda.sourceforge.net/VDA/${VDA_P}.patch ) "

LICENSE="IBM"
SLOT="0"

# regular ebuild
PROVIDE="virtual/mta virtual/mda"
# mailer-config support
#PROVIDE="${PROVIDE} virtual/mda"

DEPEND=">=sys-libs/db-3.2
		>=dev-libs/libpcre-3.4
		cdb? ( || ( >=dev-db/cdb-0.75-r1 >=dev-db/tinycdb-0.76 ) )
		ldap? ( >=net-nds/openldap-1.2 )
		mysql? ( virtual/mysql )
		pam? ( virtual/pam )
		postgres? ( dev-db/postgresql-base )
		sasl? (  >=dev-libs/cyrus-sasl-2 )
		ssl? ( >=dev-libs/openssl-0.9.6g )"

# regular ebuild
RDEPEND="${DEPEND}
		>=net-mail/mailbase-0.00
		!virtual/mta
		!net-mail/mailwrapper
		selinux? ( sec-policy/selinux-postfix )"

S="${WORKDIR}/${MY_SRC}"

group_user_check() {
	einfo "Checking for postfix group ..."
	enewgroup postfix 207
	einfo "Checking for postdrop group ..."
	enewgroup postdrop 208
	einfo "Checking for postfix user ..."
	enewuser postfix 207 -1 /var/spool/postfix postfix,mail
}

pkg_setup() {
	# Do not upgrade live from Postfix <2.5
	if [[ -f /var/lib/init.d/started/postfix ]] ; then
		if has_version '<mail-mta/postfix-2.5.0' ; then
			if [[ "${FORCE_UPGRADE}" ]] ; then
				echo
				ewarn "You are upgrading from an incompatible version and you have"
				ewarn "FORCE_UPGRADE set, will build this package while Postfix is running."
				ewarn "You MUST stop Postfix BEFORE installing this version to your system."
				echo
			else
				echo
				eerror "You are upgrading from an incompatible version."
				eerror "You MUST stop Postfix BEFORE installing this version to your system."
				eerror "If you want minimal downtime, emerge postfix with:"
				eerror "    FORCE_UPGRADE=1 emerge --buildpkgonly postfix"
				eerror "    /etc/init.d/postfix stop"
				eerror "    emerge --usepkgonly postfix"
				eerror "Then run etc-update or dispatch-conf and merge the configuration files."
				eerror "Then restart Postfix with: /etc/init.d/postfix start"
				die "Upgrade from an incompatible version!"
				echo
			fi
		else
			echo
			ewarn "It's safe to upgrade your current version while it's running."
			ewarn "If you don't want to take any chance, please hit Ctrl+C now,"
			ewarn "stop Postfix, then emerge again."
			ewarn "You have been warned!"
			ewarn "Waiting 5 seconds before continuing ..."
			echo
			epause 5
		fi
	fi

	echo
	ewarn "Read \"ftp://ftp.porcupine.org/mirrors/postfix-release/official/${MY_SRC}.RELEASE_NOTES\""
	ewarn "for incompatible changes before continueing."
	ewarn "Bugs should be filed at \"http://bugs.gentoo.org/\" and"
	ewarn "assigned to \"net-mail@gentoo.org\"."
	echo

	# Warnings to work around bug #45764
	if has_version '<=mail-mta/postfix-2.0.18' ; then
		echo
		ewarn "You are upgrading from postfix-2.0.18 or earlier, some of the empty queue"
		ewarn "directories get deleted while unmerging the older version (see bug #45764)."
		ewarn "Please run '/etc/postfix/post-install upgrade-source' to recreate them."
		echo
	fi

	# TLS non-prod warning
	if use ssl ; then
		echo
		ewarn "You have \"ssl\" in your USE flags, TLS will be enabled."
		ewarn "This service is incompatible with the previous TLS patch."
		ewarn "Visit http://www.postfix.org/TLS_README.html for more info."
		echo
	fi

	# IPV6 non-prod warn
	if use ipv6 ; then
		echo
		ewarn "You have \"ipv6\" in your USE flags, IPV6 will be enabled."
		ewarn "Visit http://www.postfix.org/IPV6_README.html for more info."
		echo
	fi

	# SASL non-prod warning
	if use sasl ; then
		echo
		elog "Postfix 2.3 and newer supports two SASL implementations."
		elog "Cyrus SASL and Dovecot protocol version 1 (server only)"
		elog "Visit http://www.postfix.org/SASL_README.html for more info."
		echo
	fi

	# Add postfix, postdrop user/group (bug #77565)
	group_user_check || die "Failed to check/add needed user/group"
}

src_unpack() {
	unpack ${MY_SRC}.tar.gz

	cd "${S}"
	if use vda ; then
		epatch "${DISTDIR}/${VDA_P}.patch"
	fi

	sed -i -e "/^#define ALIAS_DB_MAP/s|:/etc/aliases|:/etc/mail/aliases|" \
		src/util/sys_defs.h || die "sed failed"

	# change default paths to better comply with portage standard paths
	sed -i -e "s:/usr/local/:/usr/:g" conf/master.cf || die "sed failed"
}

src_compile() {
	local mycc="-DHAS_PCRE" mylibs="${LDFLAGS} -lpcre -lcrypt -lpthread"

	use pam && mylibs="${mylibs} -lpam"

	if use ldap ; then
		mycc="${mycc} -DHAS_LDAP"
		mylibs="${mylibs} -lldap -llber"
	fi

	if use mysql ; then
		mycc="${mycc} -DHAS_MYSQL $(mysql_config --include)"
		mylibs="${mylibs} -lmysqlclient -lm -lz"
	fi

	if use postgres ; then
		mycc="${mycc} -DHAS_PGSQL -I$(pg_config --includedir)"
		mylibs="${mylibs} -lpq -L$(pg_config --libdir)"
	fi

	if use ssl ; then
		mycc="${mycc} -DUSE_TLS"
		mylibs="${mylibs} -lssl -lcrypto"
	fi

	if use sasl ; then
		if use dovecot-sasl ; then
			# Set dovecot as default.
			mycc="${mycc} -DDEF_SASL_SERVER=\\\"dovecot\\\""
		fi
		mycc="${mycc} -DUSE_SASL_AUTH -DUSE_CYRUS_SASL -I/usr/include/sasl"
		mylibs="${mylibs} -lsasl2"
	elif use dovecot-sasl ; then
		mycc="${mycc} -DUSE_SASL_AUTH -DDEF_SERVER_SASL_TYPE=\\\"dovecot\\\""
	fi

	if ! use nis ; then
		sed -i -e "s|#define HAS_NIS|//#define HAS_NIS|g" \
			src/util/sys_defs.h || die "sed failed"
	fi

	if use cdb ; then
		mycc="${mycc} -DHAS_CDB -I/usr/include/cdb"
		CDB_LIBS=""

		# Tinycdb is preferred.
		if has_version dev-db/tinycdb ; then
			einfo "Building with dev-db/tinycdb"
			CDB_LIBS="-lcdb"
		else
			einfo "Building with dev-db/cdb"
			CDB_PATH="/usr/$(get_libdir)"
			for i in cdb.a alloc.a buffer.a unix.a byte.a ; do
				CDB_LIBS="${CDB_LIBS} ${CDB_PATH}/${i}"
			done
		fi

		mylibs="${mylibs} ${CDB_LIBS}"
	fi

	mycc="${mycc} -DDEF_DAEMON_DIR=\\\"/usr/$(get_libdir)/postfix\\\""
	mycc="${mycc} -DDEF_MANPAGE_DIR=\\\"/usr/share/man\\\""
	mycc="${mycc} -DDEF_README_DIR=\\\"/usr/share/doc/${PF}/readme\\\""
	mycc="${mycc} -DDEF_HTML_DIR=\\\"/usr/share/doc/${PF}/html\\\""

	# Robin H. Johnson <robbat2@gentoo.org> 17/Nov/2006
	# Fix because infra boxes hit 2Gb .db files that fail a 32-bit fstat signed check.
	mycc="${mycc} -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE"
	filter-lfs-flags

	local my_cc=$(tc-getCC)
	einfo "CC=${my_cc:=gcc}"

	# Workaround for bug #76512
	if use hardened ; then
		[[ "$(gcc-version)" == "3.4" ]] && replace-flags -O? -Os
	fi

	make DEBUG="" CC="${my_cc:=gcc}" OPT="${CFLAGS}" CCARGS="${mycc}" AUXLIBS="${mylibs}" \
		makefiles || die "configure problem"

	emake || die "compile problem"
}

src_install () {
	/bin/sh postfix-install \
		-non-interactive \
		install_root="${D}" \
		config_directory="/usr/share/doc/${PF}/defaults" \
		readme_directory="/usr/share/doc/${PF}/readme" \
		|| die "postfix-install failed"

	# Fix spool removal on upgrade
	rm -Rf "${D}/var"
	keepdir /var/spool/postfix

	# Install rmail for UUCP, closes bug #19127
	dobin auxiliary/rmail/rmail

	# Provide another link for legacy FSH
	dosym /usr/sbin/sendmail /usr/$(get_libdir)/sendmail

	# Install qshape tool
	dobin auxiliary/qshape/qshape.pl
	doman man/man1/qshape.1

	# Performance tuning tools and their manuals
	dosbin bin/smtp-{source,sink} bin/qmqp-{source,sink}
	doman man/man1/smtp-{source,sink}.1 man/man1/qmqp-{source,sink}.1

	# Set proper permissions on required files/directories
	dodir /var/lib/postfix
	keepdir /var/lib/postfix
	fowners postfix:postfix /var/lib/postfix
	fowners postfix:postfix /var/lib/postfix/.keep_${CATEGORY}_${PN}-${SLOT}
	fperms 0750 /var/lib/postfix
	fowners root:postdrop /usr/sbin/post{drop,queue}
	fperms 02711 /usr/sbin/post{drop,queue}

	keepdir /etc/postfix
	mv "${D}"/usr/share/doc/${PF}/defaults/*.cf "${D}"/etc/postfix
	if use mbox ; then
		mypostconf="mail_spool_directory=/var/spool/mail"
	else
		mypostconf="home_mailbox=.maildir/"
	fi
	"${D}/usr/sbin/postconf" -c "${D}/etc/postfix" \
		-e ${mypostconf} || die "postconf failed"

	insinto /etc/postfix
	newins "${FILESDIR}/smtp.pass" saslpass
	fperms 600 /etc/postfix/saslpass

	newinitd "${FILESDIR}/postfix.rc6.${RC_VER}" postfix || die "newinitd failed"

	mv "${S}/examples" "${D}/usr/share/doc/${PF}/"
	dodoc *README COMPATIBILITY HISTORY INSTALL PORTING RELEASE_NOTES*
	dohtml html/*

	pamd_mimic_system smtp auth account

	if use sasl ; then
		insinto /etc/sasl2
		newins "${FILESDIR}/smtp.sasl" smtpd.conf
	fi
}

pkg_postinst() {
	# Add postfix, postdrop user/group (bug #77565)
	group_user_check || die "Failed to check/add needed user/group"

	# Do not install server.{key,pem) SSL certificates if they already exist
	if use ssl && [[ ! -f "${ROOT}"/etc/ssl/postfix/server.key \
		&& ! -f "${ROOT}"/etc/ssl/postfix/server.pem ]] ; then
		SSL_ORGANIZATION="${SSL_ORGANIZATION:-Postfix SMTP Server}"
		install_cert /etc/ssl/postfix/server
		chown postfix:mail "${ROOT}"/etc/ssl/postfix/server.{key,pem}
	fi

	ebegin "Fixing queue directories and permissions"
	"${ROOT}/usr/$(get_libdir)/postfix/post-install" upgrade-permissions \
		daemon_directory=${ROOT}/usr/$(get_libdir)/postfix
	echo
	ewarn "If you upgraded from Postfix-1.x, you must revisit"
	ewarn "your configuration files. See"
	ewarn "  /usr/share/doc/${PF}/RELEASE_NOTES"
	ewarn "for a list of changes."

	if [[ ! -e /etc/mail/aliases.db ]] ; then
		echo
		ewarn "You must edit /etc/mail/aliases to suit your needs"
		ewarn "and then run /usr/bin/newaliases. Postfix will not"
		ewarn "work correctly without it."
	fi

	if [[ -e /etc/mailer.conf ]] ; then
		einfo
		einfo "mailwrapper support is discontinued."
		einfo "You may want to 'emerge -C mailwrapper' now."
		einfo
	fi
}
