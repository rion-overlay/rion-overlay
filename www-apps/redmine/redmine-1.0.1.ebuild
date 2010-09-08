# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/redmine/redmine-0.9.6.ebuild,v 1.2 2010/07/10 04:54:33 matsuu Exp $

EAPI="2"
USE_RUBY="ruby18"
inherit eutils confutils depend.apache ruby-ng

DESCRIPTION="Redmine is a flexible project management web application written using Ruby on Rails framework"
HOMEPAGE="http://www.redmine.org/"
SRC_URI="mirror://rubyforge/${PN}/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2"
SLOT="0"
IUSE="cvs darcs fastcgi git imagemagick mercurial mysql openid passenger postgres sqlite3 subversion"

ruby_add_rdepend "=dev-ruby/rails-2.3.5:2.3
	>=dev-ruby/coderay-0.7.6.227
	>=dev-ruby/rubygems-1.3.5
	>=dev-ruby/ruby-net-ldap-0.0.4"
#ruby_add_rdepend "dev-ruby/activerecord:2.3[mysql?,postgres?,sqlite3?]"
ruby_add_rdepend fastcgi dev-ruby/ruby-fcgi
ruby_add_rdepend imagemagick dev-ruby/rmagick
ruby_add_rdepend openid dev-ruby/ruby-openid
#ruby_add_rdepend passenger "=dev-ruby/rack-1.0.1* www-apache/passenger"

RDEPEND="${RDEPEND}
	passenger? ( =dev-ruby/rack-1.0.1* www-apache/passenger )
	dev-ruby/activerecord:2.3[mysql?,postgres?,sqlite3?]
	cvs? ( >=dev-vcs/cvs-1.12 )
	darcs? ( dev-vcs/darcs )
	git? ( dev-vcs/git )
	mercurial? ( dev-vcs/mercurial )
	subversion? ( >=dev-vcs/subversion-1.3 )"

REDMINE_DIR="/var/lib/${PN}"

pkg_setup() {
	confutils_require_any mysql postgres sqlite3
	enewgroup redmine
	# home directory is required for SCM.
	enewuser  redmine -1 -1 "${REDMINE_DIR}" redmine
}

all_ruby_prepare() {
	rm -fr log files/delete.me || die
	rm -fr vendor/plugins/coderay-0.7.6.227 || die
	rm -fr vendor/plugins/ruby-net-ldap-0.0.4 || die
	rm -fr vendor/rails || die
	echo "CONFIG_PROTECT=\"${REDMINE_DIR}/config\"" > "${T}/50${PN}"
}

all_ruby_install() {
	dodoc doc/{CHANGELOG,INSTALL,README_FOR_APP,RUNNING_TESTS,UPGRADING} || die
	rm -fr doc || die

	keepdir /var/log/${PN} || die
	dosym /var/log/${PN}/ "${REDMINE_DIR}/log" || die

	insinto "${REDMINE_DIR}"
	doins -r . || die
	keepdir "${REDMINE_DIR}/files" || die
	keepdir "${REDMINE_DIR}/public/plugin_assets" || die

	fowners -R redmine:redmine \
		"${REDMINE_DIR}/config/environment.rb" \
		"${REDMINE_DIR}/files" \
		"${REDMINE_DIR}/public/plugin_assets" \
		"${REDMINE_DIR}/tmp" \
		/var/log/${PN} || die
	# for SCM
	fowners redmine:redmine "${REDMINE_DIR}" || die

	if use passenger ; then
		has_apache
		insinto "${APACHE_VHOSTS_CONFDIR}"
		doins "${FILESDIR}/10_redmine_vhost.conf" || die
	else
		newconfd "${FILESDIR}/${PN}.confd" ${PN} || die
		newinitd "${FILESDIR}/${PN}.initd" ${PN} || die
		keepdir /var/run/${PN} || die
		fowners -R redmine:redmine /var/run/${PN} || die
		dosym /var/run/${PN}/ "${REDMINE_DIR}/tmp/pids" || die
	fi
	doenvd "${T}/50${PN}" || die
}

pkg_postinst() {
	einfo
	if [ -e "${ROOT}${REDMINE_DIR}/config/initializers/session_store.rb" ] ; then
		elog "Execute the following command to upgrade environment:"
		elog
		elog "# emerge --config =${CATEGORY}/${PF}"
		elog
		elog "For upgrade instructions take a look at:"
		elog "http://www.redmine.org/wiki/redmine/RedmineUpgrade"
	else
		elog "Execute the following command to initlize environment:"
		elog
		elog "# cd ${REDMINE_DIR}"
		elog "# cp config/database.yml.example config/database.yml"
		elog "# \${EDITOR} config/database.yml"
		elog "# set gemhome in /etc/gemrc"
		elog "# Example: gemhome: /usr/lib64/ruby/gems/1.8/gems"
		elog "# emerge --config =${CATEGORY}/${PF}"
		elog
		elog "Installation notes are at official site"
		elog "http://www.redmine.org/wiki/redmine/RedmineInstall"
	fi
	einfo
}

pkg_config() {
	if [ ! -e "${REDMINE_DIR}/config/database.yml" ] ; then
		eerror "Copy ${REDMINE_DIR}/config/database.yml.example to ${REDMINE_DIR}/config/database.yml and edit this file in order to configure your database settings for \"production\" environment."
		die
	fi

	local RAILS_ENV=${RAILS_ENV:-production}

	cd "${REDMINE_DIR}"
	if [ -e "${REDMINE_DIR}/config/initializers/session_store.rb" ] ; then
		einfo
		einfo "Upgrade database."
		einfo

		einfo "Migrate database."
		RAILS_ENV="${RAILS_ENV}" rake db:migrate || die
		einfo "Upgrade the plugin migrations."
		RAILS_ENV="${RAILS_ENV}" rake db:migrate:upgrade_plugin_migrations # || die
		RAILS_ENV="${RAILS_ENV}" rake db:migrate_plugins || die
		einfo "Clear the cache and the existing sessions."
		rake tmp:cache:clear || die
		rake tmp:sessions:clear || die
	else
		einfo
		einfo "Initialize database."
		einfo

		einfo "Generate a session store secret."
		rake config/initializers/session_store.rb || die
		einfo "Create the database structure."
		RAILS_ENV="${RAILS_ENV}" rake db:migrate || die
		einfo "Insert default configuration data in database."
		RAILS_ENV="${RAILS_ENV}" rake redmine:load_default_data || die
	fi

	if [ ! -e "${REDMINE_DIR}/config/email.yml" ] ; then
		ewarn
		ewarn "Copy ${REDMINE_DIR}/config/email.yml.example to ${REDMINE_DIR}/config/email.yml and edit this file to adjust your SMTP settings."
		ewarn
	fi
}
