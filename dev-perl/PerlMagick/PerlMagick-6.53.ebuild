# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
MODULE_AUTOR=JCRISTY

inherit perl-module

DESCRIPTION="Perl extension for calling ImageMagick's libMagick methods"
SRC_URI="mirror://cpan/id/J/JC/JCRISTY/PerlMagick-6.54.tar.gz"
SLOT=0
KEYWORDS="~amd64"
IUSE="jpeg png svg tiff truetype"
RESTRICT="mirror"
DEPEND="media-gfx/imagemagick[perl,jpeg=,png=.svg=,tiff=,truetype=]"
RDEPEND="${DEPEND}"
SRC_TEST="do"
