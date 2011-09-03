# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="Merge this to pull all official LeechCraft plugins which are considered to be useful."

HOMEPAGE="http://leechcraft.org/"

SLOT="0"
KEYWORDS=""
LICENSE="GPL-3"
IUSE="kde"

RDEPEND="
		=app-editors/leechcraft-popishu-${PV}
		=media-video/leechcraft-lmp-${PV}
		=net-analyzer/leechcraft-networkmonitor-${PV}
		=net-ftp/leechcraft-lcftp-${PV}
		=net-im/leechcraft-azoth-${PV}
		=net-misc/leechcraft-advancednotifications-${PV}
		kde? ( =net-misc/leechcraft-anhero-${PV} )
		=net-misc/leechcraft-auscrie-${PV}
		=net-misc/leechcraft-core-${PV}
		=net-misc/leechcraft-cstp-${PV}
		=net-misc/leechcraft-dbusmanager-${PV}
		=net-misc/leechcraft-glance-${PV}
		=net-misc/leechcraft-historyholder-${PV}
		=net-misc/leechcraft-kinotify-${PV}
		=net-misc/leechcraft-lackman-${PV}
		=net-misc/leechcraft-newlife-${PV}
		=net-misc/leechcraft-qrosp-${PV}
		=net-misc/leechcraft-secman-${PV}
		=net-misc/leechcraft-summary-${PV}
		=net-misc/leechcraft-tabpp-${PV}
		=net-misc/leechcraft-tabslist-${PV}
		=net-news/leechcraft-aggregator-${PV}
		=net-p2p/leechcraft-bittorrent-${PV}
		=www-client/leechcraft-deadlyrics-${PV}
		=www-client/leechcraft-poshuku-${PV}
		=www-client/leechcraft-vgrabber-${PV}
		=www-misc/leechcraft-seekthru-${PV}
		"
DEPEND=""
