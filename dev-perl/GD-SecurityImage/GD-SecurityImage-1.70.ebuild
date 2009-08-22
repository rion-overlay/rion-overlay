# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

NODULE_AUTHOR=BURAK
inherit perl-module

DESCRIPTION="Security image (captcha) generator"
SRC_URI="mirror://cpan/authors/id/B/BU/BURAK/"${P}".tar.gz"

SLOT="0"
KEYWORDS="~amd64"
IUSE="test imagemagick"

DEPEND="perl-core/Test-Simple
		imagemagick? ( media-gfx/imagemagick[perl] )
		test? ( dev-perl/Test-Pod )"
RDEPEND="perl-core/Test-Simple"

SRC_TEST="do"
