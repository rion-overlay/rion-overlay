# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker

DESCRIPTION="Ricoh SP 150 printer driver"
HOMEPAGE="http://support.ricoh.com/bb/html/dr_ut_e/re1/model/sp150/sp150.htm"
# http://support.ricoh.com/bb/html/dr_ut_e/re1/model/sp150/sp150.htm
SRC_URI="RICOH-SP-150SUw_1.0-27_amd64.deb"
RESTRICT="binchecks fetch strip"
S="$WORKDIR"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_install() {
	insinto /opt
	doins -r opt/RICOH
	insinto /usr/libexec/cups/filter/
	doins usr/lib/cups/filter/RICOH_SP_150SUwFilter.app
	fperms 0755 /usr/libexec/cups/filter/RICOH_SP_150SUwFilter.app
	insinto /usr/share/cups/model
	doins -r usr/share/cups/model/RICOH
}
