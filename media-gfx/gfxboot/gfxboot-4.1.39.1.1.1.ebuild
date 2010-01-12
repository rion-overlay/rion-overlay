# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit rpm toolchain-funcs versionator

DESCRIPTION="gfxboot allows you to create gfx menus for bootmanagers."
HOMEPAGE="http://suse.com"
# We need find better place for src and repack it, but now...

MPV=$(get_version_component_range 1-3 )
RPV=$(get_version_component_range 4- )
SRC_URI="http://download.opensuse.org/source/distribution/11.2/repo/oss/suse/src/gfxboot-${MPV}-${RPV}.src.rpm"
S="${WORKDIR}/${PN}-${MPV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

#to update linguas list you can do ls *.po | sed 's/\(\w*\).po$/\1/' | sed -n 'H;${x;s/\n/ /g;p}'
#in po dir of SuSE theme and insert list here

IUSE="themes doc animate speech beep preview ${IUSE_LINGUAS}"
LANGS=" af ar bg ca cs da de el en es et fi fr gl gu hi hr hu id it ja ko lt mr nb nl pa pl pt_BR pt ro ru sk sl sr sv ta tr uk wa xh zh_CN zh_TW zu"
IUSE="${IUSE} ${LANGS// / linguas_}"

DEPEND="dev-libs/libxslt
	dev-lang/nasm
	>=media-libs/freetype-2
	themes? ( dev-libs/fribidi )
	doc? (	app-text/xmlto
		app-text/docbook-xml-dtd:4.1.2
		dev-perl/HTML-Parser
		|| (
			www-client/w3m
			www-client/lynx
			www-client/links
		) )"
RDEPEND="app-arch/cpio"
RESTRICT="mirror"

pkg_setup() {
	if ! use themes; then
		if use animate || use beep || use speech; then
			ewarn "There is no use for 'animate', 'beep' or 'speech' flags"
			ewarn "if themes are disabled."
		fi
	fi
}

src_prepare () {
	mv "${WORKDIR}/themes" "${S}/"
	cd "${S}"

	# going Gentoo-way
	sed -i	-e "s:^CFLAGS.*:CFLAGS=${CFLAGS} -Wno-pointer-sign:" \
			-e 's:sbin:bin:g' Makefile
	#	-e 's:bootsplash/$$i:bootsplash/`basename $$i`:g'
	sed -i	-e 's#/usr/sbin/grub#/sbin/grub#' \
			-e 's#/usr/lib/grub#/lib/grub/i386-pc#' \
			-e 's#$ENV{PATH} = "#$ENV{PATH} = "/opt/vmware/workstation/bin:#' \
			-e 's#/usr/bin/vmware#/opt/vmware/workstation/bin/vmware#' gfxboot

	#convert utf8le to ucs-4le because utf8le may cause compilation failure
	sed 's/utf32le/ucs-4le/' -i gfxboot-compile.c
	sed 's/utf32le/ucs-4le/' -i gfxboot-font.c
	sed 's/utf32le/ucs-4le/' -i themes/openSUSE/po/bin/po2txt

	if use themes; then

		[[ -n $LINGUAS ]] && LINGUAS="${LINGUAS/da/dk}" || LINGUAS=en
		# We want to see penguins, many penguins... all the time
		use animate && sed -i "/penguin=/s:0:100:" `find . -type f -name gfxboot.cfg`
		# some signal on start
		use beep || sed -i "/beep=/s:1:0:" `find . -type f -name gfxboot.cfg`
		# experimental talking
		use speech && sed -i "/talk=/s:0:1:" `find . -type f -name gfxboot.cfg`

		# We want our native language by default
		sed -i "/DEFAULT_LANG =/s:$: `echo $LINGUAS|cut -f1 -d\ `:" \
			`find . -type f -name Makefile`

		# We want _only_ our favorite languages...
		for i in `find themes/* -type f -name languages`; do
			locale -a|grep _ |sed 's/\(\w\+\)\..*/\1/'|uniq > $i
		done
		# ...and nothing else
		has "en" "$LINGUAS" || LINGUAS="$LINGUAS en" #force adding en
		for i in `find ./themes/*/help-*/* -type d; \
			find . -path "./themes/*/po/*" -type f -name "*.po"`;do
			if has `basename "$i" .po` "$LINGUAS" || has `basename "$i"` "$LINGUAS"; then
				einfo "keeping $i"
				else	rm -rf "$i"
			fi
		done
	fi
}

src_compile() {
	emake DESTDIR="${D}" installsrc || die "Make installsrc failed!"
	emake X11LIBS=/usr/X11R6/$(get_libdir) || die "Make failed!"

	if use themes; then
		emake themes || die "Make themes failed!"
	fi

	if use doc; then
		emake doc || die "Make doc failed!"
	fi
}

src_install() {
	make DESTDIR="${D}" install || die "Install failed"
	doman doc/gfxboot.8
	if use doc; then
		dodoc Changelog gfxboot
		dohtml doc/gfxboot.html
	fi
}

pkg_postinst() {
	if use themes; then
		elog "To use gfxboot themes on your machine do following:"
		echo
		elog "1) Pick up one of build-in themes in /etc/bootsplash"
		elog "   or one from kde-look.org or similar site"
		elog "2) Patch your grub_legacy to use gfxmenu or use grub2"
		elog "   or lilo"
		elog "3) copy 'message' to /boot/ [aka root of boot partition]"
		elog "4) Set up gfxmenu in bootloader, as example"
		elog "   'gfxmenu /message' line if your root=boot partition"
		elog "   in grub_legacy"
	fi
}
