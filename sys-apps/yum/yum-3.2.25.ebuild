# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
NEED_PYTHON=1
inherit python eutils multilib

DESCRIPTION="automatic updater and package installer/remover for rpm systems"
HOMEPAGE="http://yum.baseurl.org/"
SRC_URI="http://yum.baseurl.org/download/${PV:0:3}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="test? ( dev-python/nose )
		>=dev-lang/python-2.6[sqlite]
		>=app-arch/rpm-5.1.9[python]
		dev-python/sqlitecachec
		dev-python/celementtree
		dev-libs/libxml2[python]
		dev-python/urlgrabber"

RDEPEND=">=dev-lang/python-2.6[sqlite]
	>=app-arch/rpm-5.1.9[python]
	dev-python/sqlitecachec
	dev-python/celementtree
	dev-libs/libxml2[python]
	dev-python/urlgrabber"
python_need_rebuild

src_install() {
	python_set_active_version 2
	emake install DESTDIR="${D}" || die
	rm -r "${D}"/etc/rc.d || die
	find "${D}" -name '*.py[co]' -print0 | xargs -0 rm -f
}

pkg_postinst() {
	python_version
	python_mod_optimize \
		/usr/$(get_libdir)/python${PYVER}/site-packages/{yum,rpmUtils} \
		/usr/share/yum-cli
}

pkg_postrm() {
	python_mod_cleanup /usr/$(get_libdir)/python*/site-packages/{yum,rpmUtils} /usr/share/yum-cli
}
