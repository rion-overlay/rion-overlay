# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit base

DESCRIPTION="Deleted to trash IMAP plugin for Dovecot"
HOMEPAGE="http://wiki.dovecot.org/Plugins/deleted-to-trash"
SRC_URI="http://wiki2.dovecot.org/Plugins/deleted-to-trash?action=AttachFile&do=get&target=deleted-to-trash-plugin_0.3_for_dovecot_2.tar -> ${P}.tar"

LICENSE="as-is"
KEYWORDS="~amd64 ~x86"
SLOT="0"

IUSE=""
RDEPEND="=net-mail/dovecot-2.0*"
DEPEND="${RDEPEND}"
PATCHES=("${FILESDIR}"/fix_names_and_destdir.patch )

S="${WORKDIR}"

src_install() {
	base-src_install

	insinto /etc/dovecot/conf.d
	doins "${WORKDIR}"/29-delete-to-trash.conf
}
