# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/nspr/nspr-4.8.ebuild,v 1.8 2009/09/23 17:06:18 armin76 Exp $

EAPI="2"

inherit eutils multilib toolchain-funcs versionator cvs

MIN_PV="$(get_version_component_range 2)"

DESCRIPTION="Netscape Portable Runtime"
HOMEPAGE="http://www.mozilla.org/projects/nspr/"
SRC_URI=""

ECVS_MODULE="mozilla/nsprpub"
ECVS_SERVER="cvs-mirror.mozilla.org:/cvsroot"

LICENSE="|| ( MPL-1.1 GPL-2 LGPL-2.1 )"
SLOT="0"
KEYWORDS=""
IUSE="ipv6 debug"

DEPEND=">=dev-db/sqlite-3.5"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_prepare() {
	mkdir build inst
	# Respect LDFLAGS
	sed -i -e 's/\$(MKSHLIB) \$(OBJS)/\$(MKSHLIB) \$(LDFLAGS) \$(OBJS)/g' \
		mozilla/nsprpub/config/rules.mk
}

src_configure() {
	: ;
}

src_compile() {
	cd "${S}"/build
	echo > "${T}"/test.c
	$(tc-getCC) -c "${T}"/test.c -o "${T}"/test.o
	case $(file "${T}"/test.o) in
		*64-bit*) myconf="${myconf} --enable-64bit";;
		*32-bit*) ;;
		*) die "Failed to detect whether your arch is 64bits or 32bits, disable distcc if you're using it, please";;
	esac

	myconf="${myconf} --libdir=/usr/$(get_libdir)/nspr \
		--enable-system-sqlite 	--with-mozilla --with-pthreads"

	ECONF_SOURCE="../mozilla/nsprpub" econf \
		$(use_enable ipv6) \
		$(use_enable debug) \
		${myconf} || die "econf failed"
	make CC="$(tc-getCC)" CXX="$(tc-getCXX)" || die
}

src_install () {
	# Their build system is royally confusing, as usual
	MINOR_VERSION=${MIN_PV} # Used for .so version
	cd "${S}"/build
	emake DESTDIR="${D}" install || die "emake install failed"

	cd "${D}"/usr/$(get_libdir)/nspr
	for file in *.so; do
		mv ${file} ${file}.${MINOR_VERSION}
		ln -s ${file}.${MINOR_VERSION} ${file}
	done
	# cope with libraries being in /usr/lib/nspr
	dodir /etc/env.d
	echo "LDPATH=/usr/$(get_libdir)/nspr" > "${D}/etc/env.d/08nspr"

	# install nspr-config
	dobin "${S}"/build/config/nspr-config

	# create pkg-config file
	insinto /usr/$(get_libdir)/pkgconfig/
	doins "${S}"/build/config/nspr.pc

	# Remove stupid files in /usr/bin
	rm "${D}"/usr/bin/{prerr.properties,nspr.pc}
}

pkg_postinst() {
	ewarn
	ewarn "Please make sure you run revdep-rebuild after upgrade."
	ewarn "This is *extremely* important to ensure your system nspr works properly."
	ewarn
}
