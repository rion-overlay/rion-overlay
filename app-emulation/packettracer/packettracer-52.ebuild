# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils fdo-mime

DESCRIPTION="Cisco's Packet Tracer"
HOMEPAGE="https://www.cisco.com/web/learning/netacad/course_catalog/PacketTracer.html"
SRC_URI="http://cisco.netacad.net/cnams/resourcewindow/noncurr/downloadTools/app_files/PacketTracer"${PV}".tar.gz"
MY_PN="PacketTracer"
MY_NAME="${MY_PN}""${PV}"

S="${WORKDIR}"/"${MY_NAME}"

RESTRICT="fetch mirror strip"
#PROPERTIES="interactive"
LICENSE="Cisco_EULA"
SLOT="${PV}"
KEYWORDS="~x86 ~amd64"
IUSE="+doc online-exam"
DEPEND="app-arch/gzip"
RDEPEND="doc? ( www-plugins/adobe-flash  )
		amd64? ( >=app-emulation/emul-linux-x86-qtlibs-20080316 )
		x11-base/xorg-x11
		!<app-emulation/packettracer-52"

pkg_nofetch () {
	ewarn "For fetch this file,you have cisco account"
	ewarn "you is CC** :) or cisco web-learning  student or instructor"
	ewarn "or you  sale cisco hardware, etc..  "
	einfo "Also"
	einfo "For download this file , point  you browser in http://cisco.netacad.net/"
	einfo " and login this site, go to PacketTracer image"
	einfo "and download it"
	einfo "Packet Tracer v5.1 Application + Tutorial Generic links"
	einfo "(tar.gz) file"
}
src_prepare(){
#	cd "${S}"
	rm -rf install set_ptenv.sh tpl.linguist  \
				tpl.packettracer extensions/ptaplayer || die "Not remove files"
# Disable automatic update :)
	rm -fr ./extensions/PTUpdater/update_url.txt || die \
											"Disable automatic update failed"
	if use !doc
	then
		rm -fr ./help || die
	fi
	if use !online-exam
	then
		rm -fr ./extensions/ptaplayer || die
	fi
# Remove QTLingust :); You really need translate packettraiser ?
#				If yes, use system QT Lingust.
	rm ./bin/linguist || die
}

src_install () {
	declare PKT_HOME="/opt/pt/"
	dodir "${PKT_HOME}"
	cd "${S}/"
	cp -R "${S}/" "${D}"${PKT_HOME} || die "Install failed!"

	cd "${D}${PKT_HOME}/${MY_NAME}"
	doicon "./art/"{app,pka,pkt,pkz}.{ico,png}
make_wrapper packettracer "./bin/PacketTracer5" "${PKT_HOME}${MY_NAME}" "${PKT_HOME}${MY_NAME}/lib"
make_desktop_entry "packettracer"  "PacketTracer" "app" "Education;Emulator"
	insinto /usr/share/mime/applications
	doins "${D}${PKT_HOME}/${MY_NAME}"/bin/*.xml
	rm -f "${D}${PKT_HOME}/${MY_NAME}"/bin/*.xml
	dodir /etc/evn.d
	echo PT5HOME="${PKT_HOME}"/"${MY_NAME}" > "${D}"/etc/evn.d/50-"${MY_PN}" || die
	dodoc eula.txt
}

pkg_postinst(){
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
if use doc ; then
		einfo " You have doc USE flag"
	    einfo " For use documentaion , please"
		ewarn " install you prefered brauser and  flashplayer support"
	    einfo " such mozilla or konqerror"
fi

	einfo ""
	einfo ""
	einfo " If you have multiuser enviroment"
	einfo " you mist configure you firewall"
	einfo " additional information see "
	einfo " in packettracer user manual "
}

pkg_postrm() {
fdo-mime_desktop_database_update
fdo-mime_mime_database_update
}
