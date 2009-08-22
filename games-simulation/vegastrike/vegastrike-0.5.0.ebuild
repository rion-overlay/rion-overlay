# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /games-rpg/vegastrike/vegastrike-0.5.0.ebuild $

inherit flag-o-matic eutils games #subversion

#ESVN_REPO_URI="https://vegastrike.svn.sourceforge.net/svnroot/vegastrike/trunk"
#ESVN_PROJECT="vegastrike"
#ESVN_BOOTSTRAP="vegastrike/bootstrap-sh"

DESCRIPTION="A 3D space simulator that allows you to trade and bounty hunt"
HOMEPAGE="http://vegastrike.sourceforge.net/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~ppc"
IUSE="stencil-buffer gtk no-sound sdl debug"
#LANGS="de en-GB it"

SRC_URI="
	http://garr.dl.sourceforge.net/sourceforge/${PN}/${PN}-linux-${PV}.tar.bz2
	http://garr.dl.sourceforge.net/sourceforge/${PN}/${PN}-source-${PV}.tar.bz2"

RDEPEND="
	dev-lang/python
	virtual/opengl
	media-libs/jpeg
	media-libs/libpng
	dev-libs/expat
	media-libs/openal
	sdl? ( media-libs/libsdl )
	!no-sound? ( media-libs/libvorbis
				 media-libs/libogg
				 sdl? ( media-libs/sdl-mixer ) )
	virtual/glut
	virtual/glu
	gtk? ( x11-libs/gtk+ )
	!games-rpg/vegastrike-ded "
DEPEND="${RDEPEND}
	dev-lang/perl
	>=sys-devel/autoconf-2.58"

#S="${WORKDIR}"

pkg_setup() {
	games_pkg_setup
	einfo "If compiling fails for you on gl_globals.h, try to replace your"
	einfo "glext.h (usually found in /usr/include/GL/ with this one"
	einfo "http://oss.sgi.com/projects/ogl-sample/ABI/glext.h"
	einfo "remember to make backup of the original though"
}

src_unpack() {
	unpack "${PN}-linux-${PV}.tar.bz2"
	cd "${S}"

	mkdir "${S}/data"
	mv * data/
	mv ".${P}" data/

	cd "${WORKDIR}"
	unpack "${PN}-source-${PV}.tar.bz2"
	cd "${S}"

	# We don't need any precompiled stuff
	rm "${S}"/data/bin/*
	# Clean up data dir
	esvn_clean "${S}"
	#find -name SVN -type d -exec rm -rf '{}' \; >&/dev/null
	#find -name '*~' -type f -exec rm -f '{}' \; >&/dev/null

	# Sort out directory references
	sed -i \
		-e "s!/usr/local/share/doc!/usr/share/doc!" \
		-e "s!/usr/local/share/vegastrike!${GAMES_DATADIR}/vegastrike!" \
		-e "s!/usr/games/vegastrike!${GAMES_DATADIR}/vegastrike!" \
		-e "s!/usr/local/bin!${GAMES_BINDIR}!" \
		-e "s!/usr/local/lib/man!/usr/share/man!" \
		"${S}/data/documentation/vegastrike.1" \
		|| die "sed data/documentation/vegastrike.1 failed"

	cd "${S}/${P}"
	sed -i \
		-e "s!/usr/games/vegastrike!${GAMES_DATADIR}/vegastrike!" \
		-e "s!/usr/local/bin!${GAMES_BINDIR}!" \
		launcher/saveinterface.cpp \
		|| die "sed launcher/saveinterface.cpp failed"
	sed -i \
		"s!/usr/local/share/vegastrike!${GAMES_DATADIR}/vegastrike!" \
		src/common/common.cpp \
		|| die "sed src/common/common.cpp failed"
	sed -i \
		"s!/usr/share/local/vegastrike!${GAMES_DATADIR}/vegastrike!" \
		src/vsfilesystem.cpp \
		|| die "sed src/filesys.cpp failed"
	sed -i \
		-e '/^SUBDIRS =/s:tools::' \
		Makefile.am \
		|| die "sed Makefile.am failed"
	# is not possible here to use built in function subversion_bootstrap: it
	# won't work as expected: ./bootstrap isn't in main compile dir
	./bootstrap-sh
}

src_compile() {
	cd "${S}"/vegastrike
	local conf_opts="${conf_opts} --disable-dependency-tracking"

	if use debug; then
		conf_opts="${conf_opts} --enable-debug"
	else
		conf_opts="${conf_opts} --enable-release=2"
	fi

	if ! use gtk; then
		conf_opts="${conf_opts} --disable-gtk"
	fi

	CONFIGURE_OPTIONS="
		$(use_enable stencil-buffer)
		$(use_enable sdl)
		$(use_enable !no-sound sound)
		${conf_opts}"

	egamesconf $CONFIGURE_OPTIONS \
	    || die "egamesconf failed"

	# it causes corruptions
	filter-flags -ffast-math

	# Let's optimize, removing also broken -ffast-math
	if ! use debug; then
		sed -i -e "s:-ffast-math:${CXXFLAGS}:g" Makefile \
		    || die "sed of CXXFLAGS failed"
	fi

	emake || die "emake failed"
#	cd ${S}/vssetup/src/
#	perl ./build || die "perl build failed"
}

src_install() {

	cat << EOF > vsinstall
#!/bin/sh
(
mkdir \${HOME}/.${PN} 2> /dev/null
ln -s \${HOME}/.${PN} \${HOME}/.${P}
cd \${HOME}/.${PN}
cp "${GAMES_DATADIR}/${PN}"/data/setup.config .
cp -r "${GAMES_DATADIR}/${PN}"/data/.${P}/* .
cp "${GAMES_DATADIR}/${PN}/data/vegastrike.config" .
#${GAMES_BINDIR}/vssetup
vssetup
)
echo "If you wish to have your own music edit ~/.vegastrike/*.m3u"
echo "Each playlist represents a place or situation in Vega Strike"
exit 0
EOF


	dogamesbin vegastrike \
		|| die "Creation of vegastrike (the binary) failed"
	dogamesbin vsinstall \
		|| die "Creation of vsinstall failed"
	dogamesbin vegaserver \
		|| die "Creation of vegaserver failed"
	dogamesbin mesher \
		|| die "Creation of vegaserver failed"

	if use gtk; then
#		dogamesbin vslauncher \
#			|| die "Creation of vslauncher failed"
		newgamesbin vssetup vssetup || die "newgamesbin failed"
	fi

	cp vsinstall data/bin/vsinstall || die "cp failed"

	doicon  "${S}/data/vegastrike.xpm"
	make_desktop_entry "vegastrike" "Vegastrike" "vegastrike.xpm"

	doman "${S}"/data/documentation/*.1
	dodoc "${S}"/data/documentation/*.txt

	dodir "${GAMES_DATADIR}/${PN}"
	cp -r data/ "${D}/${GAMES_DATADIR}/${PN}/" || die "cp failed (data)"
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	einfo "run vsinstall to setup your Account,"
#	einfo "then run vegastrike (or the deprecated vslauncher)"
#	einfo "    to start Vega Strike;"
	einfo "or run vssetup to set up Vega Strike."
	einfo "to start Vega Strike Server run vegaserver."
}

