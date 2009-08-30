# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils multilib versionator

DESCRIPTION="Mozilla LDAP C SDK"
HOMEPAGE="http://wiki.mozilla.org/LDAP_C_SDK"
SRC_URI="ftp://ftp.mozilla.org/pub/mozilla.org/directory/c-sdk/releases/v${PV}/src/${P}.tar.gz"

LICENSE="MPL-1.1 GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64  ~x86"
IUSE="ipv6 debug sasl"

DEPEND=">=dev-libs/nss-3.11.4
	>=dev-libs/nspr-4.0.1
	>=dev-libs/svrcore-4.0.0
	sasl? ( dev-libs/cyrus-sasl )"

RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-6.0.4-pkgconfig.patch
}

src_compile() {
	cd mozilla/directory/c-sdk

	if use amd64 ; then
		myconf="${myconf} --enable-64bit"
	else
		myconf=""
	fi

	if use ipv6; then
		myconf="${myconf} --enable-ipv6"
	fi

	if use sals; then
		myconf="${myconf} --with-sasl"
	fi

	myconf="${myconf} --libdir=/usr/$(get_libdir)/mozldap"

	econf $(use_enable debug) \
		--with-svrcore-inc=/usr/include/svrcore \
		--with-svrcore-lib=/usr/$(get_libdir)/svrcore \
		--enable-clu \
		--enable-optimize \
		${myconf} || die "econf failed"
	make || die
}

src_install () {
	# Their build system is royally fucked, as usual
	cd "${S}"/mozilla/directory/c-sdk
	sed -e "s,%libdir%,\$\{exec_prefix\}/$(get_libdir)/${PN},g" \
	    -e "s,%prefix%,/usr,g" \
	    -e "s,%major%,$(get_major_version ${PV}),g" \
	    -e "s,%minor%,$(get_version_component_range 2 ${PV}),g" \
	    -e "s,%submin%,$(get_version_component_range 3 ${PV}),g" \
	    -e "s,%libsuffix%,$(get_major_version ${PV})$(get_version_component_range 2 ${PV}),g" \
	    -e "s,%bindir%,\$\{exec_prefix\}/$(get_libdir)/${PN},g" \
	    -e "s,%exec_prefix%,\$\{prefix\},g" \
	    -e "s,%includedir%,\$\{exec_prefix\}/include/${PN},g" \
	    -e "s,%NSPR_VERSION%,$(pkg-config --modversion nspr),g" \
	    -e "s,%NSS_VERSION%,$(pkg-config --modversion nss),g" \
	    -e "s,%SVRCORE_VERSION%,$(pkg-config --modversion svrcore),g" \
	    -e "s,%MOZLDAP_VERSION%,${PV},g" \
	    ${PN}.pc.in > ${PN}.pc
	make install
	rm -rf "${S}"/mozilla/dist/bin/lib*.so
	rm -rf "${S}"/mozilla/dist/public/ldap-private

	exeinto /usr/$(get_libdir)/mozldap
	doexe "${S}"/mozilla/dist/lib/*so*
	doexe "${S}"/mozilla/dist/lib/*.a
	doexe "${S}"/mozilla/dist/bin/*
	# move the headers around
	insinto /usr/include/mozldap
	doins "${S}"/mozilla/dist/public/ldap/*.h
	# add sample config
	insinto /usr/share/mozldap
	doins "${S}"/mozilla/dist/etc/*.conf
	#and while at it move them to files with versions-ending
	#and link them back :)
	cd "${D}"/usr/$(get_libdir)/mozldap
	#create compatibility Link
	ln -sf libldap$(get_major_version ${PV})$(get_version_component_range 2 ${PV}).so liblber$(get_major_version ${PV})$(get_version_component_range 2 ${PV}).so
	#so lets move
	for file in *.so; do
		mv ${file} ${file}.$(get_major_version ${PV}).$(get_version_component_range 2 ${PV})
		ln -s ${file}.$(get_major_version ${PV}).$(get_version_component_range 2 ${PV}) ${file}
		ln -s ${file}.$(get_major_version ${PV}).$(get_version_component_range 2 ${PV}) ${file}.$(get_major_version ${PV})
	done
	# cope with libraries being in /usr/lib/mozldap
	dodir /etc/env.d
	echo "LDPATH=/usr/$(get_libdir)/mozldap" > "${D}"/etc/env.d/08mozldap

	# create pkg-config file
	insinto /usr/$(get_libdir)/pkgconfig/
	doins "${S}"/mozilla/directory/c-sdk/mozldap.pc
}
