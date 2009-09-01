# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit perl-app

DESCRIPTION="Wiki compiler which converts wiki pages of different format into static HTML pages"
HOMEPAGE="http://ikiwiki.info"
SRC_URI="ftp://ftp.de.debian.org/debian/pool/main/i/ikiwiki/${PN}_${PV}.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="dev-lang/perl \
	dev-perl/Text-Markdown \
	dev-perl/HTML-Parser \
	dev-perl/HTML-Template \
	dev-perl/HTML-Scrubber \
	dev-perl/CGI-Session \
	>=dev-perl/CGI-FormBuilder-3.05 \
	dev-perl/Mail-Sendmail \
	dev-perl/Time-Duration \
	dev-perl/TimeDate \
	dev-perl/RPC-XML \
	dev-perl/XML-Simple \
	dev-perl/XML-Feed \
	dev-perl/File-MimeInfo \
	>=dev-perl/Locale-gettext-1.04"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${PN}_${PV}.tar.gz
	cd "$S"
	rm doc/todo/calendar_--_archive_browsing_via_a_calendar_frontend.mdwn
}

src_compile() {
	perl-app_src_compile
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	rm "${D}"/usr/lib/perl5/*/*/perllocal.pod
}
