# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils subversion python

DESCRIPTION="XMPP skype gateway"
HOMEPAGE="http://code.google.com/p/karaka"
ESVN_REPO_URI="http://karaka.googlecode.com/svn/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	net-im/pyxmpp
	dev-python/skype4py
	dev-python/mysql-python"

src_install() {
	dobin bin/karaka.sh
	insinto $(python_get_sitedir)
	doins -r karaka
	newins master.py karaka-master.py
	newins register.py karaka-register.py
	newins slave.py karaka-slave.py
	doinitd "${FILESDIR}"/{karaka-master,karaka-register,karaka-slave}
	dosed 's/-u karaka/-u jabber/' /etc/init.d/{karaka-master,karaka-register,karaka-slave}
	dosed "s:INSPATH:$(python_get_sitedir):" /etc/init.d/{karaka-master,karaka-register,karaka-slave}
	dosed "s|/tmp/karaka_master.log|/var/log/jabber/karaka-master.log|" \
		$(python_get_sitedir)/karaka-master.py
	dosed "s|/tmp/karaka_master.pid|/var/run/jabber/karaka_master.pid|" \
		$(python_get_sitedir)/karaka-master.py
	dosed "s|/tmp/karaka_register.log|/var/log/jabber/karaka-register.log|" \
		$(python_get_sitedir)/karaka-register.py
	dosed "s|/tmp/karaka_register.pid|/var/run/jabber/karaka_register.pid|" \
		$(python_get_sitedir)/karaka-register.py
	dosed "s|/tmp/karaka_slave.log|/var/log/jabber/karaka-slave.log|" \
		$(python_get_sitedir)/karaka-slave.py
	dosed "s|/tmp/karaka_slave.pid|/var/run/jabber/karaka_slave.pid|" \
		$(python_get_sitedir)/karaka-slave.py
}
