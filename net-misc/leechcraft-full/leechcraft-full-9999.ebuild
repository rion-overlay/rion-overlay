# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit leechcraft

DESCRIPTION="Merge this to pull all official LeechCraft plugins which are considered to be useful."

HOMEPAGE="http://leechcraft.org/"

LICENSE="GPL-3"
SLOT="0"
IUSE="kde"
RDEPEND="=net-misc/leechcraft-cstp-${PV}
		=net-misc/leechcraft-core-${PV}
		=net-misc/leechcraft-summary-${PV}
		=net-misc/leechcraft-qrosp-${PV}
		=app-editors/leechcraft-popishu-${PV}
		=net-misc/leechcraft-auscrie-${PV}
		kde? ( =net-misc/leechcraft-anhero-${PV} )
		=net-misc/leechcraft-kinotify-${PV}
		=net-misc/leechcraft-lackman-${PV}
		=net-misc/leechcraft-dbusmanager-${PV}
		=net-misc/leechcraft-newlife-${PV}
		=net-misc/leechcraft-tabpp-${PV}
		=net-analyzer/leechcraft-networkmonitor-${PV}
		=net-p2p/leechcraft-bittorrent-${PV}
		=net-ftp/leechcraft-lcftp-${PV}
		=net-misc/leechcraft-historyholder-${PV}
		=net-news/leechcraft-aggregator-${PV}
		=net-im/leechcraft-azoth-${PV}
		=www-client/leechcraft-deadlyrics-${PV}
		=www-client/leechcraft-poshuku-${PV}
		=www-client/leechcraft-vgrabber-${PV}
		=www-misc/leechcraft-seekthru-${PV}
		"
DEPEND=""
