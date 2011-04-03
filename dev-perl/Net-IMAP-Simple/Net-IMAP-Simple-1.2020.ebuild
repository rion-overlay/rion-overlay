# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

MODULE_AUTHOR="JETTERO"

inherit perl-module

DESCRIPTION="Perl extension for simple IMAP account handling."

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-perl/Class-Accessor
	dev-perl/Coro
	dev-perl/DateTime
	dev-perl/DateTime-Format-Mail
	dev-perl/DateTime-Format-Natural
	dev-perl/Email-Address
	dev-perl/Email-MIME
	dev-perl/Email-MIME-ContentType
	dev-perl/Email-Simple
	dev-perl/Encode-IMAPUTF7
	virtual/perl-MIME-Base64
	dev-perl/List-MoreUtils
	dev-perl/Net-SSLeay
	dev-perl/Net-Server-Coro
	dev-perl/regexp-common
	dev-perl/DateTime-Format-Strptime
	dev-perl/Parse-RecDescent"
DEPEND="${RDEPEND}"

SRC_TEST="do"
