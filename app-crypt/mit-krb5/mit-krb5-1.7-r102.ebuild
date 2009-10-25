# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/mit-krb5/mit-krb5-1.7-r1.ebuild,v 1.1 2009/07/29 08:27:48 ssuominen Exp $

EAPI="2"

inherit eutils flag-o-matic versionator autotools

PATCHV="0.6"
MY_P=${P/mit-}
P_DIR=$(get_version_component_range 1-2)
DESCRIPTION="MIT Kerberos V"
HOMEPAGE="http://web.mit.edu/kerberos/www/"
SRC_URI="http://web.mit.edu/kerberos/dist/krb5/${P_DIR}/${MY_P}-signed.tar
http://dev.gentoo.org/~mueli/kerberos/${P}-patches-${PATCHV}.tar.bz2"
#	mirror://gentoo/${P}-patches-${PATCHV}.tar.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc ldap"

RDEPEND="!virtual/krb5
	>=sys-libs/e2fsprogs-libs-1.41.0
	ldap? ( net-nds/openldap )"
DEPEND="${RDEPEND}
	doc? ( virtual/latex-base )"

S=${WORKDIR}/${MY_P}/src

PROVIDE="virtual/krb5"

src_unpack() {
	unpack ${A}
	unpack ./${MY_P}.tar.gz
}
src_prepare() {
	EPATCH_EXCLUDE="0001_all_lazyldflags.patch" EPATCH_SUFFIX="patch" \
		epatch "${PATCHDIR}"
	einfo "Regenerating configure scripts (be patient)"
	eautoconf
	eautoheader
	eautomake 
	elibtoolize

	#./util/reconf --force
}

src_configure() {
	append-flags "-I/usr/include/et"
	econf \
		$(use_with ldap) \
		--without-krb4 \
		--enable-shared \
		--with-system-et --with-system-ss \
		--enable-dns-for-realm \
		--enable-kdc-replay-cache || die
}
src_compile() {
	emake -j1 || die

	if use doc ; then
		cd ../doc
		for dir in api implement ; do
			make -C "${dir}" || die
		done
	fi
}

src_test() {
	einfo "Tests do not run in sandbox, they need mit-krb5 to be already installed to test it."
}

src_install() {
	emake \
		DESTDIR="${D}" \
		EXAMPLEDIR=/usr/share/doc/${PF}/examples \
		install || die

	keepdir /var/lib/krb5kdc

	cd ..
	dodoc README
	dodoc doc/*.ps
	doinfo doc/*.info*
	dohtml -r doc/*

	use doc && dodoc doc/{api,implement}/*.ps

	for i in {telnetd,ftpd} ; do
		mv "${D}"/usr/share/man/man8/${i}.8 "${D}"/usr/share/man/man8/k${i}.8
		mv "${D}"/usr/sbin/${i} "${D}"/usr/sbin/k${i}
	done

	for i in {rcp,rlogin,rsh,telnet,ftp} ; do
		mv "${D}"/usr/share/man/man1/${i}.1 "${D}"/usr/share/man/man1/k${i}.1
		mv "${D}"/usr/bin/${i} "${D}"/usr/bin/k${i}
	done

	newinitd "${FILESDIR}"/mit-krb5kadmind.initd mit-krb5kadmind
	newinitd "${FILESDIR}"/mit-krb5kdc.initd mit-krb5kdc
	newconfd "${FILESDIR}"/mit-krb5kdc.confd mit-krb5kdc

	insinto /etc
	newins "${D}/usr/share/doc/${PF}/examples/krb5.conf" krb5.conf.example
	newins "${D}/usr/share/doc/${PF}/examples/kdc.conf" kdc.conf.example

	if use ldap; then
		insinto /etc/openldap/schema/
		doins "${S}"/plugins/kdb/ldap/libkdb_ldap/kerberos.schema
	fi

}
