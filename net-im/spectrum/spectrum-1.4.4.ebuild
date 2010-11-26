# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=2

inherit cmake-utils

DESCRIPTION="Spectrum is an XMPP transport/gateway"
HOMEPAGE="http://spectrum.im"

SRC_URI="http://spectrum.im/attachments/download/30/spectrum-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="mysql sqlite tools"

RDEPEND=">=dev-libs/poco-1.3.3[mysql?,sqlite?]
	>=net-im/pidgin-2.6.0
	>=net-libs/gloox-1.0
	dev-python/xmpppy"
DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/cmake"

src_unpack() {
	unpack ${A}
}

src_install () {
	cmake-utils_src_install

	# Install transports
	insinto /etc/spectrum
	for protocol in aim facebook gg icq irc msn msn_pecan myspace qq simple sipe twitter xmpp yahoo; do
		sed -e 's,SPECTRUMGEN2PROTOCOL,'${protocol}',g' "${FILESDIR}/spectrum.cfg" > "${WORKDIR}/${protocol}.cfg" || die
		doins "${WORKDIR}/${protocol}.cfg" || die

		sed -e 's,SPECTRUMGEN2PROTOCOL,'${protocol}',g' "${FILESDIR}/spectrum.initd" > "${WORKDIR}/spectrum.initd.${protocol}" || die
		newinitd "${WORKDIR}/spectrum.initd.${protocol}" "spectrum.${protocol}" || die

		sed -e 's,SPECTRUMGEN2PROTOCOL,'${protocol}',g' "${FILESDIR}/spectrum.confd" > "${WORKDIR}/spectrum.confd.${protocol}" || die
		newconfd "${WORKDIR}/spectrum.confd.${protocol}" "spectrum.${protocol}" || die
	done

	# Directories
	dodir "${IMAGE}/var/lib/spectrum"
	dodir "${IMAGE}/var/log/spectrum"
	dodir "${IMAGE}/var/run/spectrum"

	# Directories for each transport
	for protocol in aim facebook gg icq irc msn msn_pecan myspace qq simple sipe twitter xmpp yahoo; do
		dodir "${IMAGE}/var/lib/spectrum/$protocol/database"
		dodir "${IMAGE}/var/lib/spectrum/$protocol/userdir"
		dodir "${IMAGE}/var/lib/spectrum/$protocol/filetransfer_cache"
	done

	# Install mysql schema
	if use mysql; then
		insinto "${IMAGE}/usr/share/spectrum/schemas"
		doins schemas/*
	fi

	# Install misc tools
	if use tools; then
		insinto "${IMAGE}/usr/share/spectrum/tools"
		doins tools/*
	fi
}

pkg_postinst() {
	# Set correct rights
	chown jabber:jabber -R "${IMAGE}/etc/spectrum"
	chown jabber:jabber -R "${IMAGE}/var/lib/spectrum"
	chown jabber:jabber -R "${IMAGE}/var/log/spectrum"
	chown jabber:jabber -R "${IMAGE}/var/run/spectrum"
	chmod 750 "${IMAGE}/etc/spectrum"
	chmod 750 "${IMAGE}/var/lib/spectrum"
	chmod 750 "${IMAGE}/var/log/spectrum"
	chmod 750 "${IMAGE}/var/run/spectrum"
}
