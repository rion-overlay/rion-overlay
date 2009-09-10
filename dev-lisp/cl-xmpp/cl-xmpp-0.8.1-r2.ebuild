# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit common-lisp-2

DESCRIPTION="Common Lisp package to XMPP"
HOMEPAGE="http://www.cliki.net/cl-xmpp"
SRC_URI="http://common-lisp.net/project/${PN}/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="sasl tls"
RDEPEND="
	|| ( dev-lisp/trivial-sockets dev-lisp/cl-trivial-sockets )
	|| ( dev-lisp/cxml dev-lisp/cl-cxml )
	|| ( dev-lisp/ironclad dev-lisp/cl-ironclad )
	sasl? ( dev-lisp/cl-base64 dev-lisp/cl-sasl )
	tls? ( dev-lisp/cl-base64 dev-lisp/cl-plus-ssl )"
DEPEND="${RDEPEND}"

src_compile() {
	return
}
