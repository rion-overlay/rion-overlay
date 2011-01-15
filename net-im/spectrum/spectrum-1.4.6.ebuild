# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=2

inherit cmake-utils

DESCRIPTION="Spectrum is an XMPP transport/gateway"
HOMEPAGE="http://spectrum.im"

SRC_URI="http://spectrum.im/attachments/download/34/spectrum-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="mysql sqlite symlinks tools"

RDEPEND=">=dev-libs/poco-1.3.3[mysql?,sqlite?]
	>=net-im/pidgin-2.6.0
	>=net-libs/gloox-1.0
	dev-python/xmpppy"
DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/cmake"

pkg_setup() {
	if ! ( use sqlite || use mysql ); then
		ewarn "No database use flag set!"
		ewarn "You need to enable the mysql or sqlite use flag!"
		die
	fi
}
src_unpack() {
	unpack ${A}
}

src_install () {
	cmake-utils_src_install

	# Install transports with seperate config files (default).
	# If USE="symlinks" is set, install one config file with symlinks to all transports.
	if ! use symlinks ; then
		insinto /etc/spectrum
		for protocol in aim facebook gg icq irc msn msn_pecan myspace qq simple sipe twitter xmpp yahoo; do
			sed -e 's,S2P,'${protocol}',g' "${FILESDIR}/spectrum.cfg" > "${WORKDIR}/${protocol}.cfg" || die
			doins "${WORKDIR}/${protocol}.cfg" || die

			sed -e 's,S2P,'${protocol}',g' "${FILESDIR}/spectrum.initd" > "${WORKDIR}/spectrum.initd.${protocol}" || die
			newinitd "${WORKDIR}/spectrum.initd.${protocol}" "spectrum.${protocol}" || die

			sed -e 's,S2P,'${protocol}',g' "${FILESDIR}/spectrum.confd" > "${WORKDIR}/spectrum.confd.${protocol}" || die
			newconfd "${WORKDIR}/spectrum.confd.${protocol}" "spectrum.${protocol}" || die
		done
	else
		insinto /etc/spectrum
		newins "${FILESDIR}/spectrum.symlink.cfg" "spectrum.cfg" || die
		port=5437
		for protocol in aim facebook gg icq irc msn msn_pecan myspace qq simple	sipe twitter xmpp yahoo; do
			dosym "${IMAGE}/etc/spectrum/spectrum.cfg" "${IMAGE}/etc/spectrum/${protocol}:${port}.cfg" || die
			port=$[${port}+1]

			sed -e 's,S2P,'${protocol}',g' "${FILESDIR}/spectrum.initd" > "${WORKDIR}/spectrum.initd.${protocol}" || die
			newinitd "${WORKDIR}/spectrum.initd.${protocol}" "spectrum.${protocol}" || die

			sed -e 's,S2P,'${protocol}',g' "${FILESDIR}/spectrum.confd" > "${WORKDIR}/spectrum.confd.${protocol}" || die
			sed -e 's,${protocol}.cfg,'${protocol}:${port}',g' "${FILESDIR}/spectrum.confd" > "${WORKDIR}/spectrum.confd.${protocol}"
			newconfd "${WORKDIR}/spectrum.confd.${protocol}" "spectrum.${protocol}" || die
		done
	fi

	# Directories
	dodir "${IMAGE}/var/lib/spectrum" || die
	dodir "${IMAGE}/var/log/spectrum" || die
	dodir "${IMAGE}/var/run/spectrum" || die

	# Directories for each transport
	for protocol in aim facebook gg icq irc msn msn_pecan myspace qq simple sipe twitter xmpp yahoo; do
		dodir "${IMAGE}/var/lib/spectrum/$protocol/database" || die
		dodir "${IMAGE}/var/lib/spectrum/$protocol/userdir" || die
		dodir "${IMAGE}/var/lib/spectrum/$protocol/filetransfer_cache" || die
	done

	# Install mysql schema
	if use mysql; then
		insinto "${IMAGE}/usr/share/spectrum/schemas"
		doins schemas/* || die
	fi

	# Install misc tools
	if use tools; then
		insinto "${IMAGE}/usr/share/spectrum/tools"
		doins tools/* || die
	fi
}

pkg_postinst() {
	# Set correct rights
	chown jabber:jabber -R "${IMAGE}/etc/spectrum" || die
	chown jabber:jabber -R "${IMAGE}/var/lib/spectrum" || die
	chown jabber:jabber -R "${IMAGE}/var/log/spectrum" || die
	chown jabber:jabber -R "${IMAGE}/var/run/spectrum" || die
	chmod 750 "${IMAGE}/etc/spectrum" || die
	chmod 750 "${IMAGE}/var/lib/spectrum" || die
	chmod 750 "${IMAGE}/var/log/spectrum" || die
	chmod 750 "${IMAGE}/var/run/spectrum" || die
}
