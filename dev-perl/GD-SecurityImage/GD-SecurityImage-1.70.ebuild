# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

NODULE_AUTHOR=BURAK
inherit perl-module

DESCRIPTION="Security image (captcha) generator"
SRC_URI="mirror://cpan/authors/id/B/BU/BURAK/"${P}".tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test imagemagick"


RDEPEND="imagemagick? (
		media-gfx/imagemagick[jpeg,openmp,perl,png,tiff,jbig,jpeg2k] )
		dev-perl/GD"

DEPEND="test? ( perl-core/Test-Simple
				dev-perl/Test-Pod
				dev-perl/Test-Pod-Coverage
				dev-perl/GD
			imagemagick? (
				media-gfx/imagemagick[jpeg,openmp,perl,png,tiff,jbig,jpeg2k] ) )"

SRC_TEST="do"
