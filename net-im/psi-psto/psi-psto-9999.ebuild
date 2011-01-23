# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: mva$

EAPI="2"
inherit mercurial psiplus-plugin

DESCRIPTION="Psi plugin for psto.net service"
SCM="mercurial"
EHG_REPO_URI="https://bitbucket.org/werehuman/psi-psto-plugin"
KEYWORDS=""
IUSE=""


src_unpack() {
mercurial_fetch
}
