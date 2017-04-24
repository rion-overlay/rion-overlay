# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_5 python3_6 )

inherit distutils-r1 git-r3 ssl-cert user

DESCRIPTION="The great messenger of the gods"
HOMEPAGE="https://github.com/Ri0n/Hermes"

EGIT_REPO_URI="git://github.com/Ri0n/Hermes.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-lang/python[sqlite]
	dev-python/ply
	dev-python/twisted
	ssl? ( dev-python/twisted[crypt] )
	dev-python/inotifyx"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /dev/null ${PN}
}

src_install() {
	distutils-r1_src_install
	newinitd "${FILESDIR}/init" ${PN}
	keepdir /var/lib/${PN}
	fowners ${PN}:${PN} /var/lib/${PN}
	fperms 2744 /var/lib/${PN}
}

pkg_postinst() {
	# Do not install server.{key,pem) SSL certificates if they already exist
	if use ssl && [[ ! -f "${ROOT}"/etc/ssl/${PN}/server.key \
			&& ! -f "${ROOT}"/etc/ssl/${PN}/server.crt ]] ; then
		SSL_ORGANIZATION="${SSL_ORGANIZATION:-Hermes notification daemon}"
		install_cert /etc/ssl/${PN}/server
		chown ${PN}:${PM} "${ROOT}"/etc/ssl/${PN}/server.{key,crt}

		elog "Self-signed serctificate was generated and put to"
		elog "/etc/ssl/${PN}/. Feel free to replace it with your own."
	fi

}
