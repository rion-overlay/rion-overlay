# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit rpm eutils multilib

DESCRIPTION="OpenPegasus WBEM Services for Linux"
HOMEPAGE="http://www.openpegasus.org"
SRC_URI="mirror://fedora-dev/development/rawhide/Everything/source/tree/Packages/t/${P}-39.fc27.src.rpm"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-libs/icu
	net-libs/openslp
	dev-libs/openssl:0
	"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/pegasus
# upstream tarball has wrong structure - pegasus/pegasus/

src_unpack() {
	srcrpm_unpack
	cd "${WORKDIR}"/pegasus/ || die
	mv "${WORKDIR}"/pegasus/pegasus/*  . ||die
}

src_prepare() {
	rpm_spec_epatch
	einfo "Apply Gentoo specific patch"
}

src_compile() {
	export PEGASUS_HARDWARE_PLATFORM=LINUX_X86_64_GNU
	export PEGASUS_PLATFORM=LINUX_X86_64_GNU
	export OPENSSL_HOME=/usr
	export PEGASUS_PEM_DIR=/etc/Pegasus
	export PEGASUS_SSL_CERT_FILE=server.pem
	export PEGASUS_SSL_KEY_FILE=file.pem
	export PEGASUS_SSL_TRUSTSTORE=client.pem
	export PAM_CONFIG_DIR=/etc/pam.d
	export PEGASUS_CONFIG_DIR=/etc/Pegasus
	export PEGASUS_VARDATA_DIR=/var/lib/Pegasus
	export PEGASUS_VARDATA_CACHE_DIR=/var/lib/Pegasus/cache
	export PEGASUS_LOCAL_DOMAIN_SOCKET_PATH=/var/run/tog-pegasus/socket/cimxml.socket
	export PEGASUS_CIMSERVER_START_FILE=/var/run/tog-pegasus/cimserver.pid
	export PEGASUS_TRACE_FILE_PATH=/var/lib/Pegasus/cache/trace/cimserver.trc
	export PEGASUS_CIMSERVER_START_LOCK_FILE=/var/run/tog-pegasus/cimserver_start.lock
	export PEGASUS_REPOSITORY_DIR=/var/lib/Pegasus/repository
	export PEGASUS_PREV_REPOSITORY_DIR_NAME=prev_repository
	export PEGASUS_REPOSITORY_PARENT_DIR=/var/lib/Pegasus
	export PEGASUS_PREV_REPOSITORY_DIR=/var/lib/PegasusXXX/prev_repository
	export PEGASUS_SBIN_DIR=/usr/sbin
	export PEGASUS_DOC_DIR=/usr/share/doc/${P}
	export PEGASUS_RPM_ROOT="${S}"
	export PEGASUS_RPM_HOME=${WORKDIR}/build
	export PEGASUS_INSTALL_LOG=/var/lib/Pegasus/log/install.log
	# PATH=$PEGASUS_HOME/bin:$PATH
	export	PEGASUS_ROOT="${S}"
	export PEGASUS_HOME=${S}
	export	PEGASUS_ARCH_LIB=$PEGASUS_ARCH_LIB
	export	PEGASUS_ENVVAR_FILE=${S}/env_var_Linux.status
	export	OPENSSL_HOME=$OPENSSL_HOME
	export	OPENSSL_BIN=$OPENSSL_BIN
	export	LD_LIBRARY_PATH=$PEGASUS_HOME/lib
	export	PEGASUS_EXTRA_C_FLAGS="$CFLAGS -fPIC -g -Wall -Wno-unused"
	export	PEGASUS_EXTRA_CXX_FLAGS="$PEGASUS_EXTRA_C_FLAGS"
	export	PEGASUS_ROOT="${S}"
	export	PEGASUS_EXTRA_LINK_FLAGS="$LDFLAG"
	export	PEGASUS_EXTRA_PROGRAM_LINK_FLAGS="-g -pie -Wl,-z,relro,-z,now,-z,nodlopen,-z,noexecstack"
	export	SYS_INCLUDES=-I/usr/kerberos/include
	export	PEGASUS_PLATFORM=LINUX_X86_64_GNU
	ROOT=${S} emake -f Makefile.Release create_ProductVersionFile
	ROOT=${S} emake -f Makefile.Release create_CommonProductDirectoriesInclude
	ROOT=${S} emake -f Makefile.Release create_ConfigProductDirectoriesInclude
	ROOT=${S} emake -f Makefile.Release all
	ROOT=${S} emake -f Makefile.Release repository
}

src_install() {
	export PEGASUS_HARDWARE_PLATFORM=LINUX_X86_64_GNU
	export PEGASUS_PLATFORM=LINUX_X86_64_GNU
	export OPENSSL_HOME=/usr
	export PEGASUS_PEM_DIR=/etc/Pegasus
	export PEGASUS_SSL_CERT_FILE=server.pem
	export PEGASUS_SSL_KEY_FILE=file.pem
	export PEGASUS_SSL_TRUSTSTORE=client.pem
	export PAM_CONFIG_DIR=/etc/pam.d
	export PEGASUS_CONFIG_DIR=/etc/Pegasus
	export PEGASUS_VARDATA_DIR=/var/lib/Pegasus
	export PEGASUS_VARDATA_CACHE_DIR=/var/lib/Pegasus/cache
	export
PEGASUS_LOCAL_DOMAIN_SOCKET_PATH=/var/run/tog-pegasus/socket/cimxml.socket
	export PEGASUS_CIMSERVER_START_FILE=/var/run/tog-pegasus/cimserver.pid
	export PEGASUS_TRACE_FILE_PATH=/var/lib/Pegasus/cache/trace/cimserver.trc
	export
PEGASUS_CIMSERVER_START_LOCK_FILE=/var/run/tog-pegasus/cimserver_start.lock
	export PEGASUS_REPOSITORY_DIR=/var/lib/Pegasus/repository
	export PEGASUS_PREV_REPOSITORY_DIR_NAME=prev_repository
	export PEGASUS_REPOSITORY_PARENT_DIR=/var/lib/Pegasus
	export PEGASUS_PREV_REPOSITORY_DIR=/var/lib/PegasusXXX/prev_repository
	export PEGASUS_SBIN_DIR=/usr/sbin
	export PEGASUS_DOC_DIR=/usr/share/doc/${P}
	export PEGASUS_RPM_ROOT="${S}"
	export PEGASUS_RPM_HOME=${WORKDIR}/build
	export PEGASUS_INSTALL_LOG=/var/lib/Pegasus/log/install.log
	# PATH=$PEGASUS_HOME/bin:$PATH
	export  PEGASUS_ROOT="${S}"
	export PEGASUS_HOME=${S}
	export  PEGASUS_ARCH_LIB=$PEGASUS_ARCH_LIB
	export  PEGASUS_ENVVAR_FILE=${S}/env_var_Linux.status
	export  OPENSSL_HOME=$OPENSSL_HOME
	export  OPENSSL_BIN=$OPENSSL_BIN
	export  LD_LIBRARY_PATH=$PEGASUS_HOME/lib
	export  PEGASUS_EXTRA_C_FLAGS="$CFLAGS -fPIC -g -Wall -Wno-unused"
	export  PEGASUS_EXTRA_CXX_FLAGS="$PEGASUS_EXTRA_C_FLAGS"
	export  PEGASUS_ROOT="${S}"
	export  PEGASUS_EXTRA_LINK_FLAGS="$LDFLAG"
	export  PEGASUS_EXTRA_PROGRAM_LINK_FLAGS="-g -pie -Wl,-z,relro,-z,now,-z,nodlopen,-z,noexecstack"
	export  SYS_INCLUDES=-I/usr/kerberos/include
	export  PEGASUS_PLATFORM=LINUX_X86_64_GNU

	emake -f Makefile.Release stage PEGASUS_STAGING_DIR="${D}"

}
