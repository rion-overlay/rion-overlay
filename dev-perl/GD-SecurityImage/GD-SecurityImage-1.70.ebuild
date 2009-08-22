# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

NODULE_AUTHOR=BURAK
inherit perl-module

DESCRIPTION="Security image (captcha) generator"
SRC_URI="mirror://cpan/authors/id/B/BU/BURAK/"${P}".tar.gz"

SLOT="0"
KEYWORDS=""
IUSE="test imagemagick"

RDEPEND="perl-core/Test-Simple
		imagemagick? ( dev-perl/Image-Magick )
		test? ( dev-perl/Test-Pod )"

SRC_TEST="do"
