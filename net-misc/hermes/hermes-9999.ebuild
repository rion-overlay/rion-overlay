# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2"
RESTRICT_PYTHON_ABIS="3.*"
SUPPORT_PYTHON_ABIS="1"
PYTHON_MODNAME="hermes"

inherit distutils git-2 ssl-cert user

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
	ssl? ( >=dev-python/twisted-core-8.2.0[crypt] )
	>=dev-python/twisted-words-8.2.0
	>=dev-python/twisted-names-8.2.0
	>=dev-python/twisted-web-8.2.0
	dev-python/inotifyx"

pkg_setup() {
	enewgroup ${PN} || die
	enewuser ${PN} -1 -1 /dev/null ${PN} || die
}

src_install() {
	distutils_src_install
	newinitd "${FILESDIR}/init" ${PN} || die
	keepdir /var/lib/${PN} || die
	fowners ${PN}:${PN} /var/lib/${PN} || die
	fperms 2744 /var/lib/${PN}
}

pkg_postinst() {
	distutils_pkg_postinst

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
