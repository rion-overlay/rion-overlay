# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

MY_PN="PacketTracer"
MY_P="${MY_PN}${PV}"

inherit eutils fdo-mime

DESCRIPTION="Cisco's Packet Tracer"
HOMEPAGE="https://www.cisco.com/web/learning/netacad/course_catalog/PacketTracer.html"
SRC_URI="http://cisco.netacad.net/cnams/resourcewindow/noncurr/downloadTools/app_files/PacketTracer${PV}.tar.gz"

RESTRICT="fetch mirror strip"
LICENSE="Cisco_EULA"

SLOT="${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="doc online-exam"

DEPEND="app-arch/gzip
		amd64? ( >=app-emulation/emul-linux-x86-qtlibs-20081109 )"

RDEPEND="doc? ( www-plugins/adobe-flash  )
		amd64? ( >=app-emulation/emul-linux-x86-qtlibs-20081109 )
		!<app-emulation/packettracer-52"

S="${WORKDIR}/${MY_P}"

pkg_nofetch () {
	ewarn "To fetch sources you need cisco account which is available in case"
	ewarn "you are cisco web-learning student, instructor or you sale cisco hardware, etc..  "
	einfo ""
	einfo ""
	einfo "After that point your browser at http://cisco.netacad.net/"
	einfo "ogin, go to PacketTracer image and download:"
	einfo "Packet Tracer v5.1 Application + Tutorial Generic links (tar.gz) file"
	einfo ""
}

src_prepare(){

	for file in install set_ptenv.sh tpl.linguist tpl.packettracer \
							extensions/ptaplayer bin/linguist; do
		 rm -fr  ${file} || die "unable to rm ${file}"
	done
}

src_install () {

	local PKT_HOME="/opt/pt/"

	dodir "${PKT_HOME}"
	cp -R "${S}/"   "${D}${PKT_HOME}"  || die "Install failed!"

	doicon "${S}/art/"{app,pka,pkt,pkz}.{ico,png}

	make_wrapper packettracer "./bin/PacketTracer5" "${PKT_HOME}${MY_NAME}" "${PKT_HOME}${MY_NAME}/lib"
	make_desktop_entry "packettracer"  "PacketTracer" "app" "Education;Emulator"

	insinto /usr/share/mime/applications
	doins "${D}${PKT_HOME}${MY_NAME}bin/"*.xml

	rm -f "${D}${PKT_HOME}${MY_NAME}bin/"*.xml

	dodir /etc/env.d
	echo PT5HOME="${PKT_HOME}/${MY_NAME}" > "${D}/etc/env.d/50-${MY_PN}" || die
}

pkg_postinst(){

	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update

	if use doc ; then
		einfo " You have doc USE flag"
	    einfo " For use documentaion , please"
		ewarn " install you prefered brouser and  flashplayer support"
	    einfo " such mozilla or konqerror"
	fi

	einfo ""
	einfo " If you have multiuser enviroment"
	einfo " you mist configure you firewall to use UPnP protocol."
	einfo " Additional information see in packettracer user manual "

}

pkg_postrm() {

	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update

}
